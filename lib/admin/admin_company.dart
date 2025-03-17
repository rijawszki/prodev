import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminCompanyManagementScreen extends StatefulWidget {
  const AdminCompanyManagementScreen({super.key});

  @override
  _AdminCompanyManagementScreenState createState() => _AdminCompanyManagementScreenState();
}

class _AdminCompanyManagementScreenState extends State<AdminCompanyManagementScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// ✅ **Approve Company**
  Future<void> _approveCompany(String companyId) async {
    await _firestore.collection('companies').doc(companyId).update({'isApproved': true});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("✅ Company approved successfully")),
    );
  }

  /// ❌ **Reject & Delete Company**
  Future<void> _rejectCompany(String companyId) async {
    await _firestore.collection('companies').doc(companyId).delete();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("❌ Company rejected and removed")),
    );
  }

  /// ✏ **Edit Company Name**
  Future<void> _editCompanyDetails(String companyId, String newName) async {
    if (newName.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Company name cannot be empty!")),
      );
      return;
    }

    await _firestore.collection('companies').doc(companyId).update({'name': newName});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("✏ Company details updated")),
    );
  }

  /// 🔍 **View Company Job Listings**
  void _showJobListings(String companyId) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CompanyJobListingsScreen(companyId: companyId)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin: Company Management'),
        backgroundColor: Colors.deepPurple,
      ),
      body: StreamBuilder(
        /// ✅ **Only Show Pending Approvals**
        stream: _firestore.collection('companies').where('isApproved', isEqualTo: false).snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("🎉 No pending approvals!"));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var company = snapshot.data!.docs[index];

              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  leading: company['profileImageUrl'] != ''
                      ? CircleAvatar(backgroundImage: NetworkImage(company['profileImageUrl']))
                      : CircleAvatar(child: Icon(Icons.business)),

                  title: Text(company['name']),
                  subtitle: Text("📧 Email: ${company['email']}\n📍 Address: ${company['address']}"),

                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      /// ✅ Approve Button
                      IconButton(
                        icon: Icon(Icons.check_circle, color: Colors.green),
                        onPressed: () => _approveCompany(company.id),
                      ),

                      /// ❌ Reject Button
                      IconButton(
                        icon: Icon(Icons.cancel, color: Colors.red),
                        onPressed: () => _rejectCompany(company.id),
                      ),

                      /// ✏ Edit Button
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          TextEditingController _controller = TextEditingController(text: company['name']);
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text("✏ Edit Company Name"),
                              content: TextField(
                                controller: _controller,
                                decoration: InputDecoration(hintText: "Enter new name"),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    _editCompanyDetails(company.id, _controller.text);
                                    Navigator.pop(context);
                                  },
                                  child: Text("Save"),
                                ),
                              ],
                            ),
                          );
                        },
                      ),

                      /// 🔍 Job Listings Button
                      IconButton(
                        icon: Icon(Icons.list, color: Colors.orange),
                        onPressed: () => _showJobListings(company.id),
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

/// 🏢 **Company Job Listings Screen**
class CompanyJobListingsScreen extends StatelessWidget {
  final String companyId;
  const CompanyJobListingsScreen({super.key, required this.companyId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("📋 Company Job Listings"),
        backgroundColor: Colors.deepPurple,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('companies')
            .doc(companyId)
            .collection('jobs')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("🚫 No job listings found"));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var job = snapshot.data!.docs[index];

              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text(job['title'], style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(job['description']),
                  trailing: Icon(Icons.work, color: Colors.deepPurple),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
