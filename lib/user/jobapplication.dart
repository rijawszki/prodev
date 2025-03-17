import 'package:flutter/material.dart';

class JobApplicationsPage extends StatelessWidget {
  final List<Map<String, dynamic>> jobApplications = [
    {"company": "Google", "position": "Software Engineer", "status": "Pending"},
    {"company": "Microsoft", "position": "Data Scientist", "status": "Approved"},
    {"company": "Amazon", "position": "Cloud Engineer", "status": "Pending"},
    {"company": "Tesla", "position": "AI Researcher", "status": "Approved"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Job Applications"),
        backgroundColor: Colors.deepPurple,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: jobApplications.length,
          itemBuilder: (context, index) {
            final job = jobApplications[index];
            return _buildJobTile(context, job);
          },
        ),
      ),
    );
  }

  /// **Job Tile Widget**
  Widget _buildJobTile(BuildContext context, Map<String, dynamic> job) {
    bool isApproved = job["status"] == "Approved";
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: Icon(
          isApproved ? Icons.check_circle : Icons.hourglass_empty,
          color: isApproved ? Colors.green : Colors.orange,
          size: 30,
        ),
        title: Text(job["position"], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        subtitle: Text(job["company"]),
        trailing: Text(
          job["status"],
          style: TextStyle(color: isApproved ? Colors.green : Colors.orange, fontWeight: FontWeight.bold),
        ),
        onTap: () {
          // Navigate to job details page (if needed)
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => JobDetailsPage(job: job),
            ),
          );
        },
      ),
    );
  }
}

/// **Job Details Page**
class JobDetailsPage extends StatelessWidget {
  final Map<String, dynamic> job;
  
  JobDetailsPage({required this.job});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Job Details"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Position: ${job["position"]}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text("Company: ${job["company"]}", style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text(
              "Status: ${job["status"]}",
              style: TextStyle(fontSize: 18, color: job["status"] == "Approved" ? Colors.green : Colors.orange),
            ),
          ],
        ),
      ),
    );
  }
}
