
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   bool _isLoading = false;
//   bool _obscurePassword = true;

//   /// **Login Function (Checks Role & Navigates)**
//   Future<void> _login() async {
//     if (!_formKey.currentState!.validate()) return;

//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       UserCredential userCredential = await _auth.signInWithEmailAndPassword(
//         email: _emailController.text.trim(),
//         password: _passwordController.text.trim(),
//       );

//       // Get user role from Firestore
//       String role = await _getUserRole(userCredential.user!.uid);

//       // Navigate based on role
//       if (role == 'user') {
//         Navigator.pushReplacementNamed(context, '/userHomepage');
//       } else if (role == 'Company') {
//         Navigator.pushReplacementNamed(context, '/companyhomepage');
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Invalid user role! Contact support.')),
//         );
//       }
//     } on FirebaseAuthException catch (e) {
//       String errorMessage = 'Login failed. Please try again.';

//       if (e.code == "user-not-found") {
//         errorMessage = "No user found for this email.";
//       } else if (e.code == "wrong-password") {
//         errorMessage = "Incorrect password.";
//       } else if (e.code == "invalid-email") {
//         errorMessage = "Invalid email format.";
//       }

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(errorMessage)),
//       );
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   /// **Retrieve User Role from Firestore**
//   Future<String> _getUserRole(String uid) async {
//     // Check in "users" collection first
//     DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
//     if (userDoc.exists) return userDoc['role'];

//     // Check in "companies" collection
//     DocumentSnapshot companyDoc = await FirebaseFirestore.instance.collection('company').doc(uid).get();
//     if (companyDoc.exists) return companyDoc['role'];

//     return 'unknown'; // Default if role not found
//   }

//   /// **Forgot Password Function**
//   void _resetPassword() {
//     if (_emailController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Enter your email to reset password')),
//       );
//       return;
//     }

//     _auth.sendPasswordResetEmail(email: _emailController.text.trim()).then((_) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Password reset link sent to your email')),
//       );
//     }).catchError((error) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error: ${error.message}')),
//       );
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: Text('Login', style: TextStyle(color: Colors.white)),
//         backgroundColor: Colors.white,
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Center(
//           child: SingleChildScrollView(
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text("Email", style: TextStyle(color: Colors.white, fontSize: 16)),
//                   SizedBox(height: 5),
//                   TextFormField(
//                     controller: _emailController,
//                     decoration: InputDecoration(
//                       filled: true,
//                       fillColor: Colors.deepPurple[800],
//                       labelText: 'Enter Email',
//                       labelStyle: TextStyle(color: Colors.white70),
//                       border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//                     ),
//                     keyboardType: TextInputType.emailAddress,
//                     style: TextStyle(color: Colors.deepPurple),
//                     validator: (value) => value!.contains('@') ? null : "Enter a valid email",
//                   ),
//                   SizedBox(height: 15),

//                   Text("Password", style: TextStyle(color: Colors.white, fontSize: 16)),
//                   SizedBox(height: 5),
//                   TextFormField(
//                     controller: _passwordController,
//                     decoration: InputDecoration(
//                       filled: true,
//                       fillColor: Colors.deepPurple[800],
//                       labelText: 'Enter Password',
//                       labelStyle: TextStyle(color: Colors.white70),
//                       border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//                       suffixIcon: IconButton(
//                         icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, color: Colors.white70),
//                         onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
//                       ),
//                     ),
//                     obscureText: _obscurePassword,
//                     style: TextStyle(color: Colors.white),
//                     validator: (value) => value!.length >= 6 ? null : "Password must be at least 6 characters",
//                   ),
//                   SizedBox(height: 20),

//                   Align(
//                     alignment: Alignment.centerRight,
//                     child: TextButton(
//                       onPressed: _resetPassword,
//                       child: Text('Forgot Password?', style: TextStyle(color: Colors.purple)),
//                     ),
//                   ),
//                   SizedBox(height: 10),

//                   Center(
//                     child: _isLoading
//                         ? CircularProgressIndicator(color: Colors.purple)
//                         : ElevatedButton(
//                             onPressed: _login,
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.deepPurple,
//                               padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
//                               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                             ),
//                             child: Text('Login', style: TextStyle(fontSize: 18, color: Colors.white)),
//                           ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
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

    setState(() {
      _isLoading = true;
    });

    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    try {
      if (email == adminEmail && password == adminPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Admin login successful")),
        );
        Navigator.pushReplacementNamed(context, '/AdminDashboard');
        return;
      }

      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      String role = await _getUserRole(userCredential.user!.uid);

      if (role == 'user') {
        Navigator.pushReplacementNamed(context, '/userHomepage');
      } else if (role == 'Company') {
        Navigator.pushReplacementNamed(context, '/companyhomepage');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid user role! Contact support.')),
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Login failed. Please try again.';

      if (e.code == "user-not-found") {
        errorMessage = "No user found for this email.";
      } else if (e.code == "wrong-password") {
        errorMessage = "Incorrect password.";
      } else if (e.code == "invalid-email") {
        errorMessage = "Invalid email format.";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<String> _getUserRole(String uid) async {
    DocumentSnapshot userDoc = await _firestore.collection('users').doc(uid).get();
    if (userDoc.exists) return userDoc['role'];

    DocumentSnapshot companyDoc = await _firestore.collection('companies').doc(uid).get();
    if (companyDoc.exists) return companyDoc['role'];

    return 'unknown';
  }

  void _resetPassword() {
    if (_emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Enter your email to reset password')),
      );
      return;
    }

    _auth.sendPasswordResetEmail(email: _emailController.text.trim()).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password reset link sent to your email')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${error.message}')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Login', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Email", style: TextStyle(color: Colors.black, fontSize: 16)),
                  SizedBox(height: 5),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[200],
                      labelText: 'Enter Email',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) => value!.contains('@') ? null : "Enter a valid email",
                  ),
                  SizedBox(height: 15),

                  Text("Password", style: TextStyle(color: Colors.black, fontSize: 16)),
                  SizedBox(height: 5),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[200],
                      labelText: 'Enter Password',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                    ),
                    obscureText: _obscurePassword,
                    validator: (value) => value!.length >= 6 ? null : "Password must be at least 6 characters",
                  ),
                  SizedBox(height: 20),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: _resetPassword,
                      child: Text('Forgot Password?', style: TextStyle(color: Colors.purple)),
                    ),
                  ),
                  SizedBox(height: 10),

                  Center(
                    child: _isLoading
                        ? CircularProgressIndicator(color: Colors.purple)
                        : ElevatedButton(
                            onPressed: _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            child: Text('Login', style: TextStyle(fontSize: 18, color: Colors.white)),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
