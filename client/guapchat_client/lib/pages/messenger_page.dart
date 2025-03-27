import 'package:flutter/material.dart';
import 'chat_interface.dart';

class MessengerPage extends StatefulWidget {
  @override
  _MessengerPageState createState() => _MessengerPageState();
}

class _MessengerPageState extends State<MessengerPage> {
  // Sample data for dialogues
  final List<Map<String, String>> _dialogues = [
    {'name': 'Alice', 'lastMessage': 'Hey, how are you?', 'time': '10:30 AM'},
    {'name': 'Bob', 'lastMessage': 'See you later!', 'time': 'Yesterday'},
    {'name': 'Charlie', 'lastMessage': 'Can we meet tomorrow?', 'time': '12:45 PM'},
  ];

  // Currently selected dialogue
  Map<String, String>? _selectedDialogue;

  // Messages for the selected dialogue
  final Map<String, List<String>> _messages = {
    'Alice': ['Hi Alice!', 'How are you?'],
    'Bob': ['Hello Bob!', 'Let me know when you are free.'],
    'Charlie': ['Hey Charlie!', 'What time works for you?'],
  };

  // Function to select a dialogue
  void _selectDialogue(Map<String, String> dialogue) {
    setState(() {
      _selectedDialogue = dialogue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Messenger'),
      ),
      body: Row(
        children: [
          // Left Column: Dialogues List
          Container(
            width: 300, // Fixed width for the dialogues list
            child: ListView.builder(
              itemCount: _dialogues.length,
              itemBuilder: (context, index) {
                final dialogue = _dialogues[index];
                return ListTile(
                  onTap: () => _selectDialogue(dialogue),
                  leading: CircleAvatar(
                    child: Text(dialogue['name']![0]), // Display the first letter of the name
                  ),
                  title: Text(dialogue['name']!),
                  subtitle: Text(dialogue['lastMessage']!),
                  trailing: Text(dialogue['time']!, style: TextStyle(fontSize: 12)),
                  selected: _selectedDialogue == dialogue,
                  selectedTileColor: Colors.blue[100],
                );
              },
            ),
          ),
          // Right Column: Chat Interface
          Expanded(
            child: _selectedDialogue == null
                ? Center(child: Text('Select a dialogue to start chatting'))
                : ChatInterface(
                    userName: _selectedDialogue!['name']!,
                    messages: _messages[_selectedDialogue!['name']]!,
                  ),
          ),
        ],
      ),
    );
  }
}