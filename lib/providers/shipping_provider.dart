import 'package:flutter/material.dart';
import '../models/shipping_model.dart';
import '../services/transaction_service.dart';

class ShippingProvider with ChangeNotifier {
  List<ShippingTransactionModel> _shippings = [];
  bool _isLoading = false;

  List<ShippingTransactionModel> get shippings => _shippings;
  bool get isLoading => _isLoading;

  Future<void> loadShippingTransactions() async {
    _isLoading = true;
    notifyListeners();

    try {
      _shippings = await fetchShippingTransactions();
    } catch (e) {
      debugPrint('Error loading shipping transactions: $e');
      _shippings = [];
    }

    _isLoading = false;
    notifyListeners();
  }
}
