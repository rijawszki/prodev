import 'package:flutter/material.dart';

class IeltsPage extends StatelessWidget {
  const IeltsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "IELTS Learning Topics",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          
          // List of IELTS Topics
          Expanded(
            child: ListView(
              children: [
                _buildTopicTile("Listening", Icons.headphones, context),
                _buildTopicTile("Reading", Icons.book, context),
                _buildTopicTile("Writing", Icons.edit, context),
                _buildTopicTile("Speaking", Icons.mic, context),
                _buildTopicTile("Mock Tests", Icons.quiz, context),
                _buildTopicTile("Tips & Strategies", Icons.lightbulb, context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// **Creates a tile for IELTS topics**
  Widget _buildTopicTile(String title, IconData icon, BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(icon, color: Colors.deepPurple),
        title: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("$title section coming soon!")),
          );
        },
      ),
    );
  }
}
