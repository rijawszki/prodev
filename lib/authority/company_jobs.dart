import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CompanyJobsPage extends StatefulWidget {
  const CompanyJobsPage({super.key});

  @override
  _CompanyJobsPageState createState() => _CompanyJobsPageState();
}

class _CompanyJobsPageState extends State<CompanyJobsPage> {
  final TextEditingController _jobTitleController = TextEditingController();
  final TextEditingController _jobDescriptionController = TextEditingController();
  final TextEditingController _jobRequirementsController = TextEditingController();
  final TextEditingController _jobSalaryController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// **Upload Job Posting to Firestore**
  Future<void> _postJob() async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('jobs').add({
        'companyId': user.uid,
        'jobTitle': _jobTitleController.text,
        'description': _jobDescriptionController.text,
        'requirements': _jobRequirementsController.text,
        'salary': _jobSalaryController.text,
        'createdAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Job Posted Successfully!")),
      );

      _jobTitleController.clear();
      _jobDescriptionController.clear();
      _jobRequirementsController.clear();
      _jobSalaryController.clear();
    }
  }

  /// **Update Application Status in Firestore**
  Future<void> _updateApplicationStatus(String applicationId, String status) async {
    await _firestore.collection('applications').doc(applicationId).update({'status': status});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Application $status!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Post a Job", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),

            /// **Job Posting Form**
            TextField(controller: _jobTitleController, decoration: InputDecoration(labelText: "Job Title")),
            TextField(controller: _jobDescriptionController, decoration: InputDecoration(labelText: "Job Description")),
            TextField(controller: _jobRequirementsController, decoration: InputDecoration(labelText: "Job Requirements")),
            TextField(controller: _jobSalaryController, decoration: InputDecoration(labelText: "Salary")),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _postJob,
              child: Text("Post Job"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
            ),
            SizedBox(height: 20),

            /// **Job Applications Section**
            Text("Applications Received", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),

            /// **StreamBuilder to fetch job applications dynamically**
            StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('applications').where('companyId', isEqualTo: _auth.currentUser?.uid).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

                var applications = snapshot.data!.docs;
                if (applications.isEmpty) return Text("No applications received yet.");

                return Column(
                  children: applications.map((doc) {
                    var data = doc.data() as Map<String, dynamic>;
                    return Card(
                      elevation: 3,
                      margin: EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        title: Text(data['applicantName'] ?? "Unknown Applicant"),
                        subtitle: Text("Job: ${data['jobTitle']}\nStatus: ${data['status']}"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.check, color: Colors.green),
                              onPressed: () => _updateApplicationStatus(doc.id, "Accepted"),
                            ),
                            IconButton(
                              icon: Icon(Icons.close, color: Colors.red),
                              onPressed: () => _updateApplicationStatus(doc.id, "Rejected"),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
