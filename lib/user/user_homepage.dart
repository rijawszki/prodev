
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'userProfile.dart';


class UserHomepage extends StatefulWidget {
  const UserHomepage({super.key});

  @override
  _UserHomepageState createState() => _UserHomepageState();
}

class _UserHomepageState extends State<UserHomepage> {
  int _selectedIndex = 0; // Default to Home tab
  String? userName;
  String? userEmail;
  String? userAge;
  String? userRole;
  String? profileImageUrl;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  /// **Fetch User Data from Firestore**
  Future<void> _fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        setState(() {
          userName = userDoc['name'] ?? 'No Name';
          userEmail = userDoc['email'];
          userAge = userDoc['age'].toString();
          userRole = userDoc['role'] ?? 'User';
          profileImageUrl = userDoc['profileImageUrl'] ?? "";
        });
      }
    }
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _goToProfile() {
    Navigator.pushNamed(context, '/UserProfile');
  }

  List<Widget> _tabItems() => [
        Center(child: Text("home", style: TextStyle(color: Colors.white))),
        Center(child: Text("IELTS", style: TextStyle(color: Colors.white))),
        Center(child: Text("Jobs", style: TextStyle(color: Colors.white))),
        Center(child: Text("Games", style: TextStyle(color: Colors.white))),
        Center(child: Text("Notifications", style: TextStyle(color: Colors.white)))
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Welcome, ${userName ?? 'User'}", style: TextStyle(color: Colors.white)),
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
          FlashyTabBarItem(icon: Icon(Icons.home), title: Text('home')),
          FlashyTabBarItem(icon: Icon(Icons.school), title: Text('IELTS')),
          FlashyTabBarItem(icon: Icon(Icons.work), title: Text('Jobs')),
          FlashyTabBarItem(icon: Icon(Icons.videogame_asset), title: Text('Games')),
          FlashyTabBarItem(icon: Icon(Icons.notifications), title: Text('Notifications')),
        ],
      ),
    );
  }
}
