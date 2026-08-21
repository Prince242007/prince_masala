import 'package:flutter/material.dart';

import '../../controllers/item_controller.dart';
import '../../models/item.dart';

class ItemsScreen extends StatefulWidget {
  const ItemsScreen({super.key});

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  final ItemController itemController = ItemController();

  final TextEditingController searchController =
      TextEditingController();

  List<Item> searchResults = [];

  @override
  void initState() {
    super.initState();

    itemController.loadItems();
  }

  @override
  void dispose() {
    searchController.dispose();
    itemController.dispose();
    super.dispose();
  }

  void searchItems(String value) {
    final query = value.trim().toLowerCase();

    setState(() {
      if (query.isEmpty) {
        searchResults = [];
      } else {
        searchResults = itemController.items.where((item) {
          final englishName =
              item.searchName.toLowerCase();

          final gujaratiName =
              item.gujaratiName.toLowerCase();

          return englishName.startsWith(query) ||
              gujaratiName.startsWith(query);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('વસ્તુઓ'),
      ),

      body: AnimatedBuilder(
        animation: itemController,
        builder: (context, child) {
          if (itemController.items.isEmpty) {
            return const Center(
              child: Text(
                'હજુ કોઈ વસ્તુ ઉમેરાઈ નથી.',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          final itemsToShow = searchController.text
                  .trim()
                  .isEmpty
              ? itemController.items
              : searchResults;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  16,
                  16,
                  16,
                  8,
                ),
                child: TextField(
                  controller: searchController,
                  onChanged: searchItems,
                  decoration: const InputDecoration(
                    hintText: 'વસ્તુ શોધો',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),

              Expanded(
                child: itemsToShow.isEmpty
                    ? const Center(
                        child: Text(
                          'વસ્તુ મળી નથી.',
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: itemsToShow.length,
                        itemBuilder: (context, index) {
                          final item =
                              itemsToShow[index];

                          return Card(
                            margin:
                                const EdgeInsets.only(
                              bottom: 10,
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                child: Text(
                                  '${index + 1}',
                                ),
                              ),
                              title: Text(
                                item.gujaratiName,
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight:
                                      FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(
                                item.searchName,
                              ),
                              trailing: Text(
                                '₹${item.price.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight:
                                      FontWeight.w600,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}