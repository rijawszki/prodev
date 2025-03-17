import 'package:flutter/material.dart';
import 'dart:async';

class MockTestsPage extends StatefulWidget {
  const MockTestsPage({super.key});

  @override
  _MockTestsPageState createState() => _MockTestsPageState();
}

class _MockTestsPageState extends State<MockTestsPage> {
  List<String> sections = ["Listening", "Reading", "Writing", "Speaking"];
  String? selectedSection;
  Timer? _timer;
  int _remainingTime = 900; // Default 15 min for a test
  bool _isTestRunning = false;

  /// **Starts the Mock Test Timer**
  void _startTest() {
    if (selectedSection == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a section to start the test!")),
      );
      return;
    }

    setState(() {
      _remainingTime = 900; // Reset to 15 minutes
      _isTestRunning = true;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        timer.cancel();
        setState(() {
          _isTestRunning = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Time's up! Test finished.")),
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
      appBar: AppBar(title: const Text("Mock Tests"), backgroundColor: Colors.deepPurple),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// **Title**
            const Text(
              "Select an IELTS Section:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            /// **Dropdown for Selecting IELTS Section**
            DropdownButton<String>(
              value: selectedSection,
              hint: const Text("Choose a section"),
              isExpanded: true,
              items: sections.map((section) {
                return DropdownMenuItem(
                  value: section,
                  child: Text(section),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedSection = value;
                });
              },
            ),
            const SizedBox(height: 20),

            /// **Start Test Button**
            ElevatedButton(
              onPressed: _isTestRunning ? null : _startTest,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
              child: Text(_isTestRunning ? "Test Running..." : "Start Test", style: const TextStyle(color: Colors.white)),
            ),

            const SizedBox(height: 20),

            /// **Mock Test Timer**
            if (_isTestRunning)
              Column(
                children: [
                  Text(
                    "Time Remaining: ${(_remainingTime ~/ 60)}:${(_remainingTime % 60).toString().padLeft(2, '0')}",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                  const SizedBox(height: 10),
                  const Text("Focus and complete your test within the time limit."),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
