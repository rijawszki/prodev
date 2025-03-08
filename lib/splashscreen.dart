import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Dark background
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo (Optional)
            Image.asset(
              'assets/logo.png', // Add your logo here
              height: 100,
              width: 100,
            ),
            SizedBox(height: 20),

            // App Title
            Text(
              "Welcome to Our App",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 30),

            // Login Button
            _buildNavigationButton(
              context,
              title: "Login",
              icon: Icons.login,
              routeName: '/login',
            ),
            SizedBox(height: 20),

            // User Registration Button (Navigates to `/register_user`)
            _buildNavigationButton(
              context,
              title: "User Registration",
              icon: Icons.person_add,
              routeName: '/RegistrationUser',
            ),
            SizedBox(height: 20),

            // Company Registration Button (Navigates to `/register_company`)
            _buildNavigationButton(
              context,
              title: "Company Registration",
              icon: Icons.business,
              routeName: '/CompanyRegistration',
            ),
          ],
        ),
      ),
    );
  }

  /// **Reusable Button for Navigation**
  Widget _buildNavigationButton(BuildContext context,
      {required String title, required IconData icon, required String routeName}) {
    return ElevatedButton.icon(
      onPressed: () {
        Navigator.pushNamed(context, routeName);
      },
      icon: Icon(icon, size: 24, color: Colors.white),
      label: Text(title, style: TextStyle(fontSize: 18, color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepPurple,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
