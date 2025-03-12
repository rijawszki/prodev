import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// **Welcome Message**
            Text("Welcome to Your Dashboard",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
            SizedBox(height: 10),
            Text("Explore your opportunities below!",
                style: TextStyle(fontSize: 16, color: Colors.grey[600])),

            SizedBox(height: 20),

            /// **Navigation Cards**
            _buildFeatureTile(
                context: context, icon: Icons.school, title: "IELTS Preparation", route: "/IeltsPage"),
            _buildFeatureTile(context: context, icon: Icons.work, title: "Find Jobs", route: "/JobsPages"),
            _buildFeatureTile(context: context, icon: Icons.videogame_asset, title: "Play Games", route:"/GamesPage"),
          ],
        ),
      ),
    );
  }

  /// **Reusable Feature Tile Widget**
  Widget _buildFeatureTile(
      {required BuildContext context, required IconData icon, required String title, required String route}) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(icon, size: 30, color: Colors.deepPurple),
        title: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        trailing: Icon(Icons.arrow_forward_ios, size: 18),
        onTap: () {
          Navigator.pushNamed(context, route);
        },
      ),
    );
  }
}
