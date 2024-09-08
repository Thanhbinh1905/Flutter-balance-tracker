import 'package:flutter/material.dart';
import 'package:moneynote/main.dart';

class SignUpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
       
            // Image.asset('assets/images/pig.png', height: 100),
              SizedBox(height: 100),
              Text(
                'Đăng ký',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 30),
              _buildTextField('Tên tài khoản'),
              SizedBox(height: 15),
              _buildTextField('Mật khẩu', isPassword: true),
              SizedBox(height: 15),
              _buildTextField('Gmail'),
              SizedBox(height: 15),
              _buildTextField('Số điện thoại'),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Bạn đã có tài khoản? '),
                  TextButton(
                    onPressed: () {
                 Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginForm()),
                      );
                    },
                    child: Text('Đăng nhập', style: TextStyle(color: Colors.green)),
                  ),
                ],
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Xử lý đăng ký
                  },
                  child: Text('Đăng ký',style: TextStyle(color: Colors.white, fontSize: 15),),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, {bool isPassword = false}) {
    return TextField(
      obscureText: isPassword,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[200],
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
