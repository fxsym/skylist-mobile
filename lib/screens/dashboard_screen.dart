import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:skylist_mobile/components/todo_status_section.dart';
import 'package:skylist_mobile/models/todo_model.dart';
import 'package:skylist_mobile/providers/todo_provider.dart';
import '../services/auth_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String userName = 'User';

  @override
  void initState() {
    super.initState();
    loadUserData();
    restoreTodoData();
  }

  Future<void> loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user');
    if (userJson != null) {
      final userData = json.decode(userJson);
      setState(() {
        userName = userData['name'] ?? 'User';
      });
    }
  }

  Future<void> restoreTodoData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final todosJson = prefs.getString('todos');
    if (todosJson != null) {
      final todoData = json.decode(todosJson);
      final todos =
          (todoData as List).map((t) => TodoModel.fromJson(t)).toList();
      Provider.of<TodoProvider>(context, listen: false).setTodos(todos);
    }
  }

  @override
  Widget build(BuildContext context) {
    final todos = Provider.of<TodoProvider>(context).todos;

    final notStarted = todos.where((t) => t.status == 'Not started').length;
    final inProgress = todos.where((t) => t.status == 'In progress').length;
    final completed = todos.where((t) => t.status == 'Completed').length;

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Salam dan jumlah to-dos
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hi, $userName 👋',
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'You now have ${todos.length} todos',
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),

            /// Status section
            TodoStatusSection(
              notStartedCount: notStarted,
              inProgressCount: inProgress,
              completedCount: completed,
            ),

            const SizedBox(height: 24),

            /// Recent To-dos
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent To-dos',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/todos');
                  },
                  child: const Text(
                    'See all to-dos',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: todos.length > 5 ? 5 : todos.length,
              itemBuilder: (context, index) {
                final todo = todos[index];
                return ListTile(
                  title: Text(todo.title),
                  subtitle: Text(todo.status),
                );
              },
            ),

            const SizedBox(height: 24),

            /// Logout
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    await AuthService.logout();
                    Provider.of<TodoProvider>(
                      context,
                      listen: false,
                    ).clearTodos();
                    Navigator.pushReplacementNamed(context, '/login');
                  } catch (error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Logout gagal: $error')),
                    );
                  }
                },
                child: const Text('Logout'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
