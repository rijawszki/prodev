import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Register User
  Future<String?> registerUser({
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      // Store user details in Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': email.trim(),
        'phone': phone.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      return null; // No error, registration successful
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "email-already-in-use":
          return "Email is already registered.";
        case "weak-password":
          return "Password is too weak.";
        case "invalid-email":
          return "Invalid email format.";
        case "network-request-failed":
          return "Network error! Check your internet connection.";
        default:
          return "Registration failed. Please try again.";
      }
    }
  }
}
