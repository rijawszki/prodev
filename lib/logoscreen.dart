import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:prodev/login.dart';

class Logoscreen extends StatefulWidget {
  const Logoscreen ({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<Logoscreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      // Check if user is logged in
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        Navigator.pushReplacementNamed(context, '/splashscreen');
      } else {
        Navigator.pushReplacementNamed(context, '/splashscreen');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white  ,
      body: Center(
        child: Lottie.asset(
          'assets/Animation - 1741585506474.json', // Place JSON in assets folder
          width: 200,
          height: 200,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
