import 'package:flutter/material.dart';
import '../services/user_service.dart';

class AlamatProvider with ChangeNotifier {
  List<Map<String, dynamic>> _alamatList = [];
  Map<String, dynamic>? _selectedAlamat;
  bool _isLoading = false;

  List<Map<String, dynamic>> get alamatList => _alamatList;
  Map<String, dynamic>? get selectedAlamat => _selectedAlamat;
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

      if (_selectedAlamat == null && mainAddress.isNotEmpty) {
        _selectedAlamat = mainAddress.first;
      }
    } catch (e) {
      print("Gagal memuat alamat: $e");
      _alamatList = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setSelectedAlamat(Map<String, dynamic> alamat) {
    _selectedAlamat = alamat;
    notifyListeners();
  }

  void clearAlamat() {
    _alamatList = [];
    _selectedAlamat = null;
    notifyListeners();
  }
}
