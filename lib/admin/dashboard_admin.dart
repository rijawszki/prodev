import 'package:flutter/material.dart';
import 'package:prodev/admin/admin_company.dart';
import 'package:prodev/admin/admin_content.dart';
import 'package:prodev/admin/admin_jobmanagement.dart';
import 'package:prodev/admin/admin_user.dart';
import 'admin_company.dart';
import 'admin_content.dart';
import 'admin_jobmanagement.dart';
import 'admin_content.dart';

class AdminDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2, // Two widgets per row
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildDashboardCard(context, "Users", Icons.people, Colors.blue, AdminUserManagementScreen()),
            _buildDashboardCard(context, "Companies", Icons.business, Colors.green, AdminCompanyManagementScreen()),
            _buildDashboardCard(context, "Jobs", Icons.work, Colors.orange, AdminJobManagementScreen()),
            _buildDashboardCard(context, "Content", Icons.article, Colors.purple, AdminContentManagementScreen()),
          ],
        ),
      ),
    );
  }

  /// **Reusable Dashboard Card**
  Widget _buildDashboardCard(BuildContext context, String title, IconData icon, Color color, Widget page) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: color, width: 2),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6, spreadRadius: 1)],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: color),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
