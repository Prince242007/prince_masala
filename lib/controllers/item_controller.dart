import 'package:flutter/material.dart';

import '../database/app_database.dart';
import '../data/sample_items.dart';
import '../models/item.dart';

class ItemController extends ChangeNotifier {
  final List<Item> items = [];

  Future<void> loadItems() async {
    final db = await AppDatabase.instance.database;

    // Check whether items already exist in the database
    var data = await db.query(
      'items',
      orderBy: 'id ASC',
    );

    // If the database is empty, add all sample items
    if (data.isEmpty) {
      for (final item in sampleItems) {
        await db.insert(
          'items',
          {
            'gujarati_name': item.gujaratiName,
            'search_name': item.searchName,
            'price': item.price,
          },
        );
      }

      // Load the items again after inserting them
      data = await db.query(
        'items',
        orderBy: 'id ASC',
      );
    }

    items.clear();

    for (final row in data) {
      items.add(
        Item(
          id: row['id'] as int,
          gujaratiName: row['gujarati_name'] as String,
          searchName: row['search_name'] as String,
          price: (row['price'] as num).toDouble(),
        ),
      );
    }

    notifyListeners();
  }

  Future<void> addItem(Item item) async {
    final db = await AppDatabase.instance.database;

    final id = await db.insert(
      'items',
      {
        'gujarati_name': item.gujaratiName,
        'search_name': item.searchName,
        'price': item.price,
      },
    );

    items.add(
      Item(
        id: id,
        gujaratiName: item.gujaratiName,
        searchName: item.searchName,
        price: item.price,
      ),
    );

    notifyListeners();
  }

  Future<void> updateItem(
    int index,
    Item updatedItem,
  ) async {
    final oldItem = items[index];

    if (oldItem.id == null) {
      return;
    }

    final db = await AppDatabase.instance.database;

    await db.update(
      'items',
      {
        'gujarati_name': updatedItem.gujaratiName,
        'search_name': updatedItem.searchName,
        'price': updatedItem.price,
      },
      where: 'id = ?',
      whereArgs: [oldItem.id],
    );

    items[index] = Item(
      id: oldItem.id,
      gujaratiName: updatedItem.gujaratiName,
      searchName: updatedItem.searchName,
      price: updatedItem.price,
    );

    notifyListeners();
  }

  Future<void> deleteItem(int index) async {
    final item = items[index];

    if (item.id == null) {
      return;
    }

    final db = await AppDatabase.instance.database;

    await db.delete(
      'items',
      where: 'id = ?',
      whereArgs: [item.id],
    );

    items.removeAt(index);

    notifyListeners();
  }
}