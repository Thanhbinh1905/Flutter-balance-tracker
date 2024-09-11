import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'UI/home/home.dart'; // Đường dẫn import đến home.dart của bạn
import 'package:BalanceTracker/constants/constant.dart';
import 'package:BalanceTracker/UI/signin/signup.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: _checkLoginStatus(),
    );
  }

  Widget _checkLoginStatus() {
    // Implement actual login status check
    return FutureBuilder<bool>(
      future: _getLoginStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return snapshot.data == true ? const BalanceTrackerHome(metadata: {}) : const LoginForm();
        }
        return const CircularProgressIndicator();
      },
    );
  }

  Future<bool> _getLoginStatus() async {
    // TODO: Implement actual login status check
    // For example, check if a token exists in secure storage
    await Future.delayed(Duration(seconds: 1)); // Simulating async operation
    return false; // Return true if logged in, false otherwise
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      final username = _usernameController.text;
      final password = _passwordController.text;

      final Map<String, String> data = {
        'username': username,
        'password': password,
      };

      try {
        final response = await http.post(
          Uri.parse('${GetConstant().apiEndPoint}/login'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(data),
        );

        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);
          if (responseData is Map<String, dynamic>) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    BalanceTrackerHome(metadata: responseData),
              ),
            );
          } else {
            _showErrorDialog('Wrong username or password, please try again');
          }
        } else {
          _showErrorDialog('Login failed: ${response.statusCode}');
        }
      } catch (e) {
        _showErrorDialog('Error: ${e.toString()}');
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 20),
              const Text(
                'Đăng nhập',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Tên tài khoản',
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tên tài khoản';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Mật khẩu',
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập mật khẩu';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Bạn chưa có tài khoản? '),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignUpScreen()),
                      );
                      // TODO: Implement registration logic
                    },
                    child: const Text(
                      'Đăng ký',
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                  child: const Text(
                    'Đăng nhập',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
