class BillItem {
  final String gujaratiName;
  final String englishSearchName;

  int quantity;
  double price;

  BillItem({
    required this.gujaratiName,
    required this.englishSearchName,
    required this.quantity,
    required this.price,
  });

  double get amount => quantity * price;
}