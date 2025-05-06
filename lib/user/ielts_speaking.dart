import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  void _startTimer() {
    _timer?.cancel();
    setState(() {
      _remainingTime = 120;
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

  Stream<QuerySnapshot> fetchSuggestions() {
    return FirebaseFirestore.instance
        .collection('resources')
        .where('module', whereIn: ['Speaking', 'All'])
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("IELTS Speaking"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Enter a Speaking Topic:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _promptController,
                decoration: InputDecoration(
                  hintText: "Type a topic...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _generatedPrompt = _promptController.text;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                ),
                child: const Text(
                  "Generate",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              _generatedPrompt.isNotEmpty
                  ? Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          "🎤 Speaking Topic: $_generatedPrompt",
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                      ),
                    )
                  : const SizedBox(),
              const SizedBox(height: 20),
              if (_generatedPrompt.isNotEmpty)
                Column(
                  children: [
                    Text(
                      "Remaining Time: $_remainingTime sec",
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _startTimer,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                      ),
                      child: const Text(
                        "Start Speaking",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 30),
              const Text(
                "Suggestions:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              StreamBuilder<QuerySnapshot>(
                stream: fetchSuggestions(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Error loading suggestions');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }

                  final docs = snapshot.data!.docs;

                  if (docs.isEmpty) {
                    return const Text("No suggestions available.");
                  }

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: docs.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 3 / 2,
                    ),
                    itemBuilder: (context, index) {
                      final doc = docs[index];
                      final title = doc['title'] ?? '';
                      final text = doc['preview'] ?? '';
                      final preview = text.length > 100
                          ? '${text.substring(0, 100)}...'
                          : text;

                      return Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Expanded(
                                child: Text(
                                  preview,
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
