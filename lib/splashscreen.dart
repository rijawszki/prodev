
// import 'package:flutter/material.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white, // Dark background
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // App Logo (Optional)
//             Image.asset(
//               'assets/Screenshot 2025-03-10 121816.png', // Add your logo here
//               height: 100,
//               width: 100,
//             ),
//             SizedBox(height: 20),

//             // App Title
//             Text(
//               "Welcome to Our App",
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
//             ),
//             SizedBox(height: 30),

//             // Login Button
//             _buildNavigationButton(
//               context,
//               title: "Login",
//               icon: Icons.login,
//               routeName: '/login',
//             ),
//             SizedBox(height: 20),

//             // User Registration Button (Navigates to /register_user)
//             _buildNavigationButton(
//               context,
//               title: "User Registration",
//               icon: Icons.person_add,
//               routeName: '/RegistrationUser',
//             ),
//             SizedBox(height: 20),

//             // Company Registration Button (Navigates to /register_company)
//             _buildNavigationButton(
//               context,
//               title: "Company Registration",
//               icon: Icons.business,
//               routeName: '/CompanyRegistration',
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   /// **Reusable Button for Navigation**
//   Widget _buildNavigationButton(BuildContext context,
//       {required String title, required IconData icon, required String routeName}) {
//     return ElevatedButton.icon(
//       onPressed: () {
//         Navigator.pushNamed(context, routeName);
//       },
//       icon: Icon(icon, size: 24, color: Colors.white),
//       label: Text(title, style: TextStyle(fontSize: 18, color: Colors.white)),
//       style: ElevatedButton.styleFrom(
//         backgroundColor: Colors.deepPurple,
//         padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // App Logo at the Top
          Image.asset(
            'assets/Screenshot 2025-03-10 121816.png', // Replace with your logo path
            height: 200,
            width: 300,
          ),
          SizedBox(height: 20),

          // Grid of Options
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2, // Two items per row
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildNavigationCard(context, "Login", Icons.login, '/login'),
                _buildNavigationCard(context, "User Registration", Icons.person_add, '/RegistrationUser'),
                _buildNavigationCard(context, "Company Registration", Icons.business, '/CompanyRegistration'),
                _buildNavigationCard(context, "admin login", Icons.admin_panel_settings, '/login'),

              ],
            ),
          ),
        ],
      ),
    );
  }

  /// **Reusable Navigation Card**
  Widget _buildNavigationCard(BuildContext context, String title, IconData icon, String route) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.deepPurple,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.deepPurple),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
