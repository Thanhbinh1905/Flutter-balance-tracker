import 'package:flutter/material.dart';

class report extends StatelessWidget {
  final Map<String, dynamic> metadata;

  const report({super.key, required this.metadata});

  @override
  Widget build(BuildContext context) {
    final userMetadata = metadata["metadata"];
    return Scaffold(
      body: Center(
        child: Text('Báo cáo - Username: ${userMetadata['username']}'),
      ),
    );
  }
}
