import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chat")),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [ListTile(title: Text("Sample message..."))],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(hintText: "Type a message"),
                ),
              ),
              IconButton(
                icon: Icon(Icons.send),
                onPressed: () {
                  setState(() {
                    _controller.clear();
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
