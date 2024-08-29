import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'UI/home/home.dart'; // Đường dẫn import đến home.dart của bạn

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Login Demo',
      debugShowCheckedModeBanner: false,
      home: LoginForm(),
    );
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

      // Tạo dữ liệu yêu cầu
      final Map<String, String> data = {
        'username': username,
        'password': password,
      };

      try {
        // Gửi yêu cầu POST đến API
        final response = await http.post(
          Uri.parse('http://192.168.1.9:9001/login'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(data),
        );

        // Kiểm tra phản hồi từ server
        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);
          // print('Login successful: $responseData');

          // Điều hướng đến HomeScreen và truyền dữ liệu
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => moneynoteHome(metadata: responseData),
            ),
          );
        } else {
          // Hiển thị thông báo lỗi nếu đăng nhập thất bại
          _showErrorDialog('Login failed: ${response.statusCode}');
        }
      } catch (e) {
        // Hiển thị thông báo lỗi khi có lỗi
        _showErrorDialog('Error: $e');
      }
    }
  }

  // Hàm hiển thị thông báo lỗi
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
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _login,
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
