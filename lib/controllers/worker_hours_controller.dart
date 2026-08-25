import 'package:flutter/material.dart';

import '../database/app_database.dart';
import '../models/worker_hours.dart';

class WorkerHoursController extends ChangeNotifier {
  final List<WorkerHours> workerHours = [];

  WorkerHours? todayHours;

  String get today {
    final now = DateTime.now();

    return '${now.year}-'
        '${now.month.toString().padLeft(2, '0')}-'
        '${now.day.toString().padLeft(2, '0')}';
  }

  Future<void> loadWorkerHours(int workerId) async {
    final db = await AppDatabase.instance.database;

    final data = await db.query(
      'worker_hours',
      where: 'worker_id = ?',
      whereArgs: [workerId],
      orderBy: 'date ASC',
    );

    workerHours.clear();
    todayHours = null;

    for (final row in data) {
      final entry = WorkerHours(
        id: row['id'] as int,
        workerId: row['worker_id'] as int,
        date: row['date'] as String,
        hours: (row['hours'] as num).toDouble(),
      );

      workerHours.add(entry);

      if (entry.date == today) {
        todayHours = entry;
      }
    }

    notifyListeners();
  }

  Future<void> saveTodayHours({
    required int workerId,
    required double hours,
  }) async {
    if (todayHours != null) {
      return;
    }

    final db = await AppDatabase.instance.database;

    await db.insert('worker_hours', {
      'worker_id': workerId,
      'date': today,
      'hours': hours,
    });

    await loadWorkerHours(workerId);
  }

  Future<void> updateTodayHours({
    required int workerId,
    required double hours,
  }) async {
    if (todayHours == null || todayHours!.id == null) {
      return;
    }

    final db = await AppDatabase.instance.database;

    await db.update(
      'worker_hours',
      {'hours': hours},
      where: 'id = ?',
      whereArgs: [todayHours!.id],
    );

    await loadWorkerHours(workerId);
  }

  double get currentMonthTotalHours {
    final now = DateTime.now();

    final currentMonthPrefix =
        '${now.year}-${now.month.toString().padLeft(2, '0')}';

    return workerHours
        .where((entry) => entry.date.startsWith(currentMonthPrefix))
        .fold(0.0, (sum, entry) => sum + entry.hours);
  }

  bool get hasTodayEntry {
    return todayHours != null;
  }

  Future<List<WorkerHours>> getCurrentMonthHours(int workerId) async {
    final db = await AppDatabase.instance.database;

    final now = DateTime.now();

    final monthPrefix = '${now.year}-${now.month.toString().padLeft(2, '0')}';

    final data = await db.query(
      'worker_hours',
      where: 'worker_id = ? AND date LIKE ?',
      whereArgs: [workerId, '$monthPrefix%'],
      orderBy: 'date ASC',
    );

    return data.map((row) {
      return WorkerHours(
        id: row['id'] as int,
        workerId: row['worker_id'] as int,
        date: row['date'] as String,
        hours: (row['hours'] as num).toDouble(),
      );
    }).toList();
  }

  Future<double> getCurrentMonthTotalForWorker(int workerId) async {
    final db = await AppDatabase.instance.database;

    final now = DateTime.now();

    final monthPrefix = '${now.year}-${now.month.toString().padLeft(2, '0')}';

    final result = await db.rawQuery(
      '''
    SELECT COALESCE(SUM(hours), 0) AS total
    FROM worker_hours
    WHERE worker_id = ?
    AND date LIKE ?
    ''',
      [workerId, '$monthPrefix%'],
    );

    return (result.first['total'] as num).toDouble();
  }
}
