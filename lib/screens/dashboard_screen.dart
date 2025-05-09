import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skylist_mobile/providers/todo_provider.dart';
import '../providers/user_provider.dart';
import '../services/auth_service.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    final todos = Provider.of<TodoProvider>(context).todos;

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard'), centerTitle: true),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ListView perlu di-wrap dengan Expanded agar bisa menyesuaikan ukuran
              Expanded(
                child: ListView.builder(
                  itemCount: todos.length,
                  itemBuilder: (context, index) {
                    final todo = todos[index];
                    return ListTile(
                      title: Text(todo.title),
                      subtitle: Text(todo.status),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Selamat datang, ${user?.name ?? "User"}!',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              if (user != null) ...[
                Text('Username: ${user.username}'),
                Text('Email: ${user.email}'),
              ],
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  try {
                    await AuthService.logout(); // Gunakan AuthService untuk logout
                    // Clear user dari provider
                    Provider.of<UserProvider>(context, listen: false).clearUser();
                    Provider.of<TodoProvider>(context, listen: false).clearTodos();
                    Navigator.pushReplacementNamed(context, '/login');
                  } catch (error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Logout gagal: $error')),
                    );
                  }
                },
                child: const Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
