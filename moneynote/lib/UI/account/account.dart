// account.dart
import 'package:BalanceTracker/main.dart';
import 'package:flutter/material.dart';

class AccountPage extends StatelessWidget {
  final Map<String, dynamic> metadata;
  final VoidCallback onLogout;

  const AccountPage(
      {super.key, required this.metadata, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Tài khoản'),
        ),
        body: Column(
          children: [
            // Center(
            //   child: Text('Dữ liệu tài khoản: ${metadata.toString()}'),
            // ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                  margin: const EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 4, // Tăng blurRadius để shadow rõ hơn
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Material(
                    borderRadius: BorderRadius.circular(8),
                    child: InkWell(
                      onTap: () {
                        onLogout();

                        // Navigate to the login screen
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => const LoginForm()),
                          (Route<dynamic> route) => false,
                        );
                      },
                      splashColor: Colors.grey.withOpacity(0.3), // Màu gợn sóng
                      customBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8)),
                        child: const Row(
                          mainAxisAlignment:
                              MainAxisAlignment.end, // Align to the right
                          children: [
                            Expanded(child: Text("Đăng xuất")),
                            Icon(Icons.logout)
                          ],
                        ),
                      ),
                    ),
                  )),
            )
          ],
        ));
  }
}
