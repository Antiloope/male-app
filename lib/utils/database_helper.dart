import 'package:male_naturapp/services/customer/customer_service_sqlite.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  static const String _dbName = 'malenaturapp_database.db';
  static const int _dbVersion = 2;

  late final Database _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  void _initializeTables(Database db, int version) {
    CustomerServiceSqlite.createTable(db, version);
  }

  void _upgradeTables(Database db, int oldVersion, int newVersion) {
    CustomerServiceSqlite.createTable(db, newVersion);
    db.execute(
      'DROP TABLE clients',
    );
  }

  void initialize() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), _dbName),
      onCreate: _initializeTables,
      onUpgrade: _upgradeTables,
      version: _dbVersion,
    );
  }

  Database getConnection() {
    return _database;
  }
}