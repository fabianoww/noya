import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import 'package:file_selector/file_selector.dart';
import 'package:noya2/dao/noya_database.dart';
import 'package:sqflite_migration/sqflite_migration.dart';

class BackupService {

  Future<void> createBackup() async {
    //String dbPath = '/data/user/0/com.fbnolvr.noya2/databases/noya.db';
    final databasesPath = await getDatabasesPath();
    final dbPath = join(databasesPath, 'noya.db');
    Directory filesDir = await getApplicationDocumentsDirectory();

    // Verificando se o diretório de backup existe
    Directory backupsDir = Directory(join(filesDir.path, 'backups'));
    if (!await backupsDir.exists()) {
      await backupsDir.create(recursive: true);
    }

    backupsDir.list().forEach((file) {
      file.delete();
    });

    String timestamp = DateFormat('yyyy-MM-dd-HH-mm-ss').format(DateTime.now());
    String destPath = join(backupsDir.path, 'noya_backup_$timestamp.db');

    // Copy the file
    File sourceFile = File(dbPath);
    if (await sourceFile.exists()) {
      await sourceFile.copy(destPath);
    }

    final params = ShareParams(
      text: 'Noya Backup',
      files: [XFile(destPath)],
    );

    await SharePlus.instance.share(params);
  }


  Future<bool> loadBackup() async {
    const XTypeGroup typeGroup = XTypeGroup(
      label: 'DB',
      extensions: <String>['db'],
      uniformTypeIdentifiers: <String>['public.db'],
    );
    final XFile? file = await openFile(
      acceptedTypeGroups: <XTypeGroup>[typeGroup],
    );
    if (file == null) {
      return false;
    }

    try {
      await _restoreBackup(file);
      return true;
    } on BackupVersionException {
      rethrow;
    } on BackupRestoreException {
      rethrow;
    } on DatabaseException catch (error, stackTrace) {
      Error.throwWithStackTrace(BackupRestoreException(error), stackTrace);
    } on FileSystemException catch (error, stackTrace) {
      Error.throwWithStackTrace(BackupRestoreException(error), stackTrace);
    } on FormatException catch (error, stackTrace) {
      Error.throwWithStackTrace(BackupRestoreException(error), stackTrace);
    } on StateError catch (error, stackTrace) {
      Error.throwWithStackTrace(BackupRestoreException(error), stackTrace);
    }
  }

  Future<void> _restoreBackup(XFile backupFile) async {
    final databasesPath = await getDatabasesPath();
    final timestamp = DateTime.now().microsecondsSinceEpoch;
    final currentDatabase = File(join(databasesPath, 'noya.db'));
    final stagingDatabase = File(
      join(databasesPath, 'noya_restore_$timestamp.db'),
    );
    final previousDatabase = File(
      join(databasesPath, 'noya_previous_$timestamp.db'),
    );
    var previousDatabaseExists = false;

    try {
      await backupFile.saveTo(stagingDatabase.path);

      final sourceDatabase = await openDatabase(
        stagingDatabase.path,
        singleInstance: false,
      );
      late int backupVersion;
      try {
        backupVersion = await sourceDatabase.getVersion();
        await _validateBackupSchema(sourceDatabase, currentVersion: false);
      } finally {
        await sourceDatabase.close();
      }

      final applicationDatabase = await NoyaDatabase.getInstance();
      final currentDatabaseVersion = await applicationDatabase.getVersion();
      if (currentDatabaseVersion != NoyaDatabase.schemaVersion) {
        throw StateError('Application database is not at the current schema.');
      }
      if (backupVersion < 1) {
        throw const FormatException('Backup has no supported schema version.');
      }
      if (backupVersion > currentDatabaseVersion) {
        throw BackupVersionException(
          backupVersion,
          currentDatabaseVersion,
        );
      }

      final migratedDatabase = await openDatabaseWithMigration(
        stagingDatabase.path,
        NoyaDatabase.migrationConfig,
      );
      try {
        final migratedVersion = await migratedDatabase.getVersion();
        if (migratedVersion != NoyaDatabase.schemaVersion) {
          throw StateError('Backup migration did not reach the current schema.');
        }
        await _validateBackupSchema(migratedDatabase, currentVersion: true);
      } finally {
        await migratedDatabase.close();
      }

      await NoyaDatabase.close();
      var stagingInstalled = false;
      try {
        if (await currentDatabase.exists()) {
          await currentDatabase.rename(previousDatabase.path);
          previousDatabaseExists = true;
        }
        await stagingDatabase.rename(currentDatabase.path);
        stagingInstalled = true;

        final restoredDatabase = await NoyaDatabase.getInstance();
        if (await restoredDatabase.getVersion() != NoyaDatabase.schemaVersion) {
          throw StateError('Restored database has an unexpected schema version.');
        }
      } catch (error, stackTrace) {
        await NoyaDatabase.close();
        if (stagingInstalled && await currentDatabase.exists()) {
          await currentDatabase.delete();
        }
        if (previousDatabaseExists && await previousDatabase.exists()) {
          await previousDatabase.rename(currentDatabase.path);
          previousDatabaseExists = false;
        }
        if (await currentDatabase.exists()) {
          await NoyaDatabase.getInstance();
        }
        Error.throwWithStackTrace(error, stackTrace);
      }

      if (previousDatabaseExists) {
        await previousDatabase.delete();
        previousDatabaseExists = false;
      }
    } finally {
      if (await stagingDatabase.exists()) {
        await stagingDatabase.delete();
      }
      if (!previousDatabaseExists && await previousDatabase.exists()) {
        await previousDatabase.delete();
      }
    }
  }

  Future<void> _validateBackupSchema(
    Database database, {
    required bool currentVersion,
  }) async {
    final expectedTables = <String, Set<String>>{
      'configuration': {'key', 'value'},
      'credit_card': {'id', 'label', 'close_day', 'due_day'},
      'category': {'id', 'label', 'type', 'icon'},
      'transaction_record': {
        'id',
        'label',
        'value',
        'date',
        'create_date',
        'installments',
        'category_id',
        'credit_card_id',
        'parent_transaction_id',
        if (currentVersion) ...{
          'is_private',
          'author_uuid',
          'event_uuid',
          'sync_status',
        },
      },
      if (currentVersion) ...{
        'family_group': {
          'id',
          'administrator_uuid',
          'currency',
          'active',
          'created_at',
        },
        'family_member': {'uuid', 'name', 'role', 'active'},
        'family_membership_period': {'id', 'member_uuid', 'joined_at'},
        'family_sync_queue': {
          'id',
          'event_uuid',
          'operation',
          'payload_ciphertext',
          'status',
          'created_at',
          'attempts',
        },
      },
    };

    for (final entry in expectedTables.entries) {
      final columns = await database.rawQuery(
        'PRAGMA table_info("${entry.key}")',
      );
      final actualColumns = columns.map((row) => row['name'] as String).toSet();
      if (!entry.value.every(actualColumns.contains)) {
        throw FormatException(
          'Backup is missing required columns in ${entry.key}.',
        );
      }
    }
  }
}

class BackupVersionException implements Exception {
  final int backupVersion;
  final int currentDatabaseVersion;

  const BackupVersionException(
    this.backupVersion,
    this.currentDatabaseVersion,
  );
}

class BackupRestoreException implements Exception {
  final Object cause;

  const BackupRestoreException(this.cause);
}