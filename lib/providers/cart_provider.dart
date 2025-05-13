import 'package:flutter/material.dart';

class CartProvider with ChangeNotifier {
  final Map<String, int> _items = {}; 

  Map<String, int> get items => _items;

  int get totalItems => _items.values.fold(0, (sum, qty) => sum + qty);

  void addItem(String title) {
    if (_items.containsKey(title)) {
      _items[title] = _items[title]! + 1;
    } else {
      _items[title] = 1;
    }
    print("Item added: $title. Total items: $_items"); // Debug print
    notifyListeners();
  }

  void removeItem(String title) {
    if (_items.containsKey(title)) {
      if (_items[title]! > 1) {
        _items[title] = _items[title]! - 1;
      } else {
        _items.remove(title);
      }
      notifyListeners();
    }
  }

  int getQuantity(String title) => _items[title] ?? 0;
}
