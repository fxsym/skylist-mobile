import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  static const String API_URL = "https://skylist-api.vercel.app/api/api";

  // Register User
  static Future<Map<String, dynamic>> registerUser(
    String name,
    String username,
    String email,
    String password,
  ) async {
    final data = {
      "name": name,
      "username": username,
      "email": email,
      "password": password,
    };

    try {
      final response = await http.post(
        Uri.parse('$API_URL/user'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );
      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to register user');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }

  // Update User
  static Future<Map<String, dynamic>> updateUser(
    int idUser,
    String name,
    String username,
    String email,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final data = {"name": name, "username": username, "email": email};

    try {
      final response = await http.patch(
        Uri.parse('$API_URL/user/$idUser'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to update user');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }

  // Change Password
  static Future<Map<String, dynamic>> changePassword(
    int idUser,
    String oldPassword,
    String newPassword,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final data = {"old_password": oldPassword, "password": newPassword};

    print(token);
    print(data);

    try {
      final response = await http.patch(
        Uri.parse('$API_URL/user/changepass/$idUser'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to change password');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }
}
