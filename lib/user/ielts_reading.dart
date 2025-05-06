import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class IELTSReadingPage extends StatefulWidget {
  const IELTSReadingPage({super.key});

  @override
  _IELTSReadingPageState createState() => _IELTSReadingPageState();
}

class _IELTSReadingPageState extends State<IELTSReadingPage> {
  final TextEditingController _topicController = TextEditingController();
  String _generatedTopic = "";

  Stream<QuerySnapshot> fetchSuggestions() {
    return FirebaseFirestore.instance
        .collection('resources')
        .where('module', whereIn: ['Reading', 'All'])
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("IELTS Reading"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Enter a Reading Topic:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _topicController,
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
                    _generatedTopic = _topicController.text;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                ),
                child: const Text("Generate", style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 20),
              _generatedTopic.isNotEmpty
                  ? Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          "📖 Reading Topic: $_generatedTopic",
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                      ),
                    )
                  : const SizedBox(),
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
                      final preview = text.length > 100 ? '${text.substring(0, 100)}...' : text;

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
