import 'package:flutter/material.dart';

class ChatCsPage extends StatelessWidget {
  const ChatCsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hubungi Staf Dukungan')),
      body: const Center(
        child: Text(
          'Chat CS (CA-001)',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ),
    );
  }
}