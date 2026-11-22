import 'dart:math';

import 'package:noya2/dao/family_dao.dart';
import 'package:noya2/model/family_group.dart';
import 'package:noya2/model/family_member.dart';
import 'package:noya2/model/family_action_result.dart';

class FamilyService {
  static String newUuid() {
    final random = Random.secure();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));
    bytes[6] = (bytes[6] & 0x0f) | 0x40;
    bytes[8] = (bytes[8] & 0x3f) | 0x80;
    final hex = bytes
        .map((byte) => byte.toRadixString(16).padLeft(2, '0'))
        .join();
    return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-${hex.substring(12, 16)}-${hex.substring(16, 20)}-${hex.substring(20)}';
  }

  static Future<FamilyGroup?> getActiveGroup() => FamilyDao.getActiveGroup();
  static Future<List<FamilyMember>> listMembers() =>
      FamilyDao.listMembers(onlyActive: true);
  static Future<String?> getOwnMemberUuid() => FamilyDao.getOwnMemberUuid();

  static Future<FamilyGroup> createGroup({
    required String administratorName,
    required String currency,
  }) async {
    final now = DateTime.now();
    final administrator = FamilyMember(
      uuid: newUuid(),
      name: administratorName,
      role: 'administrator',
      joinedAt: now,
    );
    final group = FamilyGroup(
      id: newUuid(),
      administratorUuid: administrator.uuid,
      currency: currency,
      inviteToken: newUuid(),
      createdAt: now,
    );
    await FamilyDao.createGroup(group, administrator);
    return group;
  }

  static Future<void> addApprovedMember({
    required String memberUuid,
    required String name,
  }) {
    return FamilyDao.addMember(
      FamilyMember(
        uuid: memberUuid,
        name: name,
        role: 'member',
        joinedAt: DateTime.now(),
      ),
    );
  }

  static Future<FamilyLeaveResult> leave(
    String memberUuid, {
    bool deleteOtherMembersHistory = false,
  }) => FamilyDao.leaveMember(
    memberUuid,
    deleteOtherMembersHistory: deleteOtherMembersHistory,
  );

  static Future<FamilyAdministrationResult> transferAdministration(
    String currentAdministratorUuid,
    String newAdministratorUuid,
  ) => FamilyDao.transferAdministration(
    currentAdministratorUuid,
    newAdministratorUuid,
  );

  static Future<List<Map<String, dynamic>>> getPendingEvents() =>
      FamilyDao.getPendingEvents();

  static String buildInvitePayload(FamilyGroup group) =>
      'noya://family/${group.id}/${group.inviteToken}';
}
