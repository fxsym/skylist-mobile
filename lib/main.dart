import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skylist_mobile/providers/user_provider.dart'; // Import provider
import 'package:skylist_mobile/screens/home_screen.dart';
import 'package:skylist_mobile/screens/register_screen.dart';
import 'package:skylist_mobile/screens/login_screen.dart';
import 'package:skylist_mobile/screens/dashboard_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()), // Daftarkan UserProvider
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
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/home': (context) => HomeScreen(),
        '/dashboard': (context) => DashboardScreen(),
      },
    );
  }
}
