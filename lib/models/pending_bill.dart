class PendingBill {
  final int? id;
  final String date;
  final String customerName;
  final double price;

  PendingBill({
    this.id,
    required this.date,
    required this.customerName,
    required this.price,
  });
}