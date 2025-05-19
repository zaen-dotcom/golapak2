import 'package:flutter/material.dart';
import '../services/user_service.dart';

class AlamatProvider with ChangeNotifier {
  List<Map<String, dynamic>> _alamatList = [];
  bool _isLoading = false;

  List<Map<String, dynamic>> get alamatList => _alamatList;
  bool get isLoading => _isLoading;

  Future<void> fetchAlamat(int userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final addresses = await getAddress(userId);

      List<Map<String, dynamic>> mainAddress = [];
      List<Map<String, dynamic>> otherAddresses = [];

      for (var address in addresses) {
        if (address['main_address'] == 1) {
          mainAddress.add(address);
        } else {
          otherAddresses.add(address);
        }
      }

      mainAddress.addAll(otherAddresses);

      _alamatList = mainAddress;
    } catch (e) {
      print("Gagal memuat alamat: $e");
      _alamatList = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearAlamat() {
    _alamatList = [];
    notifyListeners();
  }
}
