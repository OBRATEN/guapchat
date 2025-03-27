import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  final String userName;

  ChatPage({required this.userName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(userName), // Display the user's name in the app bar
      ),
      body: Center(
        child: Text('Chat with $userName'), // Placeholder for chat UI
      ),
    );
  }
}