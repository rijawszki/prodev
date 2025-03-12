import 'package:flutter/material.dart';

class JobsPage extends StatelessWidget {
  const JobsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Job Listings",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          
          // List of Job Postings
          Expanded(
            child: ListView(
              children: [
                _buildJobTile("Software Engineer", "Google", Icons.computer, context),
                _buildJobTile("Data Analyst", "Amazon", Icons.analytics, context),
                _buildJobTile("Graphic Designer", "Adobe", Icons.brush, context),
                _buildJobTile("Marketing Specialist", "Facebook", Icons.campaign, context),
                _buildJobTile("Cyber Security Expert", "Microsoft", Icons.security, context),
                _buildJobTile("UI/UX Designer", "Apple", Icons.design_services, context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// **Creates a tile for job listings**
  Widget _buildJobTile(String jobTitle, String company, IconData icon, BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(icon, color: Colors.deepPurple),
        title: Text(jobTitle, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
        subtitle: Text(company, style: const TextStyle(fontSize: 16, color: Colors.grey)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Details for $jobTitle at $company coming soon!")),
          );
        },
      ),
    );
  }
}
