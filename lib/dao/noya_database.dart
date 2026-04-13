import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_migration/sqflite_migration.dart';

class NoyaDatabase {
  static NoyaDatabase? _noyaDatabase;
  static Database? _database;
  String? path;

  static Future<Database> getInstance() {
    if (_noyaDatabase == null) {
      _noyaDatabase = new NoyaDatabase();
    }

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
    return await openDatabaseWithMigration(path, config);
  }
}

final config = MigrationConfig(
    initializationScript: initialScript, migrationScripts: updates);

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

final List<String> updates = [];
