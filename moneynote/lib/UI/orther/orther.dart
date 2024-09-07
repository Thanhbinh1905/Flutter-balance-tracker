import 'package:flutter/material.dart';

class orther extends StatelessWidget {
  final Map<String, dynamic> metadata;

  const orther({super.key, required this.metadata});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.color_lens),
            title: const Text('Change Theme'),
            onTap: () {
              // TODO: Implement theme change functionality
              print('Change theme tapped');
            },
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Change Language'),
            onTap: () {
              // TODO: Implement language change functionality
              print('Change language tapped');
            },
          ),
        ],
      ),
    );
  }
}
