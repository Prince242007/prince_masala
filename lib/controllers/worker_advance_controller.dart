import 'package:flutter/material.dart';

import '../database/app_database.dart';
import '../models/worker_advance.dart';

class WorkerAdvanceController extends ChangeNotifier {
  List<WorkerAdvance> advances = [];

  double get totalAdvance {
    return advances.fold(
      0.0,
      (sum, advance) => sum + advance.amount,
    );
  }

  Future<void> loadAdvances(int workerId) async {
    final db = await AppDatabase.instance.database;

    final data = await db.query(
      'worker_advances',
      where: 'worker_id = ?',
      whereArgs: [workerId],
      orderBy: 'date ASC, id ASC',
    );

    advances = data
        .map(
          (map) => WorkerAdvance.fromMap(map),
        )
        .toList();

    notifyListeners();
  }

  Future<void> addAdvance({
    required int workerId,
    required String reason,
    required double amount,
  }) async {
    final db = await AppDatabase.instance.database;

    final now = DateTime.now();

    final date =
        '${now.year}-'
        '${now.month.toString().padLeft(2, '0')}-'
        '${now.day.toString().padLeft(2, '0')}';

    await db.insert(
      'worker_advances',
      {
        'worker_id': workerId,
        'date': date,
        'reason': reason,
        'amount': amount,
      },
    );

    await loadAdvances(workerId);
  }

  Future<void> deleteAdvance(
    int advanceId,
    int workerId,
  ) async {
    final db = await AppDatabase.instance.database;

    await db.delete(
      'worker_advances',
      where: 'id = ?',
      whereArgs: [advanceId],
    );

    await loadAdvances(workerId);
  }
}