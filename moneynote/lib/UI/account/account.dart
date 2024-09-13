import 'package:BalanceTracker/main.dart';
import 'package:flutter/material.dart';

class AccountPage extends StatelessWidget {
  final Map<String, dynamic> metadata;
  final VoidCallback onLogout;

  const AccountPage(
      {super.key, required this.metadata, required this.onLogout});

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận'),
          content: const Text('Bạn có chắc chắn muốn đăng xuất không?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại
              },
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(); // Đóng hộp thoại trước khi đăng xuất
                onLogout(); // Gọi hàm đăng xuất

                // Điều hướng tới trang đăng nhập
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginForm()),
                  (Route<dynamic> route) => false,
                );
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
        appBar: AppBar(
          title: const Text(
            'Tài khoản',
            style: TextStyle(fontSize: 16),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Container(
                margin: const EdgeInsets.only(top: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
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
                child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(8)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Text(
                                " Người dùng: ${metadata['username']}",
                                style: const TextStyle(fontSize: 18),
                              ),
                            )
                          ],
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.grey.withOpacity(
                                    0.5), // Màu và độ mờ của viền dưới
                                width: 0.5, // Độ dày của viền dưới
                              ),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              " Email: ${metadata['gmail']}",
                              style: const TextStyle(color: Colors.grey),
                            )
                          ],
                        ),
                        // Row(
                        //   children: [
                        //     Text(" Số điện thoại: ${metadata['phone']}",
                        //         style: const TextStyle(color: Colors.grey))
                        //   ],
                        // )
                      ],
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
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
                      onTap: () {},
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
                            Expanded(child: Text("Đổi mật khẩu")),
                            Icon(
                              Icons.password,
                              size: 20,
                            )
                          ],
                        ),
                      ),
                    ),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 63, right: 63),
              child: Container(
                margin: const EdgeInsets.only(top: 26),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Material(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.red.withOpacity(0.95),
                  child: InkWell(
                    onTap: () {
                      _showLogoutConfirmation(
                          context); // Hiển thị popup xác nhận
                    },
                    splashColor: Colors.grey.withOpacity(0.3),
                    customBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(child: Text("Đăng xuất ")), // Căn giữa chữ
                          Icon(Icons.logout, size: 15) // Icon vẫn nằm bên phải
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
