import 'package:flutter/material.dart';
import '../models/transaction_history_model.dart';
import '../services/transaction_service.dart';

class TransactionHistoryProvider with ChangeNotifier {
  List<TransactionHistoryModel> _transactions = [];
  bool _isLoading = false;

  List<TransactionHistoryModel> get transactions => _transactions;
  bool get isLoading => _isLoading;

  Future<void> loadTransactionHistory() async {
    _isLoading = true;
    notifyListeners();

    try {
      final data = await fetchTransactionHistory();
      _transactions = data;
    } catch (e) {
      _transactions = [];
      debugPrint('Error loading transaction history: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
