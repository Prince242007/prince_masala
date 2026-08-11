import 'package:flutter/material.dart';

import '../../models/bill_item.dart';

class BillingInputSection extends StatefulWidget {
  final void Function(BillItem item) onAddItem;

  const BillingInputSection({super.key, required this.onAddItem});

  @override
  State<BillingInputSection> createState() => _BillingInputSectionState();
}

class _BillingInputSectionState extends State<BillingInputSection> {
  final TextEditingController customerController = TextEditingController();

  final TextEditingController searchController = TextEditingController();

  final TextEditingController quantityController = TextEditingController();

  final TextEditingController priceController = TextEditingController();

  final FocusNode searchFocus = FocusNode();
  final FocusNode quantityFocus = FocusNode();
  final FocusNode priceFocus = FocusNode();

  @override
  void dispose() {
    customerController.dispose();
    searchController.dispose();
    quantityController.dispose();
    priceController.dispose();

    searchFocus.dispose();
    quantityFocus.dispose();
    priceFocus.dispose();

    super.dispose();
  }

  void addItem() {
    final customerName = customerController.text.trim();
    final itemName = searchController.text.trim();
    final quantityText = quantityController.text.trim();
    final priceText = priceController.text.trim();

    if (customerName.isEmpty) {
      _showMessage('ગ્રાહકનું નામ દાખલ કરો.');
      return;
    }

    if (itemName.isEmpty) {
      _showMessage('વસ્તુ પસંદ કરો.');
      searchFocus.requestFocus();
      return;
    }

    final quantity = int.tryParse(quantityText);

    if (quantity == null || quantity <= 0) {
      _showMessage('યોગ્ય જથ્થો દાખલ કરો.');
      quantityFocus.requestFocus();
      return;
    }

    final price = double.tryParse(priceText);

    if (price == null || price <= 0) {
      _showMessage('યોગ્ય ભાવ દાખલ કરો.');
      priceFocus.requestFocus();
      return;
    }

    final BillItem item = BillItem(
      gujaratiName: itemName,
      englishSearchName: itemName,
      quantity: quantity,
      price: price,
    );

    widget.onAddItem(item);

    searchController.clear();
    quantityController.clear();
    priceController.clear();

    searchFocus.requestFocus();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ગ્રાહકનું નામ',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 8),

          TextField(
            controller: customerController,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              hintText: 'ગ્રાહકનું નામ દાખલ કરો',
              border: OutlineInputBorder(),
            ),
            onSubmitted: (_) {
              searchFocus.requestFocus();
            },
          ),

          const SizedBox(height: 18),

          const Text(
            'વસ્તુ શોધો',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 8),

          TextField(
            controller: searchController,
            focusNode: searchFocus,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              hintText: 'વસ્તુનું નામ શોધો',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            onSubmitted: (_) {
              quantityFocus.requestFocus();
            },
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'જથ્થો',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 8),

                    TextField(
                      controller: quantityController,
                      focusNode: quantityFocus,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        hintText: 'જથ્થો',
                        border: OutlineInputBorder(),
                      ),
                      onSubmitted: (_) {
                        priceFocus.requestFocus();
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'ભાવ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 8),

                    TextField(
                      controller: priceController,
                      focusNode: priceFocus,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      textInputAction: TextInputAction.done,
                      decoration: const InputDecoration(
                        hintText: 'ભાવ',
                        border: OutlineInputBorder(),
                      ),
                      onSubmitted: (_) {
                        addItem();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: addItem,
              icon: const Icon(Icons.add),
              label: const Text(
                'ઉમેરો',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
