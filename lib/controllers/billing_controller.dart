import 'package:flutter/material.dart';

import '../models/bill_item.dart';

class BillingController extends ChangeNotifier {
  final List<BillItem> items = [];

  void addItem(BillItem item) {
    items.add(item);
    notifyListeners();
  }

  void removeItem(int index) {
    items.removeAt(index);
    notifyListeners();
  }

  void updateItem(int index, BillItem updatedItem) {
    items[index] = updatedItem;
    notifyListeners();
  }

  void clearBill() {
    items.clear();
    notifyListeners();
  }

  double get total => items.fold(0, (sum, item) => sum + item.amount);
}
