import 'package:flutter/material.dart';

class IELTSPage extends StatefulWidget {
  @override
  _IELTSPageState createState() => _IELTSPageState();
}

class _IELTSPageState extends State<IELTSPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _aiChatController = TextEditingController();
  List<Map<String, String>> _chatMessages = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  void _sendMessage() {
    if (_aiChatController.text.isNotEmpty) {
      setState(() {
        _chatMessages.add({'user': _aiChatController.text});
        _chatMessages.add({'ai': 'This is an AI response to your question!'}); // Placeholder AI response
        _aiChatController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("IELTS Preparation"),
        backgroundColor: Colors.deepPurple,
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(icon: Icon(Icons.menu_book), text: "Reading"),
            Tab(icon: Icon(Icons.create), text: "Writing"),
            Tab(icon: Icon(Icons.mic), text: "Speaking"),
            Tab(icon: Icon(Icons.headset), text: "Listening"),
            Tab(icon: Icon(Icons.smart_toy), text: "AI Assistant"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildReadingSection(),
          _buildWritingSection(),
          _buildSpeakingSection(),
          _buildListeningSection(),
          _buildAIAssistant(),
        ],
      ),
    );
  }

  /// **Reading Section**
  Widget _buildReadingSection() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.menu_book, size: 80, color: Colors.deepPurple),
            SizedBox(height: 20),
            Text(
              "IELTS Reading Practice",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "Improve your reading skills with sample tests and exercises.",
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// **Writing Section**
  Widget _buildWritingSection() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.create, size: 80, color: Colors.deepPurple),
            SizedBox(height: 20),
            Text(
              "IELTS Writing Tasks",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "Practice writing essays, reports, and letters for IELTS exams.",
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// **Speaking Section**
  Widget _buildSpeakingSection() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.mic, size: 80, color: Colors.deepPurple),
            SizedBox(height: 20),
            Text(
              "IELTS Speaking Practice",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "Prepare for your speaking test with mock interviews and sample questions.",
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// **Listening Section**
  Widget _buildListeningSection() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.headset, size: 80, color: Colors.deepPurple),
            SizedBox(height: 20),
            Text(
              "IELTS Listening Tests",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "Practice listening exercises and improve your comprehension skills.",
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// **AI Assistant Chat Section**
  Widget _buildAIAssistant() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(10),
            itemCount: _chatMessages.length,
            itemBuilder: (context, index) {
              final message = _chatMessages[index];
              final isUser = message.containsKey('user');
              return Align(
                alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isUser ? Colors.deepPurpleAccent : Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    message.values.first,
                    style: TextStyle(color: isUser ? Colors.white : Colors.black),
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _aiChatController,
                  decoration: InputDecoration(
                    hintText: "Ask IELTS Assistant...",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              SizedBox(width: 10),
              IconButton(
                icon: Icon(Icons.send, color: Colors.deepPurple),
                onPressed: _sendMessage,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
