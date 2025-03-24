import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class JobListingsPage extends StatefulWidget {
  const JobListingsPage({super.key});

  @override
  _JobListingsPageState createState() => _JobListingsPageState();
}

class _JobListingsPageState extends State<JobListingsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// **Show Application Form**
  void _showApplicationForm(String jobId, String jobTitle, String companyId, String companyName) {
    TextEditingController coverLetterController = TextEditingController();
    TextEditingController skillsController = TextEditingController();
    TextEditingController resumeLinkController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Apply for $jobTitle"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: coverLetterController,
                  decoration: InputDecoration(labelText: "Cover Letter"),
                  maxLines: 3,
                ),
                TextField(
                  controller: skillsController,
                  decoration: InputDecoration(labelText: "Skills (comma-separated)"),
                ),
                TextField(
                  controller: resumeLinkController,
                  decoration: InputDecoration(labelText: "Resume Link (Optional)"),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), 
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                await _applyForJob(
                  jobId, jobTitle, companyId, companyName,
                  coverLetterController.text, skillsController.text, resumeLinkController.text,
                );
                Navigator.pop(context); // Close the dialog after applying
              },
              child: Text("Submit"),
            ),
          ],
        );
      },
    );
  }

  /// **Apply for a Job with Form Data**
  Future<void> _applyForJob(
    String jobId, String jobTitle, String companyId, String companyName,
    String coverLetter, String skills, String resumeLink
  ) async {
    User? user = _auth.currentUser;

    if (user != null) {
      try {
        // Check if user has already applied
        var existingApplication = await _firestore
            .collection('applications')
            .where('jobId', isEqualTo: jobId)
            .where('applicantId', isEqualTo: user.uid)
            .get();

        if (existingApplication.docs.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("You have already applied for this job.")),
          );
          return;
        }

        // Save application to Firestore
        await _firestore.collection('applications').add({
          'jobId': jobId,
          'companyId': companyId,
          'companyName': companyName,
          'jobTitle': jobTitle,
          'applicantId': user.uid,
          'applicantName': user.displayName ?? "Applicant",
          'coverLetter': coverLetter.isEmpty ? "Not Provided" : coverLetter,
          'skills': skills.isEmpty ? "Not Provided" : skills,
          'resumeLink': resumeLink.isEmpty ? "Not Provided" : resumeLink,
          'status': "Pending",
          'appliedDate': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Application sent successfully!")),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error applying for job: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Available Jobs"), backgroundColor: Colors.deepPurple),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('jobs').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // Show loading spinner
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error loading jobs. Please try again."));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No jobs available."));
          }

          var jobs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: jobs.length,
            itemBuilder: (context, index) {
              var job = jobs[index].data() as Map<String, dynamic>;

              return Card(
                elevation: 3,
                margin: EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  title: Text(job['jobTitle'] ?? "Unknown Job"),
                  subtitle: Text(
                    "Company: ${job['companyName'] ?? 'Unknown'}\nSalary: ${job['salary'] ?? 'Not Specified'}",
                  ),
                  trailing: ElevatedButton(
                    onPressed: () => _showApplicationForm(
                      jobs[index].id,
                      job['jobTitle'] ?? "Unknown Job",
                      job['companyId'] ?? "Unknown Company ID",
                      job['companyName'] ?? "Unknown Company",
                    ),
                    child: Text("Apply"),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
