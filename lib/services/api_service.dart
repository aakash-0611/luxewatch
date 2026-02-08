import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'http://127.0.0.1:8000/api',
      headers: {
        'Accept': 'application/json',
      },
    ),
  );

  static const _storage = FlutterSecureStorage();
  static const _tokenKey = 'token';

  /// Save token securely and attach to Dio
  static Future<void> setToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
    dio.options.headers['Authorization'] = 'Bearer $token';
  }

  /// Load token on app start (auto-login)
  static Future<void> loadToken() async {
    final token = await _storage.read(key: _tokenKey);
    if (token != null && token.isNotEmpty) {
      dio.options.headers['Authorization'] = 'Bearer $token';
    }
  }

  /// Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: _tokenKey);
    return token != null && token.isNotEmpty;
  }

  /// Clear token on logout
  static Future<void> clearToken() async {
    await _storage.delete(key: _tokenKey);
    dio.options.headers.remove('Authorization');
  }
}