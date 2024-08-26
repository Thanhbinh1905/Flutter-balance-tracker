import 'package:flutter/material.dart';

class lich extends StatelessWidget {
  final Map<String, dynamic> metadata;

  const lich({super.key, required this.metadata});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('lich'),
      ),
    );
  }
}
