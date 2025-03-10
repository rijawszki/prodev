import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CompanyHomepage extends StatefulWidget {
  const CompanyHomepage({super.key});

  @override
  _CompanyHomepageState createState() => _CompanyHomepageState();
}

class _CompanyHomepageState extends State<CompanyHomepage> {
  int _selectedIndex = 0;
  String? companyName;
  String? companyEmail;
  String? companyPhone;
  String? profileImageUrl;

  @override
  void initState() {
    super.initState();
    _fetchCompanyData();
  }

  Future<void> _fetchCompanyData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot companyDoc = await FirebaseFirestore.instance.collection('companies').doc(user.uid).get();
      if (companyDoc.exists) {
        setState(() {
          companyName = companyDoc['name'] ?? 'Company';
          companyEmail = companyDoc['email'];
          companyPhone = companyDoc['phone'] ?? 'N/A';
          profileImageUrl = companyDoc['profileImageUrl'] ?? "";
        });
      }
    }
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _goToProfile() {
    Navigator.pushNamed(context, '/CompanyProfile');
  }

  List<Widget> _tabItems() => [
        Center(child: Text("Dashboard", style: TextStyle(color: Colors.white))),
        Center(child: Text("Job Listings", style: TextStyle(color: Colors.white))),
        Center(child: Text("Candidates", style: TextStyle(color: Colors.white))),
        Center(child: Text("Notifications", style: TextStyle(color: Colors.white))),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Welcome, ${companyName ?? 'Company'}", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(icon: Icon(Icons.account_circle, color: Colors.white), onPressed: _goToProfile),
          IconButton(icon: Icon(Icons.logout, color: Colors.white), onPressed: _logout),
        ],
      ),
      body: _tabItems()[_selectedIndex],
      bottomNavigationBar: FlashyTabBar(
        animationCurve: Curves.linear,
        selectedIndex: _selectedIndex,
        iconSize: 30,
        showElevation: false,
        onItemSelected: (index) => setState(() {
          _selectedIndex = index;
        }),
        items: [
          FlashyTabBarItem(icon: Icon(Icons.dashboard), title: Text('Dashboard')),
          FlashyTabBarItem(icon: Icon(Icons.work), title: Text('Jobs')),
          FlashyTabBarItem(icon: Icon(Icons.people), title: Text('Candidates')),
          FlashyTabBarItem(icon: Icon(Icons.notifications), title: Text('Notifications')),
        ],
      ),
    );
  }
}
