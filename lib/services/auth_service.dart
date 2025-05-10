import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skylist_mobile/models/todo_model.dart';
import 'package:skylist_mobile/models/user_model.dart';
import 'package:skylist_mobile/providers/todo_provider.dart';
import 'package:skylist_mobile/providers/user_provider.dart';

class AuthService {
  static Future<Map<String, dynamic>> login(
    BuildContext context, // tambahkan context
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

    print("Request body: $body");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      print("Response body: ${response.body}");

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        final token = responseData['token'];
        await prefs.setString('token', token);

        // Simpan user ke provider
        final userData = responseData['user'];
        final user = UserModel.fromJson(userData);
        Provider.of<UserProvider>(context, listen: false).setUser(user);

        // Simpan todo_post ke provider (jika ada)
        final todoJson = userData['todo_post'] ?? [];
        final todos =
            (todoJson as List).map((t) => TodoModel.fromJson(t)).toList();
        Provider.of<TodoProvider>(context, listen: false).setTodos(todos);

        await prefs.setString('user', jsonEncode(userData));
        await prefs.setString('todos', jsonEncode(todoJson));

        // Verifikasi penyimpanan
        print('User saved: ${jsonEncode(userData)}');
        print('Todos saved: ${jsonEncode(todoJson)}');

        return responseData;
      } else {
        throw responseData;
      }
    } catch (error) {
      print("Error during login: $error");
      throw {"message": "Login gagal", "details": error.toString()};
    }
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw {"message": "Token tidak ditemukan, mungkin belum login"};
    }

    final url = Uri.parse('http://todo-list-app.test/api/auth/logout');

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

  static Future<bool> restoreSession(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final userJson = prefs.getString('user');
    final todosJson = prefs.getString('todos');

    if (token != null && userJson != null && todosJson != null) {
      final userData = jsonDecode(userJson);
      final todoData = jsonDecode(todosJson);

      final user = UserModel.fromJson(userData);
      final todos =
          (todoData as List).map((t) => TodoModel.fromJson(t)).toList();

      Provider.of<UserProvider>(context, listen: false).setUser(user);
      Provider.of<TodoProvider>(
        context,
        listen: false,
      ).setTodos(todos); // Pastikan ini benar

      return true;
    }
    return false;
  }
}
