import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class IELTSWritingPage extends StatefulWidget {
  const IELTSWritingPage({super.key});

  @override
  _IELTSWritingPageState createState() => _IELTSWritingPageState();
}

class _IELTSWritingPageState extends State<IELTSWritingPage> {
  final TextEditingController _promptController = TextEditingController();
  String _generatedPrompt = "";

  Stream<QuerySnapshot> fetchSuggestions() {
    return FirebaseFirestore.instance
        .collection('resources')
        .where('module', whereIn: ['Writing', 'All'])
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("IELTS Writing"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Enter a Writing Topic:",
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
                child: const Text("Generate", style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 20),
              _generatedPrompt.isNotEmpty
                  ? Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          "📝 Writing Topic: $_generatedPrompt",
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
