import 'api_service.dart';

class AuthService {
  /// Login user using Laravel Sanctum API
  static Future<void> login(String email, String password) async {
    final response = await ApiService.dio.post(
      '/login',
      data: {
        'email': email.trim(),
        'password': password.trim(),
      },
    );

    // Laravel returns: { token: "...", user: {...} }
    final token = response.data['token'];
    await ApiService.setToken(token);
  }

  /// Register user using Laravel Sanctum API
  static Future<void> register(
    String name,
    String email,
    String password,
  ) async {
    final response = await ApiService.dio.post(
      '/register',
      data: {
        'name': name.trim(),
        'email': email.trim(),
        'password': password.trim(),
        'password_confirmation': password.trim(), // IMPORTANT
      },
    );

    // Laravel returns: { token: "...", user: {...} }
    final token = response.data['token'];
    await ApiService.setToken(token);
  }

  /// Logout authenticated user
  static Future<void> logout() async {
    await ApiService.dio.post('/logout');
    await ApiService.clearToken();
  }
}