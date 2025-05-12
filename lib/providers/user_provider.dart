import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  int? _userId;

  int? get userId => _userId;

  void setUserId(int userId) {
    _userId = userId;
    notifyListeners();
  }

  void reset() {
    _userId = null;
    notifyListeners();
  }
}
