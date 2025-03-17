import 'package:flutter/material.dart';

class IELTSReadingPage extends StatefulWidget {
  const IELTSReadingPage({super.key});

  @override
  _IELTSReadingPageState createState() => _IELTSReadingPageState();
}

class _IELTSReadingPageState extends State<IELTSReadingPage> {
  final TextEditingController _topicController = TextEditingController();
  String _generatedTopic = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("IELTS Reading"), backgroundColor: Colors.deepPurple),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Enter a Reading Topic:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            /// **Text Input Field**
            TextField(
              controller: _topicController,
              decoration: InputDecoration(
                hintText: "Type a topic...",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 10),

            /// **Generate Button**
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _generatedTopic = _topicController.text;
                });
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
              child: const Text("Generate", style: TextStyle(color: Colors.white)),
            ),

            const SizedBox(height: 20),

            /// **Display the Generated Topic**
            _generatedTopic.isNotEmpty
                ? Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "📖 Reading Topic: $_generatedTopic",
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    ),
                  )
                : const SizedBox(), // Empty if no topic is generated
          ],
        ),
      ),
    );
  }
}
