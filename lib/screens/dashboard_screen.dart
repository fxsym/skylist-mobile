import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

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
      throw {
        "message": "Logout gagal",
        "details": error.toString()
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Selamat datang!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  try {
                    await logout();
                    // Jika logout berhasil, redirect ke halaman login
                    Navigator.pushReplacementNamed(context, '/login');
                  } catch (error) {
                    // Menampilkan pesan error jika logout gagal
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(error.toString())),
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
