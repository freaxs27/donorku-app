import 'package:flutter/material.dart';

class RezaChatbotPage extends StatelessWidget {
  const RezaChatbotPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reza Chatbot')),
      body: const Center(
        child: Text(
          'Reza Chatbot (C-001)',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ),
    );
  }
}