import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminCompanyManagementScreen extends StatefulWidget {
  const AdminCompanyManagementScreen({super.key});

  @override
  _AdminCompanyManagementScreenState createState() =>
      _AdminCompanyManagementScreenState();
}

class _AdminCompanyManagementScreenState
    extends State<AdminCompanyManagementScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _approveCompany(String companyId) async {
    await _firestore
        .collection('companies')
        .doc(companyId)
        .update({'isApproved': true});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("✅ Company approved successfully")),
    );
  }

  Future<void> _rejectCompany(String companyId) async {
    await _firestore.collection('companies').doc(companyId).delete();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("❌ Company rejected and removed")),
    );
  }

  Future<void> _editCompanyDetails(String companyId, String newName) async {
    if (newName.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Company name cannot be empty!")),
      );
      return;
    }

    await _firestore
        .collection('companies')
        .doc(companyId)
        .update({'name': newName});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("✏ Company details updated")),
    );
  }

  void _showJobListings(String companyId) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => CompanyJobListingsScreen(companyId: companyId)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🚀 Manage Companies'),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple.shade50, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: StreamBuilder(
          stream: _firestore
              .collection('companies')
              .where('isApproved', isEqualTo: false)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text("🎉 No pending company approvals!",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              );
            }

            return ListView.builder(
              padding: EdgeInsets.all(12),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var company = snapshot.data!.docs[index];

                return Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 6,
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.deepPurple.shade100,
                        backgroundImage:
                            company['profileImageUrl'] != null &&
                                    company['profileImageUrl'] != ''
                                ? NetworkImage(company['profileImageUrl'])
                                : null,
                        child: company['profileImageUrl'] == ''
                            ? Icon(Icons.business, size: 30)
                            : null,
                      ),
                      title: Text(
                        company['name'],
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 6.0),
                        child: Text(
                          "📧 ${company['email']}\n📍 ${company['address']}",
                          style: TextStyle(height: 1.3),
                        ),
                      ),
                      trailing: Wrap(
                        spacing: 6,
                        children: [
                          _actionIcon(
                              icon: Icons.check_circle,
                              color: Colors.green,
                              onTap: () => _approveCompany(company.id)),
                          _actionIcon(
                              icon: Icons.cancel,
                              color: Colors.red,
                              onTap: () => _rejectCompany(company.id)),
                          _actionIcon(
                              icon: Icons.edit,
                              color: Colors.blue,
                              onTap: () {
                                TextEditingController _controller =
                                    TextEditingController(
                                        text: company['name']);
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text("✏ Edit Company Name"),
                                    content: TextField(
                                      controller: _controller,
                                      decoration: InputDecoration(
                                          hintText: "Enter new name"),
                                    ),
                                    actions: [
                                      TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: Text("Cancel")),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                Colors.deepPurple),
                                        onPressed: () {
                                          _editCompanyDetails(
                                              company.id, _controller.text);
                                          Navigator.pop(context);
                                        },
                                        child: Text("Save"),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                          _actionIcon(
                              icon: Icons.list,
                              color: Colors.orange,
                              onTap: () => _showJobListings(company.id)),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _actionIcon(
      {required IconData icon,
      required Color color,
      required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: EdgeInsets.all(6),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withOpacity(0.1),
        ),
        child: Icon(icon, size: 22, color: color),
      ),
    );
  }
}

/// 🏢 Company Job Listings Screen
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple.shade50, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: StreamBuilder(
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
              return Center(
                child: Text("🚫 No job listings found",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              );
            }

            return ListView.builder(
              padding: EdgeInsets.all(12),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var job = snapshot.data!.docs[index];

                return Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    title: Text(job['title'],
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17)),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(job['description']),
                    ),
                    trailing: Icon(Icons.work, color: Colors.deepPurple),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
