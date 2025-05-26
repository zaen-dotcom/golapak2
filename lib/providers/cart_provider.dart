import 'package:flutter/material.dart';
import '../models/cartitem.dart';

class CartProvider with ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => {..._items};

  int get totalItems =>
      _items.values.fold(0, (sum, item) => sum + item.quantity);

  void addItem({
    required String id,
    required String title,
    required String imageUrl,
    required double price,
  }) {
    final itemKey = '$id-$title';
    if (_items.containsKey(itemKey)) {
      _items[itemKey] = CartItem(
        id: id,
        title: title,
        imageUrl: imageUrl,
        price: price,
        quantity: _items[itemKey]!.quantity + 1,
      );
    } else {
      _items[itemKey] = CartItem(
        id: id,
        title: title,
        imageUrl: imageUrl,
        price: price,
        quantity: 1,
      );
    }
    notifyListeners();
  }

  void removeItem(String id, String title) {
    final itemKey = '$id-$title';
    if (!_items.containsKey(itemKey)) return;

    if (_items[itemKey]!.quantity > 1) {
      _items[itemKey] = CartItem(
        id: _items[itemKey]!.id,
        title: _items[itemKey]!.title,
        imageUrl: _items[itemKey]!.imageUrl,
        price: _items[itemKey]!.price,
        quantity: _items[itemKey]!.quantity - 1,
      );
    } else {
      _items.remove(itemKey);
    }
    notifyListeners();
  }

  int getQuantity(String id, String title) {
    final itemKey = '$id-$title';
    return _items[itemKey]?.quantity ?? 0;
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
