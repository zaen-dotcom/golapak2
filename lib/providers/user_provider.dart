import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';

class UserProvider with ChangeNotifier {
  int? _userId;
  UserModel? _user;
  bool _isLoading = false;

  int? get userId => _userId;
  UserModel? get user => _user;
  bool get isLoading => _isLoading;

  void setUserId(int userId) {
    _userId = userId;
    notifyListeners();
  }

  void setUser(UserModel user) {
    _user = user;
    _userId = user.id;
    notifyListeners();
  }

  Future<void> loadUser() async {
    _isLoading = true;
    notifyListeners();

    try {
      final fetchedUser = await getUser();
      if (fetchedUser != null) {
        _user = fetchedUser;
        _userId = fetchedUser.id;
      }
    } catch (e) {
      _user = null;
      _userId = null;
    }

    _isLoading = false;
    notifyListeners();
  }

  void reset() {
    _user = null;
    _userId = null;
    notifyListeners();
  }
}
