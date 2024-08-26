import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final Map<String, dynamic> metadata;

  HomeScreen({required this.metadata});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('User ID: ${metadata['_id']}'),
            Text('Username: ${metadata['username']}'),
            Text('Gmail: ${metadata['gmail']}'),
            Text('Phone: ${metadata['phone']}'),
            Text('Created At: ${metadata['createdAt']}'),
            Text('Updated At: ${metadata['updatedAt']}'),
          ],
        ),
      ),
    );
  }
}
