import 'package:flutter/material.dart';

class IELTSWritingPage extends StatefulWidget {
  const IELTSWritingPage({super.key});

  @override
  _IELTSWritingPageState createState() => _IELTSWritingPageState();
}

class _IELTSWritingPageState extends State<IELTSWritingPage> {
  final TextEditingController _promptController = TextEditingController();
  final TextEditingController _writingController = TextEditingController();
  String _generatedPrompt = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("IELTS Writing"), backgroundColor: Colors.deepPurple),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// **Title**
            const Text(
              "Enter a Writing Topic:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            /// **Text Input for Writing Prompt**
            TextField(
              controller: _promptController,
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
                  _generatedPrompt = _promptController.text;
                });
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
              child: const Text("Generate", style: TextStyle(color: Colors.white)),
            ),

            const SizedBox(height: 20),

            /// **Display Generated Writing Prompt**
            _generatedPrompt.isNotEmpty
                ? Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "📝 Writing Topic: $_generatedPrompt",
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    ),
                  )
                : const SizedBox(),

            const SizedBox(height: 20),

            /// **Text Area for Writing**
            Expanded(
              child: TextField(
                controller: _writingController,
                maxLines: null,
                expands: true,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  hintText: "Start writing here...",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
