import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:BalanceTracker/constants/constant.dart';
import 'package:BalanceTracker/UI/account/changepassword.dart';
import 'package:BalanceTracker/UI/account/account.dart';

class OtpScreen extends StatefulWidget {
  final Map<String, dynamic> metadata;
  const OtpScreen({super.key, required this.metadata});

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController _otpController = TextEditingController();
  bool _isOtpSent = false;
  bool _isLoading = false;
  int _remainingSeconds = 60; // Thời gian đếm ngược OTP
  Timer? _timer;
  bool _isOtpExpired = false;

  // Hàm gửi OTP
  Future<void> _sendOtp() async {
    setState(() {
      _isLoading = true;
      _isOtpExpired = false;
    });

    try {
      final response = await http.post(
        Uri.parse('${GetConstant().apiEndPoint}/send-otp'),
        headers: {
          'Content-Type': 'application/json',
          'CLIENT_ID': widget.metadata['_id'],
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          _isOtpSent = true;
          _startCountdown(); // Bắt đầu đếm ngược
        });
      } else {
        _showErrorDialog('Gửi OTP thất bại: ${response.statusCode}');
      }
    } catch (e) {
      _showErrorDialog('Lỗi: ${e.toString()}');
    }

    setState(() {
      _isLoading = false;
    });
  }

  // Hàm kiểm tra OTP
  Future<void> _verifyOtp() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('${GetConstant().apiEndPoint}/handle-otp'),
        headers: {
          'Content-Type': 'application/json',
          'CLIENT_ID': widget.metadata['_id'],
        },
        body: jsonEncode({'otp': _otpController.text.replaceAll(' ', '')}),
      );

      if (response.statusCode == 200) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ChangePassWordPage(metadata: widget.metadata)),
        );
      } else {
        print('response');
        print(response.body);
        print(_otpController.text);
        _showErrorDialog('OTP không hợp lệ hoặc hết hạn.');
      }
    } catch (e) {
      _showErrorDialog('Lỗi: ${e.toString()}');
    }

    setState(() {
      _isLoading = false;
    });
  }

  // Hàm bắt đầu đếm ngược
  void _startCountdown() {
    _remainingSeconds = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (mounted) {
          _remainingSeconds--;
        }
      });

      if (_remainingSeconds == 0) {
        timer.cancel();
        setState(() {
          _isOtpExpired = true;
        });
      }
    });
  }

  // Hiển thị thông báo lỗi
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

  // Hiển thị thông báo thành công
  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Thành công'),
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
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Xác minh OTP'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _sendOtp,
                child: _isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text('Gửi OTP'),
              ),
            ),
            if (_isOtpSent) ...[
              const SizedBox(height: 20),
              const Text('Nhập mã OTP:'),
              TextField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'OTP',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'OTP sẽ hết hạn sau: $_remainingSeconds giây',
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: (_isLoading || _isOtpExpired) ? null : _verifyOtp,
                  child: _isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text('Xác minh OTP'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
