import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  final String chatPartnerName;

  const ChatScreen({super.key, required this.chatPartnerName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with $chatPartnerName'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: const [
                // Example messages
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Hi, I applied for the job!"),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text("Thanks for applying. Let's discuss."),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: "Type your message...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    // Implement send functionality here
                  },
                  child: const Icon(Icons.send),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
