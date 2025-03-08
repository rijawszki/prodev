import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserHomepage extends StatefulWidget {
  @override
  _UserHomepageState createState() => _UserHomepageState();
}

class _UserHomepageState extends State<UserHomepage> {
  String? userName;
  String? userEmail;
  String? userPhone;
  String? userAge;
  String? userRole;
  String? profileImageUrl;
  bool _isLoading = true;

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
          userPhone = userDoc['phone'] ?? 'N/A';
          userAge = userDoc['age'].toString();
          userRole = userDoc['role'] ?? 'User';
          profileImageUrl = userDoc['profileImageUrl'] ?? "";
          _isLoading = false;
        });
      }
    }
  }

  /// **Logout Function**
  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/login'); // Navigate back to login screen
  }

  /// **Navigate to Profile Screen**
  void _goToProfile() {
    Navigator.pushNamed(context, '/profile');
  }

  /// **Navigate to Settings Screen**
  void _goToSettings() {
    Navigator.pushNamed(context, '/settings');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Dark Theme
      appBar: AppBar(
        title: Text("User Dashboard", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle, color: Colors.white),
            onPressed: _goToProfile,
          ),
          IconButton(
            icon: Icon(Icons.settings, color: Colors.white),
            onPressed: _goToSettings,
          ),
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: _logout,
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // **Profile Picture**
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: profileImageUrl != ""
                        ? NetworkImage(profileImageUrl!)
                        : AssetImage("assets/default_avatar.png") as ImageProvider,
                  ),
                  SizedBox(height: 10),

                  // **User Name**
                  Text(
                    userName!,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  Text(
                    "Role: $userRole",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  SizedBox(height: 20),

                  // **User Details Card**
                  Card(
                    color: Colors.grey[900],
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoRow(Icons.email, "Email", userEmail),
                          _buildInfoRow(Icons.phone, "Phone", userPhone),
                          _buildInfoRow(Icons.cake, "Age", userAge),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  // **Logout Button**
                  ElevatedButton.icon(
                    onPressed: _logout,
                    icon: Icon(Icons.exit_to_app, color: Colors.white),
                    label: Text("Logout", style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  /// **Reusable Row Widget for Displaying User Info**
  Widget _buildInfoRow(IconData icon, String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.deepPurpleAccent),
          SizedBox(width: 10),
          Text("$label: ", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(value ?? 'N/A', style: TextStyle(color: Colors.white70, fontSize: 16)),
          ),
        ],
      ),
    );
  }
}
