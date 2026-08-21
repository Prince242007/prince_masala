import 'package:flutter/material.dart';

import '../../models/bill_item.dart';

class EditBillItemDialog extends StatefulWidget {
  final BillItem item;

  const EditBillItemDialog({
    super.key,
    required this.item,
  });

  @override
  State<EditBillItemDialog> createState() =>
      _EditBillItemDialogState();
}

class _EditBillItemDialogState
    extends State<EditBillItemDialog> {
  late final TextEditingController quantityController;
  late final TextEditingController priceController;

  @override
  void initState() {
    super.initState();

    quantityController = TextEditingController(
      text: widget.item.quantity.toString(),
    );

    priceController = TextEditingController(
      text: widget.item.price.toString(),
    );
  }

  @override
  void dispose() {
    quantityController.dispose();
    priceController.dispose();
    super.dispose();
  }

  void saveChanges() {
    final quantity =
        int.tryParse(quantityController.text.trim());

    final price =
        double.tryParse(priceController.text.trim());

    if (quantity == null || quantity <= 0) {
      _showMessage('યોગ્ય જથ્થો દાખલ કરો.');
      return;
    }

    if (price == null || price <= 0) {
      _showMessage('યોગ્ય ભાવ દાખલ કરો.');
      return;
    }

    Navigator.of(context).pop(
      BillItem(
        gujaratiName: widget.item.gujaratiName,
        englishSearchName: widget.item.englishSearchName,
        quantity: quantity,
        price: price,
      ),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('વસ્તુ સુધારો'),

      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
              widget.item.gujaratiName,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: quantityController,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'જથ્થો',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: priceController,
              keyboardType:
                  const TextInputType.numberWithOptions(
                decimal: true,
              ),
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(
                labelText: 'ભાવ',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) {
                saveChanges();
              },
            ),
          ],
        ),
      ),

      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('રદ કરો'),
        ),

        ElevatedButton(
          onPressed: saveChanges,
          child: const Text('સાચવો'),
        ),
      ],
    );
  }
}