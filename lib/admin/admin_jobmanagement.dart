import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminJobManagementScreen extends StatefulWidget {
  const AdminJobManagementScreen({super.key});

  @override
  _AdminJobManagementScreenState createState() => _AdminJobManagementScreenState();
}

class _AdminJobManagementScreenState extends State<AdminJobManagementScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _approveJob(String companyId, String jobId) async {
    await _firestore
        .collection('companies')
        .doc(companyId)
        .collection('jobs')
        .doc(jobId)
        .update({'approved': true});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Job approved successfully")),
    );
  }

  Future<void> _rejectJob(String companyId, String jobId) async {
    await _firestore
        .collection('companies')
        .doc(companyId)
        .collection('jobs')
        .doc(jobId)
        .delete();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Job rejected and removed")),
    );
  }

  Future<void> _flagJob(String companyId, String jobId) async {
    await _firestore
        .collection('companies')
        .doc(companyId)
        .collection('jobs')
        .doc(jobId)
        .update({'flagged': true});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Job has been flagged")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin: Job Management'),
        backgroundColor: Colors.deepPurple,
      ),
      body: StreamBuilder(
        stream: _firestore.collection('companies').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No companies found"));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var company = snapshot.data!.docs[index];
              return ExpansionTile(
                title: Text(company['name']),
                children: [
                  StreamBuilder(
                    stream: _firestore
                        .collection('companies')
                        .doc(company.id)
                        .collection('jobs')
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> jobSnapshot) {
                      if (!jobSnapshot.hasData || jobSnapshot.data!.docs.isEmpty) {
                        return Padding(
                          padding: EdgeInsets.all(10),
                          child: Text("No jobs available for this company"),
                        );
                      }
                      return Column(
                        children: jobSnapshot.data!.docs.map((job) {
                          return Card(
                            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                            child: ListTile(
                              title: Text(job['title']),
                              subtitle: Text("${job['description']}"),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.check, color: Colors.green),
                                    onPressed: () => _approveJob(company.id, job.id),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.close, color: Colors.red),
                                    onPressed: () => _rejectJob(company.id, job.id),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.flag, color: Colors.orange),
                                    onPressed: () => _flagJob(company.id, job.id),
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
              );
            },
          );
        },
      ),
    );
  }
}
