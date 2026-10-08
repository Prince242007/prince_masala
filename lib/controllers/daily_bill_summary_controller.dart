import 'package:flutter/material.dart';

import '../database/app_database.dart';

class DailyBillSummaryController extends ChangeNotifier {
  double todayTotal = 0.0;
  int todayBillCount = 0;

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
      todayBillCount = 0;
    } else {
      todayTotal = (data.first['total'] as num).toDouble();

      todayBillCount = (data.first['bill_count'] as num?)?.toInt() ?? 0;
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
      todayBillCount = 1;

      await db.insert('daily_bill_summary', {
        'date': today,
        'total': todayTotal,
        'bill_count': todayBillCount,
      });
    } else {
      todayTotal = (data.first['total'] as num).toDouble() + billAmount;

      todayBillCount = (data.first['bill_count'] as num?)?.toInt() ?? 0;

      todayBillCount++;

      await db.update(
        'daily_bill_summary',
        {'total': todayTotal, 'bill_count': todayBillCount},
        where: 'date = ?',
        whereArgs: [today],
      );
    }

    notifyListeners();
  }

  Future<Map<String, Map<String, dynamic>>> getCurrentMonthSummary() async {
    final db = await AppDatabase.instance.database;

    final now = DateTime.now();

    final monthStart = '${now.year}-${now.month.toString().padLeft(2, '0')}-01';

    final nextMonth = DateTime(now.year, now.month + 1, 1);

    final nextMonthStart =
        '${nextMonth.year}-'
        '${nextMonth.month.toString().padLeft(2, '0')}-01';

    final data = await db.query(
      'daily_bill_summary',
      where: 'date >= ? AND date < ?',
      whereArgs: [monthStart, nextMonthStart],
      orderBy: 'date ASC',
    );

    final Map<String, Map<String, dynamic>> summary = {};

    for (final row in data) {
      final date = row['date'] as String;

      summary[date] = {
        'total': (row['total'] as num).toDouble(),
        'bill_count': (row['bill_count'] as num?)?.toInt() ?? 0,
      };
    }

    return summary;
  }
}
