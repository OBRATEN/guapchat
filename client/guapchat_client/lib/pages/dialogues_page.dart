import 'package:flutter/material.dart';
import 'chat_page.dart'; // Import the chat page for navigation

class DialoguesPage extends StatelessWidget {
  // Sample data for dialogues
  final List<Map<String, dynamic>> _dialogues = [
    {
      'name': 'Alice',
      'lastMessage': 'Hey, how are you?',
      'time': '10:30 AM',
    },
    {
      'name': 'Bob',
      'lastMessage': 'See you later!',
      'time': 'Yesterday',
    },
    {
      'name': 'Charlie',
      'lastMessage': 'Can we meet tomorrow?',
      'time': '12:45 PM',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dialogues'),
      ),
      body: ListView.builder(
        itemCount: _dialogues.length,
        itemBuilder: (context, index) {
          final dialogue = _dialogues[index];
          return ListTile(
            onTap: () {
              // Navigate to the chat page when a dialogue is tapped
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatPage(userName: dialogue['name']),
                ),
              );
            },
            leading: CircleAvatar(
              child: Text(dialogue['name'][0]), // Display the first letter of the name
            ),
            title: Text(dialogue['name']),
            subtitle: Text(dialogue['lastMessage']),
            trailing: Text(dialogue['time'], style: TextStyle(fontSize: 12)),
          );
        },
      ),
    );
  }
}