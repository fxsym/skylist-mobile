import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart'; // ganti path sesuai
import '../services/device_service.dart'; // ganti path sesuai
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _handleLogin() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final username = _emailController.text.trim();
      final password = _passwordController.text.trim();
      final device = await getDeviceName();
      print('Username: $username, Password: $password, Device: $device');
      final result = await AuthService.login(username, password, device);

      if (result.containsKey('token')) {
        Navigator.pushReplacementNamed(context, '/dashboard');
      } else {
        setState(() {
          _errorMessage = result['message'] ?? 'Login gagal';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage =
            e is Map<String, dynamic> ? e['message'] : 'Login gagal';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_errorMessage ?? 'Terjadi kesalahan'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child:
              isLargeScreen
                  ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(width: 500, child: _buildLoginForm(context)),
                      const SizedBox(width: 50),
                      Image.asset(
                        'assets/images/AccountCreated.jpg',
                        width: 350,
                        fit: BoxFit.contain,
                      ),
                    ],
                  )
                  : _buildLoginForm(context),
        ),
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Login to your account",
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Text(
          "You must have an account first to be able to log in. Log in and save the activities you will do, access from anywhere and anytime.",
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
        ),
        const SizedBox(height: 32),
        if (_errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(_errorMessage!, style: TextStyle(color: Colors.red)),
          ),
        TextField(
          controller: _emailController,
          decoration: InputDecoration(
            labelText: 'Insert your username',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _passwordController,
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Insert your password',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Colors.lightBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            onPressed: _isLoading ? null : _handleLogin,
            child:
                _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Login', style: TextStyle(fontSize: 18)),
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(child: Divider(color: Colors.grey[400])),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text("Or"),
            ),
            Expanded(child: Divider(color: Colors.grey[400])),
          ],
        ),
        const SizedBox(height: 16),
        Center(
          child: TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => RegisterScreen()),
              );
            },
            child: const Text(
              "Don't have an account? Create Account",
              style: TextStyle(
                color: Colors.lightBlue,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
