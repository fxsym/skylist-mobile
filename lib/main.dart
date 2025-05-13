import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skylist_mobile/providers/todo_provider.dart';
import 'package:skylist_mobile/providers/user_provider.dart'; // Import provider
import 'package:skylist_mobile/screens/add_todo_screen.dart';
import 'package:skylist_mobile/screens/home_screen.dart';
import 'package:skylist_mobile/screens/main_layout_screen.dart';
import 'package:skylist_mobile/screens/register_screen.dart';
import 'package:skylist_mobile/screens/login_screen.dart';
import 'package:skylist_mobile/screens/dashboard_screen.dart';
import 'package:skylist_mobile/screens/splash_screen.dart';
import 'package:skylist_mobile/screens/todo_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => TodoProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Flutter App',
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash',
      routes: {
        '/': (context) => HomeScreen(),
        '/splash': (context) => SplashScreen(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/dashboard': (context) => DashboardScreen(),
        '/main': (context) => MainLayout(),
        '/add-todo': (context) => AddTodoScreen()
      },
      onGenerateRoute: (settings) {
        final uri = Uri.parse(settings.name ?? '');
        if (uri.pathSegments.length == 2 && uri.pathSegments.first == 'todo') {
          final todoId = uri.pathSegments[1]; // Ambil ID dari URL
          return MaterialPageRoute(
            builder:
                (context) =>
                    TodoScreen(todoId: todoId), // Kirim ID ke TodoScreen
          );
        }
        return null; // Kembalikan null jika tidak ditemukan rute
      },
    );
  }
}
