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
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         title: Text('Login', style: TextStyle(color: Colors.white)),
//         backgroundColor: Colors.black,
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Center(
//           child: SingleChildScrollView(
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 children: [
//                   // Email Field
//                   TextFormField(
//                     controller: _emailController,
//                     decoration: InputDecoration(labelText: 'Email'),
//                     keyboardType: TextInputType.emailAddress,
//                     validator: (value) => value!.contains('@') ? null : "Enter a valid email",
//                   ),
//                   SizedBox(height: 10),

//                   // Password Field
//                   TextFormField(
//                     controller: _passwordController,
//                     decoration: InputDecoration(
//                       labelText: 'Password',
//                       suffixIcon: IconButton(
//                         icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
//                         onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
//                       ),
//                     ),
//                     obscureText: _obscurePassword,
//                     validator: (value) => value!.length >= 6 ? null : "Password must be at least 6 characters",
//                   ),
//                   SizedBox(height: 20),

//                   // Forgot Password
//                   Align(
//                     alignment: Alignment.centerRight,
//                     child: TextButton(
//                       onPressed: _resetPassword,
//                       child: Text('Forgot Password?'),
//                     ),
//                   ),
//                   SizedBox(height: 10),

//                   // Login Button
//                   _isLoading
//                       ? CircularProgressIndicator()
//                       : ElevatedButton(
//                           onPressed: _login,
//                           child: Text('Login'),
//                         ),
//                   SizedBox(height: 20),

//                   // Register Options
//                   Column(
//                     children: [
//                       Text("Don't have an account?"),
//                       TextButton(
//                         onPressed: () {
//                           Navigator.pushNamed(context, '/registration_user');
//                         },
//                         child: Text("Register as User"),
//                       ),
//                       TextButton(
//                         onPressed: () {
//                           Navigator.pushNamed(context, '/company_registration');
//                         },
//                         child: Text("Register as Company"),
//                       ),
//                     ],
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
  bool _isLoading = false;
  bool _obscurePassword = true;

  /// **Login Function (Checks Role & Navigates)**
  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Get user role from Firestore
      String role = await _getUserRole(userCredential.user!.uid);

      // Navigate based on role
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

  /// **Retrieve User Role from Firestore**
  Future<String> _getUserRole(String uid) async {
    // Check in "users" collection first
    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (userDoc.exists) return userDoc['role'];

    // Check in "companies" collection
    DocumentSnapshot companyDoc = await FirebaseFirestore.instance.collection('company').doc(uid).get();
    if (companyDoc.exists) return companyDoc['role'];

    return 'unknown'; // Default if role not found
  }

  /// **Forgot Password Function**
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
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Login', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // Email Field
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) => value!.contains('@') ? null : "Enter a valid email",
                  ),
                  SizedBox(height: 10),

                  // Password Field
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                    ),
                    obscureText: _obscurePassword,
                    validator: (value) => value!.length >= 6 ? null : "Password must be at least 6 characters",
                  ),
                  SizedBox(height: 20),

                  // Forgot Password
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: _resetPassword,
                      child: Text('Forgot Password?'),
                    ),
                  ),
                  SizedBox(height: 10),

                  // Login Button
                  _isLoading
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: _login,
                          child: Text('Login'),
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
