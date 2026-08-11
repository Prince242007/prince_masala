import 'bill_item.dart';

class Bill {
  int? id;

  String customerName;

  String billNumber;

  DateTime dateTime;

  List<BillItem> items;

  Bill({
    this.id,
    required this.customerName,
    required this.billNumber,
    required this.dateTime,
    required this.items,
  });

  double get total =>
      items.fold(
        0,
        (sum, item) => sum + item.amount,
      );
}