import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  AppDatabase._();

  static final AppDatabase instance = AppDatabase._();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();

    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();

    final path = join(databasePath, 'prince_masala.db');

    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
      CREATE TABLE pending_bills (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        customer_name TEXT NOT NULL,
        price REAL NOT NULL
      )
    ''');
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE items (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      gujarati_name TEXT NOT NULL,
      search_name TEXT NOT NULL,
      price REAL NOT NULL
    )
  ''');

    await db.execute('''
    CREATE TABLE pending_bills (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      date TEXT NOT NULL,
      customer_name TEXT NOT NULL,
      price REAL NOT NULL
    )
  ''');
  }
}
