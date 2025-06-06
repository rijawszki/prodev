
 import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
 import 'chat_screen.dart'; 

class CandidatesPage extends StatefulWidget {
  const CandidatesPage({super.key});
  
  @override
  _CandidatesPageState createState() => _CandidatesPageState();
}

class _CandidatesPageState extends State<CandidatesPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _deleteApplication(String applicationId) async {
    try {
      await _firestore.collection('applications').doc(applicationId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Application deleted successfully")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error deleting application: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = _auth.currentUser;

    if (currentUser == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Candidates")),
        body: const Center(child: Text("Not logged in.")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Candidates for Your Jobs"),
        backgroundColor: Colors.deepPurple,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('applications')
            .where('companyId', isEqualTo: currentUser.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          var applications = snapshot.data!.docs;

          if (applications.isEmpty) {
            return const Center(child: Text("No applicants for your jobs yet."));
          }

          return ListView.builder(
            itemCount: applications.length,
            itemBuilder: (context, index) {
              var application = applications[index];
              var data = application.data() as Map<String, dynamic>;

              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                child: ListTile(
                  title: Text("${data['applicantName']} - ${data['jobTitle']}"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CandidateDetailPage(
                          applicationId: application.id,
                          applicationData: data,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class CandidateDetailPage extends StatelessWidget {
  final String applicationId;
  final Map<String, dynamic> applicationData;

  const CandidateDetailPage({
    super.key,
    required this.applicationId,
    required this.applicationData,
  });

  Future<void> _deleteApplication(BuildContext context) async {
    try {
      await FirebaseFirestore.instance.collection('applications').doc(applicationId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Application deleted")),
      );
      Navigator.pop(context); // Go back after delete
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

// Add this import at the top

void _startChat(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ChatScreen(
        chatPartnerName: applicationData['applicantName'] ??
            "${applicationData['firstName']} ${applicationData['lastName']}",
        receiverId: applicationData['applicantId'], // <-- ✅ Add this
      ),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(applicationData['applicantName'] ?? 'Candidate Details'),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildReadOnlyField("First Name", applicationData['firstName']),
            _buildReadOnlyField("Last Name", applicationData['lastName']),
            _buildReadOnlyField("Phone Number", applicationData['phone']),
            _buildReadOnlyField("Email", applicationData['email']),
            _buildReadOnlyField("Address", applicationData['address']),
            _buildReadOnlyField("Willing to Relocate", applicationData['relocate']),
            _buildReadOnlyField("Experience", applicationData['experience']),
            _buildReadOnlyField("CV URL", applicationData['cvUrl']),
            _buildReadOnlyField("Status", applicationData['status']),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _deleteApplication(context),
                  icon: const Icon(Icons.delete),
                  label: const Text("Reject"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton.icon(
                onPressed: () => _startChat(context),
                icon: const Icon(Icons.chat),
                label: const Text("Chat"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildReadOnlyField(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(value ?? "-"),
          ),
        ],
      ),
    );
  }
}
