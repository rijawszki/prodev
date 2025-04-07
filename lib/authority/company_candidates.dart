import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CandidatesPage extends StatefulWidget {
  final String jobId;

  const CandidatesPage({super.key, required this.jobId});

  @override
  _CandidatesPageState createState() => _CandidatesPageState();
}

class _CandidatesPageState extends State<CandidatesPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Function to update application status (approve/reject)
  Future<void> _updateApplicationStatus(String applicationId, String status) async {
    try {
      await _firestore.collection('applications').doc(applicationId).update({
        'status': status,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Application status updated to $status")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating application status: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Candidates for the Job"),
        backgroundColor: Colors.deepPurple,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('applications')
            .where('jobId', isEqualTo: widget.jobId) // Get applications for the specific job
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var applications = snapshot.data!.docs;
          if (applications.isEmpty) {
            return Center(child: Text("No applicants yet."));
          }

          return ListView.builder(
            itemCount: applications.length,
            itemBuilder: (context, index) {
              var application = applications[index].data() as Map<String, dynamic>;
              return Card(
                elevation: 3,
                margin: EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  title: Text(application['applicantName']),
                  subtitle: Text(
                    "Cover Letter: ${application['coverLetter']}\n"
                    "Skills: ${application['skills']}\n"
                    "Status: ${application['status']}",
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _updateApplicationStatus(applications[index].id, "Approved");
                        },
                        child: Text("Approve"),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      ),
                      SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {
                          _updateApplicationStatus(applications[index].id, "Rejected");
                        },
                        child: Text("Reject"),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      ),
                    ],
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
