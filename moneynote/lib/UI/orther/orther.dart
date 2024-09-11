import 'package:flutter/material.dart';
import 'package:BalanceTracker/main.dart'; // Đường dẫn đến file login

class orther extends StatelessWidget {
  final Map<String, dynamic> metadata;
  final VoidCallback onLogout;

  const orther({
    Key? key,
    required this.metadata,
    required this.onLogout,
  }) : super(key: key);

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
                // Call the onLogout function
                onLogout();

                // Navigate to the login screen
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const MyApp()),
                  (Route<dynamic> route) => false,
                );
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
}
