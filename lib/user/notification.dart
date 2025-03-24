import 'package:flutter/material.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  /// **Sample Notifications List**
  final List<Map<String, String>> _notifications = [
    {"title": "New Job Alert!", "message": "A new job opportunity is available in your area."},
    {"title": "IELTS Tip", "message": "Practice reading daily to improve your IELTS score."},
    {"title": "Game Challenge", "message": "A new game challenge is live. Play now!"},
    {"title": "Update Available", "message": "A new update has been released for the app."},
  ];

  /// **Daily Affirmations**
  final List<String> _affirmations = [
    "I am capable and strong.",
    "Every day brings new opportunities.",
    "I believe in myself and my journey.",
    "I am worthy of success and happiness.",
    "My potential is limitless."
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// **Notifications Section**
            Text("Notifications",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
            SizedBox(height: 10),

            Expanded(
              child: ListView.builder(
                itemCount: _notifications.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 3,
                    margin: EdgeInsets.symmetric(vertical: 6),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                      leading: Icon(Icons.notifications, color: Colors.deepPurple),
                      title: Text(_notifications[index]["title"]!, style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(_notifications[index]["message"]!),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 20),

            /// **Daily Affirmations**
            Text("Daily Affirmation",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
            SizedBox(height: 10),

            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.deepPurple[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  _affirmations[DateTime.now().day % _affirmations.length], // Rotating affirmation
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
