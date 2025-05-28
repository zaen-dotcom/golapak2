import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../services/transaction_service.dart';

class OrderProvider with ChangeNotifier {
  List<Order> _orders = [];
  bool _isLoading = false;

  List<Order> get orders => _orders;
  bool get isLoading => _isLoading;

  Future<void> loadOrders() async {
    _isLoading = true;
    notifyListeners();

    try {
    final data = await fetchTransactionProgress();

    if (data != null) {
      _orders = data;
    } else {
      _orders = [];
    }
  } catch (e, stack) {
    print('Gagal load orders: $e');
    print(stack); // Ini buat log lengkap
    _orders = [];
  }

    _isLoading = false;
    notifyListeners();
  }
}
