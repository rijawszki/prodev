import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final String adminEmail = "prodevadmin@gmail.com";
  final String adminPassword = "pochinki1234";

  bool _isLoading = false;
  bool _obscurePassword = true;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    try {
      if (email == adminEmail && password == adminPassword) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Admin login successful")));
        Navigator.pushReplacementNamed(context, '/AdminDashboard');
        return;
      }

      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      String role = await _getUserRole(userCredential.user!.uid);

      if (role == 'user') {
        Navigator.pushReplacementNamed(context, '/userHomepage');
      } else if (role == 'Company') {
        Navigator.pushReplacementNamed(context, '/companyhomepage');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Invalid user role! Contact support.')));
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = switch (e.code) {
        "user-not-found" => "No user found for this email.",
        "wrong-password" => "Incorrect password.",
        "invalid-email" => "Invalid email format.",
        _ => "Login failed. Please try again."
      };
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<String> _getUserRole(String uid) async {
    var userDoc = await _firestore.collection('users').doc(uid).get();
    if (userDoc.exists) return userDoc['role'];
    var companyDoc = await _firestore.collection('company').doc(uid).get();
    if (companyDoc.exists) return companyDoc['role'];
    return 'unknown';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade50,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 60),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [SizedBox(height: 113),
                Text("Welcome Back 👋", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                SizedBox(height: 13),
                Text("Login to continue", style: TextStyle(fontSize: 16, color: Colors.grey[600])),
                SizedBox(height: 33),

                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    prefixIcon: Icon(Icons.email_outlined),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Email is required";
                    if (!value.contains('@') || value.split('@').length != 2) return "Invalid email format";
                    return null;
                  },
                ),
                SizedBox(height: 23),

                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: "Password",
                    prefixIcon: Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (value) => value != null && value.length >= 6 ? null : "Password must be at least 6 characters",
                ),
                SizedBox(height: 13),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/forgotPassword'),
                    child: Text("Forgot Password?", style: TextStyle(color: Colors.deepPurple)),
                  ),
                ),
                SizedBox(height: 20),

                Center(
                  child: _isLoading
                      ? CircularProgressIndicator(color: Colors.deepPurple)
                      : SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                              padding: EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Text("Login", style: TextStyle(fontSize: 16, color: Colors.white)),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
