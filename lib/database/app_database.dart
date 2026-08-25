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

    final path = join(
      databasePath,
      'prince_masala.db',
    );

    return await openDatabase(
      path,
      version: 7,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(
    Database db,
    int version,
  ) async {
    await db.execute('''
      CREATE TABLE items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        gujarati_name TEXT NOT NULL,
        search_name TEXT NOT NULL,
        price REAL NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE workers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        hourly_rate REAL NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE worker_hours (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        worker_id INTEGER NOT NULL,
        date TEXT NOT NULL,
        hours REAL NOT NULL,
        UNIQUE(worker_id, date)
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

    await db.execute('''
      CREATE TABLE daily_bill_summary (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL UNIQUE,
        total REAL NOT NULL
      )
    ''');
  }

  Future<void> _onUpgrade(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    if (oldVersion < 4) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS workers (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          hourly_rate REAL NOT NULL
        )
      ''');

      await db.execute('''
        CREATE TABLE IF NOT EXISTS worker_hours (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          worker_id INTEGER NOT NULL,
          date TEXT NOT NULL,
          hours REAL NOT NULL,
          UNIQUE(worker_id, date)
        )
      ''');
    }

    if (oldVersion < 5) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS pending_bills (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          date TEXT NOT NULL,
          customer_name TEXT NOT NULL,
          price REAL NOT NULL
        )
      ''');
    }

    if (oldVersion < 6) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS daily_bill_summary (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          date TEXT NOT NULL UNIQUE,
          total REAL NOT NULL
        )
      ''');
    }

    // Safety check:
    // Even if the database version was already 6,
    // make sure this table actually exists.
    if (oldVersion < 7) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS daily_bill_summary (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          date TEXT NOT NULL UNIQUE,
          total REAL NOT NULL
        )
      ''');
    }
  }
}