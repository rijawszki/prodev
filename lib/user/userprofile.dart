import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Colors from registration page
const kPrimaryColor = Color(0xFF4B0082);
const kAccentColor = Color(0xFF6A5ACD);
const kBackgroundColor = Color(0xFFF9F9FC);
const kTextPrimary = Color(0xFF1F1F1F);
const kTextSecondary = Color(0xFF6C6C6C);

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _name = "User Name";
  String _email = "user@example.com";
  String _bio = "Flutter Developer | Tech Enthusiast";
  String _profileImageUrl = "";
  int _age = 0;
  String _address = "";
  String _dob = "";
  String _skills = "";
  String _languages = "";
  String _qualification = "";
  bool _animate = true;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    User? user = _auth.currentUser;

    if (user != null) {
      try {
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(user.uid).get();

        if (userDoc.exists && userDoc.data() != null) {
          Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;

          setState(() {
            _name = data['name'] ?? "Unknown User";
            _email = data['email'] ?? "No Email";
            _bio = data['bio'] ?? "No bio available";
            _profileImageUrl = data['profileImageUrl'] ?? "";
            _age = data['age'] ?? 0;
            _address = data['address'] ?? "";
            _dob = data['dob'] ?? "";
            _skills = data['skills'] ?? "";
            _languages = data['languages'] ?? "";
            _qualification = data['qualification'] ?? "";
            _isLoading = false;
          });
        }
      } catch (e) {
        print("Error fetching user data: $e");
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      child: Row(
        children: [
          Icon(icon, color: kAccentColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "$label: ",
              style: const TextStyle(
                color: kTextPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              value,
              style: const TextStyle(color: kTextSecondary, fontSize: 15),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard(String title, List<Widget> children) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: kPrimaryColor,
                )),
            const Divider(thickness: 1, color: kAccentColor),
            const SizedBox(height: 8),
            ...children
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: kPrimaryColor))
          : SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    CircleAvatar(
                      backgroundColor: Colors.grey[300],
                      radius: 60,
                      backgroundImage: _profileImageUrl.isNotEmpty
                          ? NetworkImage(_profileImageUrl)
                          : null,
                      child: _profileImageUrl.isEmpty
                          ? const Icon(Icons.person,
                              size: 60, color: Colors.white)
                          : null,
                    ),
                    const SizedBox(height: 10),
                    Text(_name,
                        style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: kTextPrimary)),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 8),
                      child: Text(_bio,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 16,
                              color: kTextSecondary,
                              fontStyle: FontStyle.italic)),
                    ),
                    Text(_email,
                        style: const TextStyle(
                            color: kTextSecondary, fontSize: 14)),
                    const SizedBox(height: 20),

                    // Personal Info Section
                    _buildSectionCard("Personal Info", [
                      _buildInfoTile(Icons.calendar_today, "Age", _age.toString()),
                      _buildInfoTile(Icons.cake, "DOB", _dob),
                      _buildInfoTile(Icons.home, "Address", _address),
                    ]),

                    // Professional Info Section
                    _buildSectionCard("Professional Info", [
                      _buildInfoTile(Icons.school, "Qualification", _qualification),
                      _buildInfoTile(Icons.build, "Skills", _skills),
                      _buildInfoTile(Icons.language, "Languages", _languages),
                    ]),

                    const SizedBox(height: 20),

                    // Only Logout Button
                    ElevatedButton.icon(
                      onPressed: () async {
                        await _auth.signOut();
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      icon: const Icon(Icons.logout, color: Colors.white),
                      label: const Text("Logout",
                          style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
    );
  }
}
