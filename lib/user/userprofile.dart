import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfile> {
  String? userName;
  String? userEmail;
  String? userPhone;
  String? userAge;
  String? profileImageUrl;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  /// **Fetch User Profile from Firestore**
  Future<void> _fetchUserProfile() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

      if (userDoc.exists) {
        setState(() {
          userName = userDoc['name'] ?? 'No Name';
          userEmail = userDoc['email'];
          userPhone = userDoc['phone'] ?? 'N/A';
          userAge = userDoc['age'].toString();
          profileImageUrl = userDoc['profileImageUrl'] ?? "";
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Dark Theme
      appBar: AppBar(
        title: Text("Profile", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
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
                    radius: 60,
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
