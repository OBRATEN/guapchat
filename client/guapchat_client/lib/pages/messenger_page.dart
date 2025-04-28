import 'package:flutter/material.dart';
import 'chat_interface.dart';
import 'package:guapchat_client/core/ws_client.dart';
import 'dart:convert';
import 'package:guapchat_client/globals.dart' as globals;
import 'package:guapchat_client/entity/dialogue.dart';

class MessengerPage extends StatefulWidget {
  @override
  _MessengerPageState createState() => _MessengerPageState();
}

class _MessengerPageState extends State<MessengerPage> {
  late final WebSocketClient _webSocketClient;

  final List<Map<String, String>> _dialogues = [];
  final TextEditingController _searchController = TextEditingController();
  List<String> _similar_usernames = [];

  // Currently selected dialogue
  Map<String, String>? _selectedDialogue;

  // Messages for the selected dialogue
  final Map<String, List<String>> _messages = {};

  @override
  void initState() {
    super.initState();
    _webSocketClient = WebSocketClient(
      'ws://localhost:4444/socket/websocket?token=${globals.access_token}',
    );
    _webSocketClient.connect();
    _webSocketClient.onMessageReceived = (message) {
      try {
        final parsedMessage = jsonDecode(message);
        switch (parsedMessage["event"]) {
          case "GET_DIALOGUES_LIST":
            List<dynamic> parsedList = jsonDecode(
              parsedMessage["payload"]["dialogues"],
            );
            List<Map<String, dynamic>> listOfMaps =
                List<Map<String, dynamic>>.from(parsedList);
            for (var diaMap in listOfMaps) {
              Dialogue dia = Dialogue(
                diaMap["id"],
                diaMap["user2_id"],
                diaMap["username2"],
                diaMap["last_message"],
                diaMap["last_message_date"],
              );
              globals.dialogues.add(dia);
              Map<String, String> listMap = {
                "name": dia.username,
                "lastMessage": dia.lastMessageText,
                "time": dia.lastMessageDate,
              };
              _dialogues.add(listMap);
            }
            break;
          case "SIMILAR_USERS":
            dynamic usernamesData =
                parsedMessage["payload"]["usernames"];
            List<String> usernames;
            if (usernamesData is String) {
              usernames = [usernamesData];
            } else if (usernamesData is List<dynamic>) {
              usernames = usernamesData.map((item) => item.toString()).toList();
            } else {
              throw FormatException(
                "Unexpected type for usernames: ${usernamesData.runtimeType}",
              );
            }

            setState(() {
              _similar_usernames.clear();
              _similar_usernames.addAll(usernames);
            });
            break;
        }
      } catch (e) {
        print("Failed to parse message: $e");
      }
    };
    _webSocketClient.send(
      '{"topic":"main","event":"phx_join","payload":{},"ref":1}',
    );
    _webSocketClient.send(
      '{"topic":"main","event":"get_dialogues","payload":{"count": 7},"ref":6}',
    );
  }

  // Function to select a dialogue
  void _selectDialogue(Map<String, String> dialogue) {
    setState(() {
      _selectedDialogue = dialogue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Messenger')),
      body: Row(
        children: [
          // Left Column: Dialogues List
          Container(
            width: 300, // Fixed width for the dialogues list
            child: Column(
              children: [
                // Search Widget
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'Search',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (query) {
                      if (query.isNotEmpty) {
                        _webSocketClient.send(
                          '{"topic":"main","event":"search_user","payload":{"username":"$query"},"ref":1}',
                        );
                      } else {
                        setState(() {
                          _similar_usernames.clear(); // Clear results if query is empty
                        });
                      }
                    },
                  ),
                ),
                // Dropdown-like suggestions
                if (_similar_usernames.isNotEmpty)
                  AnimatedContainer(
                    duration: Duration(milliseconds: 300), // Smooth animation
                    height: 150, // Fixed height for the dropdown
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _similar_usernames.length,
                      itemBuilder: (context, index) {
                        final username = _similar_usernames[index];
                        return ListTile(
                          title: Text(username),
                          onTap: () {
                            setState(() {
                              _searchController.text =
                                  username; // Set the search field to the selected username
                              _similar_usernames.clear(); // Clear the dropdown
                            });
                          },
                        );
                      },
                    ),
                  ),
                // Dialogues List
                Expanded(
                  child: ListView.builder(
                    itemCount: _dialogues.length,
                    itemBuilder: (context, index) {
                      final dialogue = _dialogues[index];
                      return ListTile(
                        onTap: () => _selectDialogue(dialogue),
                        leading: CircleAvatar(
                          child: Text(dialogue['name']![0]),
                        ),
                        title: Text(dialogue['name']!),
                        subtitle: Text(dialogue['lastMessage']!),
                        trailing: Text(
                          dialogue['time']!,
                          style: TextStyle(fontSize: 12),
                        ),
                        selected: _selectedDialogue == dialogue,
                        selectedTileColor: Colors.blue[100],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          // Right Column: Chat Interface
          Expanded(
            child:
                _selectedDialogue == null
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