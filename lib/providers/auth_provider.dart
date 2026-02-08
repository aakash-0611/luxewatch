import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  bool _loggedIn = false;

  bool get isLoggedIn => _loggedIn;

  AuthProvider() {
    _init();
  }

  Future<void> _init() async {
    _loggedIn = await ApiService.isLoggedIn();
    notifyListeners();
  }

  Future<void> logout() async {
    await ApiService.clearToken();
    _loggedIn = false;
    notifyListeners();
  }
}
