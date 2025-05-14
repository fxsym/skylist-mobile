import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const String API_URL = "https://skylist-api.vercel.app/api/api";

class TodoService {
  // Get list of todos
  Future<List<dynamic>> getTodos() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await http.get(
        Uri.parse('$API_URL/todos'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body)['data'];
      } else {
        throw Exception('Failed to load todos');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }

  // Create a new todo
  Future<Map<String, dynamic>> createTodo(
    String title,
    String description,
    String status,
    List<int> categories,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final data = {
        'title': title,
        'description': description,
        'status': status,
        'categories': categories,
      };

      final response = await http.post(
        Uri.parse('$API_URL/todo/create'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to create todo');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }

  // Update an existing todo
  Future<Map<String, dynamic>> updateTodo(
    int todoId,
    String title,
    String description,
    String status,
    List<int> categories,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final data = {
        'title': title,
        'description': description,
        'status': status,
        'categories': categories,
      };

      final response = await http.patch(
        Uri.parse('$API_URL/todo/$todoId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to update todo');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }

  // Delete a todo
  Future<Map<String, dynamic>> deleteTodo(int todoId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final link = '$API_URL/todo/$todoId';

      final response = await http.delete(
        Uri.parse(link),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
          'Failed to delete todo: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }
}
