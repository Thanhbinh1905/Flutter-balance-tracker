import 'package:flutter/material.dart';

class Bcao extends StatelessWidget {
  final Map<String, dynamic> metadata;

  const Bcao({super.key, required this.metadata});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Báo cáo - Username: ${metadata["username"]}'),
      ),
    );
  }
}
