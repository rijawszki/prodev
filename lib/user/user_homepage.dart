import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prodev/user/jobsearch.dart';
import 'package:prodev/user/userchatlistscreen.dart';
import 'ielts.dart';
import 'jobs.dart';
import 'companychat.dart';
import 'userhome.dart';
import 'notification.dart';

class UserHomepage extends StatefulWidget {
  const UserHomepage({super.key});

  @override
  _UserHomepageState createState() => _UserHomepageState();
}

class _UserHomepageState extends State<UserHomepage> {
  int _selectedIndex = 0;

  String? userName;
  String? profileImageUrl;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        setState(() {
          userName = userDoc['name'] ?? 'User';
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

  final List<Widget> _screens = [
    HomeScreen(),
    IeltsPage(),
    JobsPage(),
    UserChatListScreen(),
    JobSearchScreen(),
  ];

  // Define a list of pages where you want to show the floating button
  final List<int> _pagesWithChatbot = [0, 1]; // Show on Home, Chat, and Job Search

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      /// Drawer added here
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(userName ?? 'User'),
              accountEmail: null,
              currentAccountPicture: CircleAvatar(
                backgroundImage: profileImageUrl != null && profileImageUrl!.isNotEmpty
                    ? NetworkImage(profileImageUrl!)
                    : null,
                child: profileImageUrl == null || profileImageUrl!.isEmpty
                    ? Icon(Icons.person, size: 40)
                    : null,
              ),
              decoration: BoxDecoration(color: Colors.deepPurple),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile'),
              onTap: () {
                Navigator.pop(context);
                _goToProfile();
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                Navigator.pop(context);
                _logout();
              },
            ),
          ],
        ),
      ),

      appBar: AppBar(
        title: Text("Welcome, ${userName ?? 'User'}", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,

        /// Move profile icon to the left
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.account_circle, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),

      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),

      bottomNavigationBar: FlashyTabBar(
        animationCurve: Curves.linear,
        selectedIndex: _selectedIndex,
        iconSize: 30,
        showElevation: false,
        onItemSelected: (index) => setState(() {
          _selectedIndex = index;
        }),
        items: [
          FlashyTabBarItem(icon: Icon(Icons.home), title: Text('Home')),
          FlashyTabBarItem(icon: Icon(Icons.school), title: Text('IELTS')),
          FlashyTabBarItem(icon: Icon(Icons.work), title: Text('Jobs')),
          FlashyTabBarItem(icon: Icon(Icons.chat_bubble_outline_outlined), title: Text('chat')),
          FlashyTabBarItem(icon: Icon(Icons.search_rounded), title: Text('job search')),
        ],
      ),

      floatingActionButton: FloatingActionButton(onPressed: (){Navigator.pushNamed(context, '/aichatbot');},child: Icon(Icons.messenger),)
    );
  }
}
 