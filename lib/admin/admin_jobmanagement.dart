import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminJobManagementScreen extends StatefulWidget {
  const AdminJobManagementScreen({super.key});

  @override
  _AdminJobManagementScreenState createState() => _AdminJobManagementScreenState();
}

class _AdminJobManagementScreenState extends State<AdminJobManagementScreen> with SingleTickerProviderStateMixin {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  Future<void> _approveJob(String companyId, String jobId) async {
    await _firestore.collection('companies').doc(companyId).collection('jobs').doc(jobId).update({'approved': true});
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("✅ Job approved")));
  }

  Future<void> _rejectJob(String companyId, String jobId) async {
    await _firestore.collection('companies').doc(companyId).collection('jobs').doc(jobId).delete();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("❌ Job rejected and removed")));
  }

  Future<void> _flagJob(String companyId, String jobId) async {
    await _firestore.collection('companies').doc(companyId).collection('jobs').doc(jobId).update({'flagged': true});
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("⚠️ Job has been flagged")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: const Text('Admin: Job Management'),
        backgroundColor: Colors.deepPurple,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Pending'),
            Tab(text: 'Approved'),
            Tab(text: 'Flagged'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildJobList(filter: 'pending'),
          _buildJobList(filter: 'approved'),
          _buildJobList(filter: 'flagged'),
        ],
      ),
    );
  }

  Widget _buildJobList({required String filter}) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('companies').snapshots(),
      builder: (context, companySnapshot) {
        if (companySnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!companySnapshot.hasData || companySnapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No companies found"));
        }

        final companies = companySnapshot.data!.docs;

        return ListView(
          padding: const EdgeInsets.all(12),
          children: companies.map((company) {
            return StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('companies').doc(company.id).collection('jobs').snapshots(),
              builder: (context, jobSnapshot) {
                if (!jobSnapshot.hasData || jobSnapshot.data!.docs.isEmpty) return const SizedBox();

                final filteredJobs = jobSnapshot.data!.docs.where((job) {
                  final approved = job['approved'] == true;
                  final flagged = job['flagged'] == true;

                  switch (filter) {
                    case 'approved':
                      return approved;
                    case 'pending':
                      return !approved;
                    case 'flagged':
                      return flagged;
                    default:
                      return true;
                  }
                }).toList();

                if (filteredJobs.isEmpty) return const SizedBox();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                      child: Text(company['name'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    ...filteredJobs.map((job) {
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 3,
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12),
                          title: Text(job['title'], style: const TextStyle(fontWeight: FontWeight.w600)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 5),
                              Text(job['description']),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                children: [
                                  Chip(
                                    label: Text(job['approved'] == true ? 'Approved' : 'Pending'),
                                    backgroundColor: job['approved'] == true
                                        ? Colors.green.shade100
                                        : Colors.grey.shade300,
                                    labelStyle: TextStyle(
                                      color: job['approved'] == true ? Colors.green : Colors.black87,
                                    ),
                                  ),
                                  if (job['flagged'] == true)
                                    const Chip(
                                      label: Text("Flagged", style: TextStyle(color: Colors.orange)),
                                      backgroundColor: Color(0xFFFFE0B2),
                                    ),
                                ],
                              )
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (job['approved'] != true)
                                IconButton(
                                  icon: const Icon(Icons.check_circle, color: Colors.green),
                                  onPressed: () => _approveJob(company.id, job.id),
                                ),
                              IconButton(
                                icon: const Icon(Icons.cancel, color: Colors.red),
                                onPressed: () => _rejectJob(company.id, job.id),
                              ),
                              IconButton(
                                icon: const Icon(Icons.flag, color: Colors.orange),
                                onPressed: () => _flagJob(company.id, job.id),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                );
              },
            );
          }).toList(),
        );
      },
    );
  }
}
