import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // Store user data in Firestore
        await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
          'email': _emailController.text.trim(),
          'phone': _phoneController.text.trim(),
          'createdAt': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Registration Successful!")),
        );
        Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        String errorMessage;
        switch (e.code) {
          case "email-already-in-use":
            errorMessage = "Email is already registered.";
            break;
          case "weak-password":
            errorMessage = "Password is too weak.";
            break;
          case "invalid-email":
            errorMessage = "Invalid email format.";
            break;
          default:
            errorMessage = "Registration failed. Please try again.";
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Register", style: TextStyle(fontWeight: FontWeight.bold))),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Create Your Account", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
              SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: "Email", border: OutlineInputBorder()),
                validator: (value) => (value == null || !value.contains('@'))
                    ? "Enter a valid email"
                    : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: "Phone Number", border: OutlineInputBorder()),
                keyboardType: TextInputType.phone,
                validator: (value) => (value == null || value.length < 10)
                    ? "Enter a valid phone number"
                    : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: "Password", border: OutlineInputBorder()),
                obscureText: true,
                validator: (value) => (value == null || value.length < 6)
                    ? "Password must be at least 6 characters"
                    : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(labelText: "Confirm Password", border: OutlineInputBorder()),
                obscureText: true,
                validator: (value) => (value != _passwordController.text)
                    ? "Passwords do not match"
                    : null,
              ),
              SizedBox(height: 20),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _register,
                        child: Text("Register"),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
