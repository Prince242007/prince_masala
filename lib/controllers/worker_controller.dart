import 'package:flutter/material.dart';

import '../database/app_database.dart';
import '../models/worker.dart';

class WorkerController extends ChangeNotifier {
  final List<Worker> workers = [];

  Future<void> loadWorkers() async {
    final db = await AppDatabase.instance.database;

    final data = await db.query(
      'workers',
      orderBy: 'id ASC',
    );

    workers.clear();

    for (final row in data) {
      workers.add(
        Worker(
          id: row['id'] as int,
          name: row['name'] as String,
          hourlyRate: (row['hourly_rate'] as num).toDouble(),
        ),
      );
    }

    notifyListeners();
  }

  Future<void> addWorker(Worker worker) async {
    final db = await AppDatabase.instance.database;

    final id = await db.insert(
      'workers',
      {
        'name': worker.name,
        'hourly_rate': worker.hourlyRate,
      },
    );

    workers.add(
      Worker(
        id: id,
        name: worker.name,
        hourlyRate: worker.hourlyRate,
      ),
    );

    notifyListeners();
  }

  Future<void> updateWorker(
    int index,
    Worker updatedWorker,
  ) async {
    final oldWorker = workers[index];

    if (oldWorker.id == null) {
      return;
    }

    final db = await AppDatabase.instance.database;

    await db.update(
      'workers',
      {
        'name': updatedWorker.name,
        'hourly_rate': updatedWorker.hourlyRate,
      },
      where: 'id = ?',
      whereArgs: [oldWorker.id],
    );

    workers[index] = Worker(
      id: oldWorker.id,
      name: updatedWorker.name,
      hourlyRate: updatedWorker.hourlyRate,
    );

    notifyListeners();
  }

  Future<void> deleteWorker(int index) async {
    final worker = workers[index];

    if (worker.id == null) {
      return;
    }

    final db = await AppDatabase.instance.database;

    await db.delete(
      'workers',
      where: 'id = ?',
      whereArgs: [worker.id],
    );

    workers.removeAt(index);

    notifyListeners();
  }
}