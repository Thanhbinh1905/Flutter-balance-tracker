import 'package:flutter/material.dart';

class khac extends StatelessWidget {
  final Map<String, dynamic> metadata;

  const khac({super.key, required this.metadata});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('khac'),
      ),
    );
  }
}
