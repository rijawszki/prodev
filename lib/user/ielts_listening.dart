import 'package:flutter/material.dart';

class IELTSListeningPage extends StatefulWidget {
  @override
  _IELTSListeningPageState createState() => _IELTSListeningPageState();
}

class _IELTSListeningPageState extends State<IELTSListeningPage> {
  final TextEditingController _promptController = TextEditingController();
  String generatedResponse = "";

  void _generateListeningTask() {
    setState(() {
      if (_promptController.text.isNotEmpty) {
        generatedResponse =
            "Listening Task: You have chosen '${_promptController.text}'. Please listen carefully and answer the following questions based on it.";
      } else {
        generatedResponse = "Please enter a subject to generate a task.";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("IELTS Listening"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// **Prompt Input Field**
            Text(
              "Enter a subject for the IELTS Listening task:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _promptController,
              decoration: InputDecoration(
                hintText: "E.g., Technology in Education",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 15),

            /// **Generate Button**
            ElevatedButton(
              onPressed: _generateListeningTask,
              child: Text("Generate Task"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 12),
                textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20),

            /// **Generated Response Display**
            if (generatedResponse.isNotEmpty)
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    generatedResponse,
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
