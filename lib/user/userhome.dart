import 'package:flutter/material.dart';
import 'jobapplication.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView( // ✅ Prevents bottom overflow
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// **Title**
              Text(
                "Dashboard",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.deepPurple),
              ),
              SizedBox(height: 10),

              /// **IELTS Progress Section**
              _buildSectionTitle("IELTS Progress"),
              _buildProgressTile("Reading", 0.75),
              _buildProgressTile("Writing", 0.60),
              _buildProgressTile("Listening", 0.85),
              _buildProgressTile("Speaking", 0.40),
              SizedBox(height: 20),

              /// **Job Applications Section**
              _buildSectionTitle("Job Applications"),
              _buildJobApplicationTile(context, 5), // ✅ Fixed: Pass context
            ],
          ),
        ),
      ),
    );
  }

  /// **Reusable Section Title**
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black87),
      ),
    );
  }

  /// **Progress Tile for IELTS**
  Widget _buildProgressTile(String skill, double progress) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(skill, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[300],
              color: Colors.deepPurple,
              minHeight: 8,
            ),
            SizedBox(height: 5),
            Text("${(progress * 100).toInt()}% completed", style: TextStyle(color: Colors.grey[700])),
          ],
        ),
      ),
    );
  }

  /// **Job Application Tile**
  Widget _buildJobApplicationTile(BuildContext context, int pendingApplications) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: Icon(Icons.work, size: 30, color: Colors.deepPurple),
        title: Text("Pending Applications", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        subtitle: Text("$pendingApplications applications waiting for review"),
        trailing: Icon(Icons.arrow_forward_ios, size: 18),
        onTap: () {
          Navigator.pushNamed(context, "/JobApplicationsPage"); // ✅ Fixed semicolon
        },
      ),
    );
  }
}
