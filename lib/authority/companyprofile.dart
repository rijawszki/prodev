import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CompanyProfile extends StatefulWidget {
  const CompanyProfile({super.key});

  @override
  _CompanyProfileState createState() => _CompanyProfileState();
}

class _CompanyProfileState extends State<CompanyProfile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _companyName = "Company Name";
  String _email = "company@example.com";
  String _industry = "Industry Type";
  String _logoUrl = "";
  bool _animate = true;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCompanyData();
  }

  /// **Fetch Company Data from Firestore**
  Future<void> _fetchCompanyData() async {
    User? user = _auth.currentUser;

    if (user != null) {
      try {
        DocumentSnapshot companyDoc =
            await _firestore.collection('company').doc(user.uid).get();

        if (companyDoc.exists && companyDoc.data() != null) {
          Map<String, dynamic> data =
              companyDoc.data() as Map<String, dynamic>;

          setState(() {
            _companyName = data['name'] ?? "Unknown Company";
            _email = data['email'] ?? "No Email";
            _industry = data['industry'] ?? "No industry specified";
            _logoUrl = data['logoUrl'] ?? "";
            _isLoading = false;
          });
        }
      } catch (e) {
        print("Error fetching company data: $e");
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
                        backgroundImage: _logoUrl.isNotEmpty
                            ? NetworkImage(_logoUrl)
                            : null,
                        child: _logoUrl.isEmpty
                            ? const Icon(Icons.business, size: 60, color: Colors.white)
                            : null,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // **Company Name**
                    Text(
                      _companyName,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    // **Industry Type**
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        _industry,
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
