import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  bool _animate = true;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  /// **Fetch User Data from Firestore**
  Future<void> _fetchUserData() async {
    User? user = _auth.currentUser;

    if (user != null) {
      try {
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(user.uid).get();

        if (userDoc.exists && userDoc.data() != null) {
          Map<String, dynamic> data =
              userDoc.data() as Map<String, dynamic>;

          setState(() {
            _name = data['name'] ?? "Unknown User";
            _email = data['email'] ?? "No Email";
            _bio = data['bio'] ?? "No bio available";
            _profileImageUrl = data['profileImageUrl'] ?? "";
            _age = data['age'] ?? 0;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : Stack(
              children: [
                // **Background Gradient**
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.purple, Colors.deepPurpleAccent],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),

                // **Profile UI**
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // **Glowing Avatar**
                    AvatarGlow(
                      animate: _animate,
                      glowColor: Colors.white,
                      duration: const Duration(milliseconds: 2000),
                      child: CircleAvatar(
                        backgroundColor: Colors.grey[300],
                        radius: 60,
                        backgroundImage: _profileImageUrl.isNotEmpty
                            ? NetworkImage(_profileImageUrl)
                            : null,
                        child: _profileImageUrl.isEmpty
                            ? const Icon(Icons.person, size: 60, color: Colors.white)
                            : null,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // **User Name**
                    Text(
                      _name,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    // **User Bio**
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        _bio,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // **Email**
                    Text(
                      _email,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white60,
                      ),
                    ),

                    // **Age**
                    Text(
                      "Age: $_age",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white60,
                      ),
                    ),

                    const SizedBox(height: 30),

                    // **Action Buttons**
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // **Toggle Glow Button**
                        ElevatedButton.icon(
                          onPressed: () {
                            setState(() => _animate = !_animate);
                          },
                          icon: Icon(
                            _animate ? Icons.pause_circle : Icons.play_circle,
                            color: Colors.white,
                          ),
                          label: Text(
                            _animate ? "Stop Glow" : "Start Glow",
                            style: const TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurpleAccent,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                          ),
                        ),

                        const SizedBox(width: 15),

                        // **Logout Button**
                        ElevatedButton.icon(
                          onPressed: () async {
                            await _auth.signOut();
                            Navigator.pushReplacementNamed(context, '/login');
                          },
                          icon: const Icon(Icons.logout, color: Colors.white),
                          label: const Text(
                            "Logout",
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
