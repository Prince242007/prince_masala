import 'package:flutter/material.dart';

import '../database/app_database.dart';
import '../models/pending_bill.dart';

class PendingBillController extends ChangeNotifier {
  final List<PendingBill> bills = [];

  Future<void> loadBills() async {
    final db = await AppDatabase.instance.database;

    final data = await db.query(
      'pending_bills',
      orderBy: 'date ASC',
    );

    bills.clear();

    for (final row in data) {
      bills.add(
        PendingBill(
          id: row['id'] as int,
          date: row['date'] as String,
          customerName: row['customer_name'] as String,
          price: (row['price'] as num).toDouble(),
        ),
      );
    }

    bills.sort((a, b) => _compareDates(a.date, b.date));

    notifyListeners();
  }

  Future<void> addBill(PendingBill bill) async {
    final db = await AppDatabase.instance.database;

    final id = await db.insert(
      'pending_bills',
      {
        'date': bill.date,
        'customer_name': bill.customerName,
        'price': bill.price,
      },
    );

    bills.add(
      PendingBill(
        id: id,
        date: bill.date,
        customerName: bill.customerName,
        price: bill.price,
      ),
    );

    bills.sort((a, b) => _compareDates(a.date, b.date));

    notifyListeners();
  }

  Future<void> updateBill(
    int index,
    PendingBill updatedBill,
  ) async {
    final oldBill = bills[index];

    if (oldBill.id == null) {
      return;
    }

    final db = await AppDatabase.instance.database;

    await db.update(
      'pending_bills',
      {
        'date': updatedBill.date,
        'customer_name': updatedBill.customerName,
        'price': updatedBill.price,
      },
      where: 'id = ?',
      whereArgs: [oldBill.id],
    );

    bills[index] = PendingBill(
      id: oldBill.id,
      date: updatedBill.date,
      customerName: updatedBill.customerName,
      price: updatedBill.price,
    );

    bills.sort((a, b) => _compareDates(a.date, b.date));

    notifyListeners();
  }

  Future<void> deleteBill(int index) async {
    final bill = bills[index];

    if (bill.id == null) {
      return;
    }

    final db = await AppDatabase.instance.database;

    await db.delete(
      'pending_bills',
      where: 'id = ?',
      whereArgs: [bill.id],
    );

    bills.removeAt(index);

    notifyListeners();
  }

  int _compareDates(String first, String second) {
    final firstDate = _parseDate(first);
    final secondDate = _parseDate(second);

    return firstDate.compareTo(secondDate);
  }

  DateTime _parseDate(String value) {
    final parts = value.split('/');

    if (parts.length != 3) {
      return DateTime(2100);
    }

    final day = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);

    if (day == null || month == null || year == null) {
      return DateTime(2100);
    }

    return DateTime(year, month, day);
  }
}