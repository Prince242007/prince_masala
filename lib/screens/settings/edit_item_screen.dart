import 'package:flutter/material.dart';

import '../../models/item.dart';

class EditItemScreen extends StatefulWidget {
  final Item item;

  const EditItemScreen({
    super.key,
    required this.item,
  });

  @override
  State<EditItemScreen> createState() => _EditItemScreenState();
}

class _EditItemScreenState extends State<EditItemScreen> {
  late final TextEditingController gujaratiController;
  late final TextEditingController englishController;
  late final TextEditingController priceController;

  @override
  void initState() {
    super.initState();

    gujaratiController = TextEditingController(
      text: widget.item.gujaratiName,
    );

    englishController = TextEditingController(
      text: widget.item.searchName,
    );

    priceController = TextEditingController(
      text: widget.item.price.toString(),
    );
  }

  @override
  void dispose() {
    gujaratiController.dispose();
    englishController.dispose();
    priceController.dispose();
    super.dispose();
  }

  void saveChanges() {
    final gujaratiName =
        gujaratiController.text.trim();

    final englishName =
        englishController.text.trim();

    final priceText =
        priceController.text.trim();

    if (gujaratiName.isEmpty) {
      _showMessage('ગુજરાતી નામ દાખલ કરો.');
      return;
    }

    if (englishName.isEmpty) {
      _showMessage(
        'English search name દાખલ કરો.',
      );
      return;
    }

    final price = double.tryParse(priceText);

    if (price == null || price <= 0) {
      _showMessage('યોગ્ય ભાવ દાખલ કરો.');
      return;
    }

    final updatedItem = Item(
      gujaratiName: gujaratiName,
      searchName: englishName,
      price: price,
    );

    Navigator.of(context).pop(updatedItem);
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('વસ્તુ સુધારો'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            const Text(
              'ગુજરાતી નામ',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: gujaratiController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'English Search Name',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: englishController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'વેચાણ ભાવ',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: priceController,
              keyboardType:
                  const TextInputType.numberWithOptions(
                decimal: true,
              ),
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(
                prefixText: '₹ ',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) {
                saveChanges();
              },
            ),

            const SizedBox(height: 28),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: saveChanges,
                child: const Text(
                  'સાચવો',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}