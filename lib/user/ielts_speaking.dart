import 'package:flutter/material.dart';
import 'dart:async';

class IELTSSpeakingPage extends StatefulWidget {
  const IELTSSpeakingPage({super.key});

  @override
  _IELTSSpeakingPageState createState() => _IELTSSpeakingPageState();
}

class _IELTSSpeakingPageState extends State<IELTSSpeakingPage> {
  final TextEditingController _promptController = TextEditingController();
  String _generatedPrompt = "";
  Timer? _timer;
  int _remainingTime = 120; // 2 minutes timer

  /// **Starts Timer for Speaking Practice**
  void _startTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }
    setState(() {
      _remainingTime = 120; // Reset timer
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        timer.cancel();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Time's up!")),
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("IELTS Speaking"), backgroundColor: Colors.deepPurple),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// **Title**
            const Text(
              "Enter a Speaking Topic:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            /// **Text Input for Speaking Prompt**
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

            /// **Display Generated Speaking Prompt**
            _generatedPrompt.isNotEmpty
                ? Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "🎤 Speaking Topic: $_generatedPrompt",
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    ),
                  )
                : const SizedBox(),

            const SizedBox(height: 20),

            /// **Speaking Timer**
            if (_generatedPrompt.isNotEmpty)
              Column(
                children: [
                  Text(
                    "Remaining Time: $_remainingTime sec",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _startTimer,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
                    child: const Text("Start Speaking", style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
