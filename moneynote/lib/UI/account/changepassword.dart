import 'package:flutter/material.dart';
import 'package:BalanceTracker/UI/account/account.dart';
import 'package:BalanceTracker/constants/constant.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChangePassWordPage extends StatefulWidget {
  final Map<String, dynamic> metadata;
  const ChangePassWordPage({super.key, required this.metadata});

  @override
  _ChangePassWordPageState createState() => _ChangePassWordPageState();
}

class _ChangePassWordPageState extends State<ChangePassWordPage> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _newPasswordController2 = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _newPasswordController2.dispose();
    super.dispose();
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Lỗi"),
          content: Text(message),
          actions: <Widget>[
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

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Thành công"),
          content: const Text("Đổi mật khẩu thành công"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại
                Navigator.of(context).pop(); // Quay lại màn hình trước đó
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _changePassWord(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    final data = {'newPassword': _newPasswordController.text};
    try {
      final response = await http.post(
        Uri.parse('${GetConstant().apiEndPoint}/change-password'),
        headers: {
          'Content-Type': 'application/json',
          'CLIENT_ID': widget.metadata['_id'],
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData is Map<String, dynamic>) {
          _showSuccessDialog(context);
        } else {
          _showErrorDialog(context, 'Dữ liệu trả về không hợp lệ');
        }
      } else {
        _showErrorDialog(
            context, 'Đổi mật khẩu thất bại: ${response.statusCode}');
      }
    } catch (e) {
      _showErrorDialog(context, 'Lỗi: ${e.toString()}');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Xác nhận "),
          content: const Text("Bạn có muốn thay đổi mật khẩu mới này không?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại
              },
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại xác nhận
                _changePassWord(context); // Gọi hàm đổi mật khẩu
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
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 100),
              const Text(
                'Đổi mật khẩu',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              _buildTextField('Mật khẩu mới', _newPasswordController,
                  isPassword: true, isNewPassword: true),
              const SizedBox(height: 15),
              _buildTextField('Nhập lại mật khẩu', _newPasswordController2,
                  isPassword: true),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                          if (_newPasswordController.text !=
                              _newPasswordController2.text) {
                            _showErrorDialog(
                                context, "Mật khẩu mới không trùng khớp .");
                          } else {
                            _showConfirmation(
                                context); // Show confirmation dialog
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Đổi mật khẩu',
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
        if (isNewPassword)
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
      ],
    );
  }
}
