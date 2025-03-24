// import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'CompanyDashboard.dart';


// class CompanyHomepage extends StatefulWidget {
//   const CompanyHomepage({super.key});

//   @override
//   _CompanyHomepageState createState() => _CompanyHomepageState();
// }

// class _CompanyHomepageState extends State<CompanyHomepage> {
//   int _selectedIndex = 0;
//   String? companyName;
//   String? companyEmail;
//   String? companyPhone;
//   String? profileImageUrl;

//   @override
//   void initState() {
//     super.initState();
//     _fetchCompanyData();
//   }

//   Future<void> _fetchCompanyData() async {
//     User? user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       DocumentSnapshot companyDoc =
//           await FirebaseFirestore.instance.collection('companies').doc(user.uid).get();
//       if (companyDoc.exists) {
//         setState(() {
//           companyName = companyDoc['name'] ?? 'Company';
//           companyEmail = companyDoc['email'] ?? 'No Email';
//           companyPhone = companyDoc['phone'] ?? 'N/A';
//           profileImageUrl = companyDoc['profileImageUrl'] ?? "";
//         });
//       }
//     }
//   }

//   Future<void> _logout() async {
//     await FirebaseAuth.instance.signOut();
//     Navigator.pushReplacementNamed(context, '/login');
//   }

//   void _goToProfile() {
//     Navigator.pushNamed(context, '/CompanyProfile');
//   }

//   final List<Widget> _pages = [
//     CompanyDashboard(),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: Text("This is my company", style: const TextStyle(color: Colors.white)),
//         backgroundColor: Colors.deepPurple,
//         actions: [
//           IconButton(icon: const Icon(Icons.account_circle, color: Colors.white), onPressed: _goToProfile),
//           IconButton(icon: const Icon(Icons.logout, color: Colors.white), onPressed: _logout),
//         ],
//       ),
//       body: _pages[_selectedIndex],
//       bottomNavigationBar: FlashyTabBar(
//         animationCurve: Curves.easeInOut,
//         selectedIndex: _selectedIndex,
//         iconSize: 28,
//         showElevation: true,
//         onItemSelected: (index) => setState(() {
//           _selectedIndex = index;
//         }),
//         items: [
//           FlashyTabBarItem(icon: const Icon(Icons.dashboard), title: const Text('Dashboard')),
//           FlashyTabBarItem(icon: const Icon(Icons.work), title: const Text('Jobs')),
//           FlashyTabBarItem(icon: const Icon(Icons.people), title: const Text('Candidates')),
//           FlashyTabBarItem(icon: const Icon(Icons.notifications), title: const Text('Notifications')),
//         ],
//       ),
//     );
//   }
// }
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Companydashboard.dart';
import 'company_jobs.dart';

class CompanyHomepage extends StatefulWidget {
  const CompanyHomepage({super.key});

  @override
  _CompanyHomepageState createState() => _CompanyHomepageState();
}

class _CompanyHomepageState extends State<CompanyHomepage> {
  int _selectedIndex = 0; // Default to Dashboard tab

  String? companyName;
  String? companyEmail;
  String? companyPhone;
  String? profileImageUrl;

  @override
  void initState() {
    super.initState();
    _fetchCompanyData();
  }

  /// **Fetch Company Data from Firestore**
  Future<void> _fetchCompanyData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot companyDoc = await FirebaseFirestore.instance.collection('companies').doc(user.uid).get();
      if (companyDoc.exists) {
        setState(() {
          companyName = companyDoc['name'] ?? 'Company';
          companyEmail = companyDoc['email'] ?? 'No Email';
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

  /// **Screens for the Bottom Navigation Bar**
  final List<Widget> _screens = [
    Companydashboard(),
    CompanyJobsPage(),
    
    
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Welcome, ${companyName ?? 'Company'}", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(icon: Icon(Icons.account_circle, color: Colors.white), onPressed: _goToProfile),
          IconButton(icon: Icon(Icons.logout, color: Colors.white), onPressed: _logout),
        ],
      ),

      /// **Using `IndexedStack` to keep state when switching tabs**
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),

      /// **Bottom Navigation Bar**
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
          FlashyTabBarItem(icon: Icon(Icons.account_circle), title: Text('Profile')),
        ],
      ),
    );
  }
}
