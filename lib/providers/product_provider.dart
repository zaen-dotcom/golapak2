import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/product_service.dart' as productService;

class MakananProvider extends ChangeNotifier {
  List<ProductModel> _makananList = [];
  List<ProductModel> get makananList => _makananList;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  bool _hasFetched = false;

  Future<void> fetchMakanan({bool forceRefresh = false}) async {
    if (_hasFetched && !forceRefresh) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _makananList = await productService.fetchMakanan();
      _hasFetched = true;
    } catch (e) {
      _error = e.toString();
      _makananList = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

class MinumanProvider extends ChangeNotifier {
  List<ProductModel> _minumanList = [];
  List<ProductModel> get minumanList => _minumanList;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  bool _hasFetched = false;

  Future<void> fetchMinuman({bool forceRefresh = false}) async {
    if (_hasFetched && !forceRefresh) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _minumanList = await productService.fetchMinuman();
      _hasFetched = true;
    } catch (e) {
      _error = e.toString();
      _minumanList = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
