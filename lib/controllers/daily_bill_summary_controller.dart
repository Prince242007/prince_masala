import 'package:flutter/material.dart';

import '../database/app_database.dart';

class DailyBillSummaryController extends ChangeNotifier {
  double todayTotal = 0.0;

  String get today {
    final now = DateTime.now();

    return '${now.year}-'
        '${now.month.toString().padLeft(2, '0')}-'
        '${now.day.toString().padLeft(2, '0')}';
  }

  Future<void> loadTodayTotal() async {
    final db = await AppDatabase.instance.database;

    final data = await db.query(
      'daily_bill_summary',
      where: 'date = ?',
      whereArgs: [today],
    );

    if (data.isEmpty) {
      todayTotal = 0.0;
    } else {
      todayTotal = (data.first['total'] as num).toDouble();
    }

    notifyListeners();
  }

  Future<void> addPrintedBill(double billAmount) async {
    final db = await AppDatabase.instance.database;

    final data = await db.query(
      'daily_bill_summary',
      where: 'date = ?',
      whereArgs: [today],
    );

    if (data.isEmpty) {
      todayTotal = billAmount;

      await db.insert(
        'daily_bill_summary',
        {
          'date': today,
          'total': todayTotal,
        },
      );
    } else {
      todayTotal =
          (data.first['total'] as num).toDouble() +
              billAmount;

      await db.update(
        'daily_bill_summary',
        {
          'total': todayTotal,
        },
        where: 'date = ?',
        whereArgs: [today],
      );
    }

    notifyListeners();
  }
}