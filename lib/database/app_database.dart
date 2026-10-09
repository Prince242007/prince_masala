import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../data/sample_items.dart';

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
      version: 12,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Items table
    await db.execute('''
      CREATE TABLE items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        gujarati_name TEXT NOT NULL,
        search_name TEXT NOT NULL,
        price REAL NOT NULL
      )
    ''');

    // Workers table
    await db.execute('''
      CREATE TABLE workers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        hourly_rate REAL NOT NULL
      )
    ''');

    // Worker hours table
    await db.execute('''
      CREATE TABLE worker_hours (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        worker_id INTEGER NOT NULL,
        date TEXT NOT NULL,
        hours REAL NOT NULL,
        UNIQUE(worker_id, date)
      )
    ''');

    // Pending bills table
    await db.execute('''
      CREATE TABLE pending_bills (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        customer_name TEXT NOT NULL,
        price REAL NOT NULL
      )
    ''');

    // Daily bill summary table
    await db.execute('''
      CREATE TABLE daily_bill_summary (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL UNIQUE,
        total REAL NOT NULL,
        bill_count INTEGER NOT NULL DEFAULT 0
      )
    ''');

    // Worker advances table
    await db.execute('''
      CREATE TABLE worker_advances (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        worker_id INTEGER NOT NULL,
        date TEXT NOT NULL,
        reason TEXT NOT NULL,
        amount REAL NOT NULL
      )
    ''');

    // Add all initial items
    await _seedItems(db);
  }

  Future<void> _seedItems(Database db) async {
    for (final item in sampleItems) {
      await db.insert(
        'items',
        {
          'gujarati_name': item.gujaratiName,
          'search_name': item.searchName,
          'price': item.price,
        },
      );
    }
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

    if (oldVersion < 8) {
      final columns = await db.rawQuery(
        'PRAGMA table_info(daily_bill_summary)',
      );

      final hasBillCount = columns.any(
        (column) => column['name'] == 'bill_count',
      );

      if (!hasBillCount) {
        await db.execute('''
          ALTER TABLE daily_bill_summary
          ADD COLUMN bill_count INTEGER NOT NULL DEFAULT 0
        ''');
      }
    }

    if (oldVersion < 9) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS daily_bill_summary (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          date TEXT NOT NULL UNIQUE,
          total REAL NOT NULL,
          bill_count INTEGER NOT NULL DEFAULT 0
        )
      ''');

      final columns = await db.rawQuery(
        'PRAGMA table_info(daily_bill_summary)',
      );

      final hasBillCount = columns.any(
        (column) => column['name'] == 'bill_count',
      );

      if (!hasBillCount) {
        await db.execute('''
          ALTER TABLE daily_bill_summary
          ADD COLUMN bill_count INTEGER NOT NULL DEFAULT 0
        ''');
      }
    }

    // Version 10:
    // Add worker advances table.
    if (oldVersion < 10) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS worker_advances (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          worker_id INTEGER NOT NULL,
          date TEXT NOT NULL,
          reason TEXT NOT NULL,
          amount REAL NOT NULL
        )
      ''');
    }

    // Version 11:
    // Initial item seeding support.
    if (oldVersion < 11) {
      // If the items table is empty, add the initial items.
      final result = await db.rawQuery(
        'SELECT COUNT(*) as count FROM items',
      );

      final count = result.first['count'] as int;

      if (count == 0) {
        await _seedItems(db);
      }
    }

    // Version 12:
    // Replace the old sample items with the complete item list.
    if (oldVersion < 12) {
      final result = await db.rawQuery(
        'SELECT COUNT(*) as count FROM items',
      );

      final count = result.first['count'] as int;

      // The existing app contains the old sample items.
      // Replace them with the complete item list.
      if (count > 0 && count <= 6) {
        await db.delete('items');

        await _seedItems(db);
      }
    }
  }
}