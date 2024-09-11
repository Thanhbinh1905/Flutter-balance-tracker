import 'package:flutter/material.dart';
import 'package:BalanceTracker/main.dart'; // Đường dẫn đến file login

class orther extends StatelessWidget {
  final Map<String, dynamic> metadata;

  const orther({super.key, required this.metadata});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Khác'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Các widget khác của mục orther

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Gọi phương thức đăng xuất khi nút được nhấn
                _logout(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Màu của nút
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Đăng xuất',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _logout(BuildContext context) async {
    // Xóa dữ liệu người dùng nếu cần
    // Ví dụ: Xóa metadata hoặc token nếu cần thiết
    // Preferences.remove('user_metadata'); // Nếu bạn sử dụng SharedPreferences

    // Điều hướng về màn hình đăng nhập và xóa tất cả các màn hình hiện tại
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginForm()),
      (Route<dynamic> route) => false,
    );
  }
}
