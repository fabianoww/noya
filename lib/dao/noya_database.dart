import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_migration/sqflite_migration.dart';

class NoyaDatabase {
  static NoyaDatabase? _noyaDatabase;
  static Database? _database;
  static final MigrationConfig migrationConfig = MigrationConfig(
    initializationScript: initialScript,
    migrationScripts: updates,
  );

  String? path;

  static int get schemaVersion => migrationConfig.migrationScripts.length + 1;

  static Future<void> close() async {
    final database = _database;
    if (database != null && database.isOpen) {
      await database.close();
    }
    _database = null;
  }

  static Future<Database> getInstance() {
    _noyaDatabase ??= NoyaDatabase();

    return _noyaDatabase!.database;
  }

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _open();
    return _database!;
  }

  Future<Database> _open() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'noya.db');
    return await openDatabaseWithMigration(path, migrationConfig);
  }
}

final List<String> initialScript = [
  '''
    CREATE TABLE configuration (
      "key" TEXT(20) NOT NULL,
      value TEXT(100),
      CONSTRAINT configuration_PK PRIMARY KEY ("key")
    )''',
  '''
    CREATE TABLE credit_card (
      id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
      label TEXT(50) NOT NULL,
      close_day TEXT(20) NOT NULL,
      due_day TEXT(20) NOT NULL
    )''',
  '''
    CREATE TABLE category (
      id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
      label TEXT(50) NOT NULL,
      "type" INTEGER NOT NULL,
      icon INTEGER
    )
    ''',
  '''
    CREATE TABLE transaction_record (
      id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
      label TEXT(50) NOT NULL,
      value REAL NOT NULL,
      date TEXT(20) NOT NULL,
      create_date TEXT(20) NOT NULL,
      installments INTEGER,
      category_id INTEGER NOT NULL,
      credit_card_id INTEGER,
      parent_transaction_id INTEGER,
      FOREIGN KEY(category_id) REFERENCES category(id),
      FOREIGN KEY(credit_card_id) REFERENCES credit_card(id),
      FOREIGN KEY(parent_transaction_id) REFERENCES transaction_record(id)
    )
    '''
];

final List<String> updates = [
  '''
    ALTER TABLE transaction_record
    ADD COLUMN is_private INTEGER NOT NULL DEFAULT 0
  ''',
  '''
    ALTER TABLE transaction_record
    ADD COLUMN author_uuid TEXT
  ''',
  '''
    ALTER TABLE transaction_record
    ADD COLUMN event_uuid TEXT
  ''',
  '''
    ALTER TABLE transaction_record
    ADD COLUMN sync_status TEXT NOT NULL DEFAULT 'local'
  ''',
  '''
    CREATE TABLE family_group (
      id TEXT PRIMARY KEY,
      name TEXT,
      administrator_uuid TEXT NOT NULL,
      currency TEXT NOT NULL,
      invite_token TEXT,
      active INTEGER NOT NULL DEFAULT 1,
      created_at TEXT NOT NULL
    )
  ''',
  '''
    CREATE TABLE family_member (
      uuid TEXT PRIMARY KEY,
      name TEXT NOT NULL,
      firebase_uid TEXT,
      public_key TEXT,
      signing_public_key TEXT,
      role TEXT NOT NULL DEFAULT 'member',
      joined_at TEXT,
      left_at TEXT,
      active INTEGER NOT NULL DEFAULT 1
    )
  ''',
  '''
    CREATE TABLE family_membership_period (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      member_uuid TEXT NOT NULL,
      joined_at TEXT NOT NULL,
      left_at TEXT,
      FOREIGN KEY(member_uuid) REFERENCES family_member(uuid)
    )
  ''',
  '''
    CREATE TABLE family_sync_queue (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      event_uuid TEXT NOT NULL UNIQUE,
      operation TEXT NOT NULL,
      payload_ciphertext TEXT,
      status TEXT NOT NULL DEFAULT 'pending',
      created_at TEXT NOT NULL,
      attempts INTEGER NOT NULL DEFAULT 0
    )
  ''',
  '''
    CREATE INDEX IF NOT EXISTS idx_transaction_family
    ON transaction_record(is_private, author_uuid, date)
  '''
];
