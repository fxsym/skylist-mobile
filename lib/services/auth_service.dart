import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static Future<Map<String, dynamic>> login(
    String username,
    String password,
    String device,
  ) async {
    final url = Uri.parse('http://todo-list-app.test/api/auth/login');
    final body = jsonEncode({
      "username": username,
      "password": password,
      "device_name": device,
    });

    // Menampilkan body yang dikirim ke API
    print("Request body: $body");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      print("Response status: ${response.statusCode}"); // Debug response status
      print("Response body: ${response.body}"); // Debug response body

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        final token = responseData['token']; // pastikan key sesuai response API
        await prefs.setString('token', token);

        return responseData;
      } else {
        throw responseData;
      }
    } catch (error) {
      print("Error during login: $error"); // Debug error
      throw {"message": "Login gagal", "details": error.toString()};
    }
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw {"message": "Token tidak ditemukan, mungkin belum login"};
    }

    final url = Uri.parse('https://skylist-api.vercel.app/api/api/auth/logout');

    try {
      final response = await http.get(
        url,
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        // Hapus token dari SharedPreferences
        await prefs.remove('token');
      } else {
        final responseData = jsonDecode(response.body);
        throw responseData;
      }
    } catch (error) {
      throw {"message": "Logout gagal", "details": error.toString()};
    }
  }
}
