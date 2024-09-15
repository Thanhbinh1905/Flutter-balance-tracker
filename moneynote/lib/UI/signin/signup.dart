import 'package:flutter/material.dart';
import 'package:BalanceTracker/main.dart';
import 'dart:convert';
import 'package:BalanceTracker/constants/constant.dart';
import 'package:http/http.dart' as http;

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  String _passwordStrengthMessage = '';

  void _checkPasswordStrength(String password) {
    if (password.length < 6) {
      _passwordStrengthMessage = 'Mật khẩu quá ngắn';
    } else if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{6,}$')
        .hasMatch(password)) {
      _passwordStrengthMessage = 'Mật khẩu cần có chữ hoa, chữ thường và số';
    } else {
      _passwordStrengthMessage = 'Mật khẩu mạnh';
    }
    setState(() {});
  }

  Future<void> _register() async {
    final data = {
      'username': _usernameController.text,
      'password': _passwordController.text,
      'gmail': _emailController.text,
    };

    try {
      final response = await http.post(
        Uri.parse('${GetConstant().apiEndPoint}/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData is Map<String, dynamic>) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LoginForm()),
          );
        } else {
          _showErrorDialog('Dữ liệu trả về không hợp lệ');
        }
      } else {
        _showErrorDialog('Đăng ký thất bại: ${response.statusCode}');
      }
    } catch (e) {
      _showErrorDialog('Lỗi: ${e.toString()}');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Lỗi'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 100),
              const Text(
                'Đăng ký',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              _buildTextField('Tên tài khoản', _usernameController),
              const SizedBox(height: 15),
              _buildTextField('Mật khẩu', _passwordController,
                  isPassword: true, isNewPassword: true),
              if (_passwordStrengthMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    _passwordStrengthMessage,
                    style: TextStyle(
                      color: _passwordStrengthMessage == 'Mật khẩu mạnh'
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                ),
              const SizedBox(height: 15),
              _buildTextField('Gmail', _emailController),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Bạn đã có tài khoản? '),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginForm()),
                      );
                    },
                    child: const Text('Đăng nhập',
                        style: TextStyle(color: Colors.green)),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: const Text(
                    'Đăng ký',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool isPassword = false, bool isNewPassword = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          obscureText: isPassword,
          onChanged: isNewPassword ? _checkPasswordStrength : null,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[200],
            labelText: label,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
