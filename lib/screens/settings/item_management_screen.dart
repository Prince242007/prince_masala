import 'package:flutter/material.dart';
import 'edit_item_screen.dart';
import '../../controllers/item_controller.dart';
import '../../models/item.dart';
import 'add_item_screen.dart';

class ItemManagementScreen extends StatefulWidget {
  const ItemManagementScreen({super.key});

  @override
  State<ItemManagementScreen> createState() => _ItemManagementScreenState();
}

class _ItemManagementScreenState extends State<ItemManagementScreen> {
  final ItemController itemController = ItemController();

  @override
  void initState() {
    super.initState();

    itemController.loadItems();
  }

  @override
  void dispose() {
    itemController.dispose();
    super.dispose();
  }

  Future<void> editItem(int index) async {
    final item = itemController.items[index];

    final Item? updatedItem = await Navigator.of(context).push<Item>(
      MaterialPageRoute(builder: (context) => EditItemScreen(item: item)),
    );

    if (updatedItem != null) {
      itemController.updateItem(index, updatedItem);
    }
  }

  Future<void> deleteItem(int index) async {
    final item = itemController.items[index];

    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('વસ્તુ કાઢી નાખવી છે?'),
          content: Text('શું તમે "${item.gujaratiName}" કાઢી નાખવા માંગો છો?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('રદ કરો'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('કાઢી નાખો'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      itemController.deleteItem(index);
    }
  }

  Future<void> addItem() async {
    final Item? newItem = await Navigator.of(context).push<Item>(
      MaterialPageRoute(builder: (context) => const AddItemScreen()),
    );

    if (newItem != null) {
      itemController.addItem(newItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('વસ્તુ વ્યવસ્થાપન')),
      body: AnimatedBuilder(
        animation: itemController,
        builder: (context, child) {
          if (itemController.items.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.inventory_2_outlined, size: 60),

                    const SizedBox(height: 12),

                    const Text(
                      'હજુ કોઈ વસ્તુ ઉમેરાઈ નથી.',
                      style: TextStyle(fontSize: 16),
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: addItem,
                        icon: const Icon(Icons.add),
                        label: const Text(
                          'વસ્તુ ઉમેરો',
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

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: itemController.items.length,
            itemBuilder: (context, index) {
              final item = itemController.items[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  leading: CircleAvatar(child: Text('${index + 1}')),
                  title: Text(
                    item.gujaratiName,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    '${item.searchName} • ₹${item.price.toStringAsFixed(2)}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        tooltip: 'સુધારો',
                        onPressed: () {
                          editItem(index);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline),
                        tooltip: 'કાઢી નાખો',
                        onPressed: () {
                          deleteItem(index);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: addItem,
        icon: const Icon(Icons.add),
        label: const Text('વસ્તુ ઉમેરો'),
      ),
    );
  }
}
