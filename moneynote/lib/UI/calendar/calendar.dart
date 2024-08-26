import 'package:flutter/material.dart';

class calendar extends StatelessWidget {
  final Map<String, dynamic> metadata;

  const calendar({super.key, required this.metadata});

  @override
  Widget build(BuildContext context) {
    final userMetadata = metadata['metadata'];
    return Scaffold(
      body: Center(
        child: Text('Lich - Username: ${userMetadata['username']}'),
      ),
    );
  }
}
