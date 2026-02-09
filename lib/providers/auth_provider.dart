import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  bool _loggedIn = false;
  bool _loading = true;

  String? name;
  String? email;

  bool get isLoggedIn => _loggedIn;
  bool get isLoading => _loading;

  AuthProvider() {
    _init();
  }

  /// ===============================
  /// INITIAL AUTH CHECK
  /// ===============================
  Future<void> _init() async {
    _loggedIn = await ApiService.isLoggedIn();

    if (_loggedIn) {
      await loadProfile();
    }

    _loading = false;
    notifyListeners();
  }

  /// ===============================
  /// LOAD USER PROFILE (API)
  /// ===============================
  Future<void> loadProfile() async {
    try {
      final res = await ApiService.dio.get('/profile');

      name = res.data['name'];
      email = res.data['email'];
    } catch (e) {
      // Handle 401 / 404 gracefully
      name = null;
      email = null;
    }

    notifyListeners();
  }


  /// LOGOUT
  Future<void> logout() async {
    await ApiService.clearToken();

    _loggedIn = false;
    name = null;
    email = null;

    notifyListeners();
  }
}
