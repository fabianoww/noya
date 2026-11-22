import 'package:noya2/dao/noya_database.dart';
import 'package:noya2/model/family_group.dart';
import 'package:noya2/model/family_member.dart';
import 'package:noya2/model/family_action_result.dart';
import 'package:sqflite/sqflite.dart';

class FamilyDao {
  static Future<String?> getOwnMemberUuid() async {
    final db = await NoyaDatabase.getInstance();
    final rows = await db.query(
      'configuration',
      columns: ['value'],
      where: 'key = ?',
      whereArgs: ['family_member_uuid'],
      limit: 1,
    );
    return rows.isEmpty ? null : rows.first['value'] as String?;
  }

  static Future<FamilyGroup?> getActiveGroup() async {
    final db = await NoyaDatabase.getInstance();
    final rows = await db.query('family_group', where: 'active = 1', limit: 1);
    if (rows.isEmpty) return null;

    final row = rows.first;
    return FamilyGroup(
      id: row['id'] as String,
      administratorUuid: row['administrator_uuid'] as String,
      currency: row['currency'] as String,
      name: row['name'] as String?,
      inviteToken: row['invite_token'] as String?,
      active: row['active'] == 1,
      createdAt: DateTime.parse(row['created_at'] as String),
    );
  }

  static Future<void> createGroup(
    FamilyGroup group,
    FamilyMember administrator,
  ) async {
    final db = await NoyaDatabase.getInstance();
    await db.transaction((txn) async {
      await txn.delete('family_group');
      await txn.insert('configuration', {
        'key': 'family_member_uuid',
        'value': administrator.uuid,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
      await txn.insert('family_group', {
        'id': group.id,
        'name': group.name,
        'administrator_uuid': group.administratorUuid,
        'currency': group.currency,
        'invite_token': group.inviteToken,
        'active': 1,
        'created_at': group.createdAt.toIso8601String(),
      });
      await txn.delete('family_membership_period');
      await txn.delete('family_member');
      await txn.update('transaction_record', {
        'is_private': 1,
        'author_uuid': administrator.uuid,
      });
      await txn.insert('family_member', {
        'uuid': administrator.uuid,
        'name': administrator.name,
        'firebase_uid': administrator.firebaseUid,
        'public_key': administrator.publicKey,
        'signing_public_key': administrator.signingPublicKey,
        'role': 'administrator',
        'joined_at': administrator.joinedAt?.toIso8601String(),
        'active': 1,
      });
      await txn.insert('family_membership_period', {
        'member_uuid': administrator.uuid,
        'joined_at':
            administrator.joinedAt?.toIso8601String() ??
            group.createdAt.toIso8601String(),
      });
    });
  }

  static Future<List<FamilyMember>> listMembers({
    bool onlyActive = false,
  }) async {
    final db = await NoyaDatabase.getInstance();
    final rows = await db.query(
      'family_member',
      where: onlyActive ? 'active = 1' : null,
      orderBy: 'joined_at ASC',
    );
    return rows
        .map(
          (row) => FamilyMember(
            uuid: row['uuid'] as String,
            name: row['name'] as String,
            firebaseUid: row['firebase_uid'] as String?,
            publicKey: row['public_key'] as String?,
            signingPublicKey: row['signing_public_key'] as String?,
            role: row['role'] as String,
            joinedAt: row['joined_at'] == null
                ? null
                : DateTime.parse(row['joined_at'] as String),
            leftAt: row['left_at'] == null
                ? null
                : DateTime.parse(row['left_at'] as String),
            active: row['active'] == 1,
          ),
        )
        .toList();
  }

  static Future<void> addMember(FamilyMember member) async {
    final db = await NoyaDatabase.getInstance();
    await db.transaction((txn) async {
      final values = {
        'uuid': member.uuid,
        'name': member.name,
        'firebase_uid': member.firebaseUid,
        'public_key': member.publicKey,
        'signing_public_key': member.signingPublicKey,
        'role': member.role,
        'joined_at': member.joinedAt?.toIso8601String(),
        'left_at': null,
        'active': 1,
      };
      final existing = await txn.query(
        'family_member',
        columns: ['uuid'],
        where: 'uuid = ?',
        whereArgs: [member.uuid],
        limit: 1,
      );
      if (existing.isEmpty) {
        await txn.insert('family_member', values);
      } else {
        await txn.update(
          'family_member',
          values,
          where: 'uuid = ?',
          whereArgs: [member.uuid],
        );
      }
      await txn.insert('family_membership_period', {
        'member_uuid': member.uuid,
        'joined_at':
            member.joinedAt?.toIso8601String() ??
            DateTime.now().toIso8601String(),
      });
    });
  }

  static Future<FamilyLeaveResult> leaveMember(
    String memberUuid, {
    required bool deleteOtherMembersHistory,
  }) async {
    final db = await NoyaDatabase.getInstance();
    final now = DateTime.now();
    return db.transaction((txn) async {
      final groups = await txn.query(
        'family_group',
        where: 'active = 1',
        limit: 1,
      );
      final members = await txn.query(
        'family_member',
        where: 'uuid = ? AND active = 1',
        whereArgs: [memberUuid],
        limit: 1,
      );
      if (groups.isEmpty || members.isEmpty) {
        return FamilyLeaveResult.memberNotActive;
      }

      final group = groups.first;
      final memberCountRows = await txn.rawQuery(
        'SELECT COUNT(*) AS count FROM family_member WHERE active = 1',
      );
      final memberCount = memberCountRows.first['count'] as int;
      final isAdministrator = group['administrator_uuid'] == memberUuid;
      if (isAdministrator && memberCount > 1) {
        return FamilyLeaveResult.administratorMustTransfer;
      }

      if (deleteOtherMembersHistory) {
        await txn.rawDelete(
          '''
          DELETE FROM transaction_record
          WHERE parent_transaction_id IN (
            SELECT id FROM transaction_record
            WHERE is_private = 0
              AND (author_uuid IS NULL OR author_uuid != ?)
          )
        ''',
          [memberUuid],
        );
        await txn.delete(
          'transaction_record',
          where: 'is_private = 0 AND (author_uuid IS NULL OR author_uuid != ?)',
          whereArgs: [memberUuid],
        );
      }

      await txn.update(
        'family_member',
        {'active': 0, 'left_at': now.toIso8601String()},
        where: 'uuid = ?',
        whereArgs: [memberUuid],
      );
      await txn.update(
        'family_membership_period',
        {'left_at': now.toIso8601String()},
        where: 'member_uuid = ? AND left_at IS NULL',
        whereArgs: [memberUuid],
      );
      await txn.update(
        'family_group',
        {'active': 0},
        where: 'id = ?',
        whereArgs: [group['id']],
      );
      return FamilyLeaveResult.left;
    });
  }

  static Future<FamilyAdministrationResult> transferAdministration(
    String currentAdministratorUuid,
    String newAdministratorUuid,
  ) async {
    final db = await NoyaDatabase.getInstance();
    return db.transaction((txn) async {
      final groups = await txn.query(
        'family_group',
        where: 'active = 1',
        limit: 1,
      );
      if (groups.isEmpty ||
          groups.first['administrator_uuid'] != currentAdministratorUuid) {
        return FamilyAdministrationResult.notAdministrator;
      }
      final targets = await txn.query(
        'family_member',
        where: 'uuid = ? AND active = 1',
        whereArgs: [newAdministratorUuid],
        limit: 1,
      );
      if (targets.isEmpty || newAdministratorUuid == currentAdministratorUuid) {
        return FamilyAdministrationResult.targetNotActive;
      }
      await txn.update(
        'family_member',
        {'role': 'member'},
        where: 'role = ?',
        whereArgs: ['administrator'],
      );
      await txn.update(
        'family_member',
        {'role': 'administrator'},
        where: 'uuid = ?',
        whereArgs: [newAdministratorUuid],
      );
      await txn.update('family_group', {
        'administrator_uuid': newAdministratorUuid,
      }, where: 'active = 1');
      return FamilyAdministrationResult.transferred;
    });
  }

  static Future<void> queueEvent({
    required String eventUuid,
    required String operation,
    String? payloadCiphertext,
  }) async {
    final db = await NoyaDatabase.getInstance();
    await db.insert('family_sync_queue', {
      'event_uuid': eventUuid,
      'operation': operation,
      'payload_ciphertext': payloadCiphertext,
      'status': 'pending',
      'created_at': DateTime.now().toIso8601String(),
    }, conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  static Future<List<Map<String, dynamic>>> getPendingEvents() async {
    final db = await NoyaDatabase.getInstance();
    return db.query(
      'family_sync_queue',
      where: 'status = ?',
      whereArgs: ['pending'],
      orderBy: 'created_at ASC',
    );
  }

  static Future<void> markEventDelivered(String eventUuid) async {
    final db = await NoyaDatabase.getInstance();
    await db.update(
      'family_sync_queue',
      {'status': 'delivered'},
      where: 'event_uuid = ?',
      whereArgs: [eventUuid],
    );
  }
}
