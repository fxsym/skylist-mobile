import 'package:flutter/material.dart';
import 'package:skylist_mobile/screens/home_screen.dart';
import 'package:skylist_mobile/screens/register_screen.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart'; // Import halaman DashboardScreen

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Flutter App',
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
      initialRoute: '/login', // Menentukan halaman pertama
      routes: {
        '/login': (context) => LoginScreen(), // Halaman login
        '/register': (context) => RegisterScreen(),
        '/home': (context) => HomeScreen(),
        '/dashboard': (context) => DashboardScreen(), 
      },
    );
  }
}
