import 'package:flutter/material.dart';
import '../../models/item.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final TextEditingController gujaratiController = TextEditingController();

  final TextEditingController englishController = TextEditingController();

  final TextEditingController priceController = TextEditingController();

  @override
  void dispose() {
    gujaratiController.dispose();
    englishController.dispose();
    priceController.dispose();

    super.dispose();
  }

  void saveItem() {
    final gujaratiName = gujaratiController.text.trim();

    final englishName = englishController.text.trim();

    final priceText = priceController.text.trim();

    if (gujaratiName.isEmpty) {
      _showMessage('ગુજરાતી નામ દાખલ કરો.');
      return;
    }

    if (englishName.isEmpty) {
      _showMessage('English search name દાખલ કરો.');
      return;
    }

    final price = double.tryParse(priceText);

    if (price == null || price <= 0) {
      _showMessage('યોગ્ય ભાવ દાખલ કરો.');
      return;
    }

    final item = Item(
      gujaratiName: gujaratiName,
      searchName: englishName,
      price: price,
    );

    Navigator.of(context).pop(item);
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('વસ્તુ ઉમેરો')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'ગુજરાતી નામ',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: gujaratiController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                hintText: 'વસ્તુનું ગુજરાતી નામ',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'English Search Name',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: englishController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                hintText: 'જેમ કે badam',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'વેચાણ ભાવ',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: priceController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(
                hintText: 'ભાવ દાખલ કરો',
                prefixText: '₹ ',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) {
                saveItem();
              },
            ),

            const SizedBox(height: 28),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: saveItem,
                child: const Text(
                  'સાચવો',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
