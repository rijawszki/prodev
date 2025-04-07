
// import 'package:flutter/material.dart';

// class Companydashboard extends StatelessWidget {
//   const Companydashboard({super.key}); 

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // **Dashboard Heading**
//           const Text(
//             "Company Dashboard",
//             style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.deepPurple),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             "Manage your company operations efficiently.",
//             style: TextStyle(fontSize: 16, color: Colors.grey[600]),
//           ),
//           const SizedBox(height: 20),

//           // **Company Stats Section**
//           _buildStatsCard("Total Employees", "245", Icons.people),
//           _buildStatsCard("Active Projects", "12", Icons.business_center),
//           _buildStatsCard("Pending Approvals", "5", Icons.pending_actions),

//           const SizedBox(height: 20),

//           // **Navigation Section**
//           const Text("Quick Actions", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//           const SizedBox(height: 10),

//           _buildFeatureTile(context, Icons.group, "Manage Employees", "/employees"),
//           _buildFeatureTile(context, Icons.assessment, "View Reports", "/reports"),
//           _buildFeatureTile(context, Icons.settings, "Company Settings", "/settings"),
//           _buildFeatureTile(context, Icons.account_circle, "Company Profile", "/profile"),

//           const SizedBox(height: 20),

//           // **Notifications Section**
//           const Text("Recent Notifications", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//           const SizedBox(height: 10),
//           _buildNotificationTile("New job application received."),
//           _buildNotificationTile("Reminder: Submit monthly reports."),
//           _buildNotificationTile("Server maintenance scheduled for Sunday."),
//         ],
//       ),
//     );
//   }

//   /// **Company Stats Widget**
//   Widget _buildStatsCard(String title, String value, IconData icon) {
//     return Card(
//       color: Colors.deepPurple.withOpacity(0.1),
//       elevation: 3,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       child: ListTile(
//         leading: Icon(icon, size: 32, color: Colors.deepPurple),
//         title: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//         trailing: Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
//       ),
//     );
//   }

//   /// **Reusable Feature Tile Widget**
//   Widget _buildFeatureTile(BuildContext context, IconData icon, String title, String route) {
//     return Card(
//       elevation: 3,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       margin: const EdgeInsets.symmetric(vertical: 6),
//       child: ListTile(
//         leading: Icon(icon, size: 30, color: Colors.deepPurple),
//         title: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
//         trailing: const Icon(Icons.arrow_forward_ios, size: 18),
//         onTap: () {
//           Navigator.pushNamed(context, route);
//         },
//       ),
//     );
//   }

//   /// **Notifications Tile**
//   Widget _buildNotificationTile(String message) {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//       margin: const EdgeInsets.symmetric(vertical: 4),
//       child: ListTile(
//         leading: const Icon(Icons.notifications, color: Colors.deepPurple),
//         title: Text(message, style: const TextStyle(fontSize: 16)),
//         trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'company_candidates.dart';

class Companydashboard extends StatefulWidget {
  const Companydashboard({super.key});

  @override
  _CompanyDashboardState createState() => _CompanyDashboardState();
}

class _CompanyDashboardState extends State<Companydashboard> {
  String? companyName;
  String? companyIndustry;
  String? companyWebsite;
  String? companyEmail;
  String? companyPhone;

  @override
  void initState() {
    super.initState();
    _fetchCompanyData();
  }

  Future<void> _fetchCompanyData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot companyDoc =
          await FirebaseFirestore.instance.collection('companies').doc(user.uid).get();
      if (companyDoc.exists) {
        setState(() {
          companyName = companyDoc['name'] ?? 'Companies';
          companyIndustry = companyDoc['industry'] ?? 'Not Specified';
          companyWebsite = companyDoc['website'] ?? 'N/A';
          companyEmail = companyDoc['email'] ?? 'No Email';
          companyPhone = companyDoc['phone'] ?? 'N/A';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Dashboard", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
          const SizedBox(height: 10),
          _buildCompanyInfo(),
          const SizedBox(height: 20),
          _buildFeatureTile(Icons.work, "Manage Job Listings", "/company_jobs"),
          _buildFeatureTile(Icons.people, "View Candidates", "/CandidatesPage"),
          _buildFeatureTile(Icons.notifications, "Recent Notifications", "/company_notifications"),
          _buildFeatureTile(Icons.settings, "Company Settings", "/company_settings"),
        ],
      ),
    );
  }

  Widget _buildCompanyInfo() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(companyName ?? "Company Name", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text("Industry: ${companyIndustry ?? "Not Specified"}", style: TextStyle(fontSize: 16, color: Colors.grey[600])),
            Text("Website: ${companyWebsite ?? "N/A"}", style: TextStyle(fontSize: 16, color: Colors.grey[600])),
            Text("Email: ${companyEmail ?? "No Email"}", style: TextStyle(fontSize: 16, color: Colors.grey[600])),
            Text("Phone: ${companyPhone ?? "N/A"}", style: TextStyle(fontSize: 16, color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureTile(IconData icon, String title, String route) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: Icon(icon, size: 30, color: Colors.deepPurple),
        title: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 18),
        onTap: () {
          Navigator.pushNamed(context, route);
        },
      ),
    );
  }
}
