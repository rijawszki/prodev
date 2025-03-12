import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class GamesPage extends StatelessWidget {
  const GamesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(

        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "learn through fun games 🎮",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          // **Carousel of Trending Games**
          CarouselSlider(
            options: CarouselOptions(
              height: 150,
              autoPlay: true,
              enlargeCenterPage: true,
            ),
            items: [
              _buildGameImage('assets/game1.jpg'),
              _buildGameImage('assets/game2.jpg'),
              _buildGameImage('assets/game3.jpg'),
            ],
          ),

          const SizedBox(height: 20),

          const Text(
            "Popular Games",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          // **List of Popular Games**
          Expanded(
            child: ListView(
              children: [
                _buildGameTile("ielts master", Icons.sports_esports, context),
                _buildGameTile("Puzzle Challenge", Icons.extension, context),
                _buildGameTile("new words", Icons.directions_car, context),
                _buildGameTile("speak it", Icons.gamepad, context),
                _buildGameTile("Word Scramble", Icons.text_fields, context),
              ],
            ),
          ),

          // **Play Demo Game Button**
          Align(
            alignment: Alignment.center,
            child: ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Launching Demo Game...")),
                );
              },
              icon: const Icon(Icons.play_arrow),
              label: const Text("Play Demo Game"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// **Builds a single game image for the carousel**
  Widget _buildGameImage(String assetPath) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.asset(
        assetPath,
        fit: BoxFit.cover,
      ),
    );
  }

  /// **Creates a tile for game listings**
  Widget _buildGameTile(String gameTitle, IconData icon, BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(icon, color: Colors.deepPurple),
        title: Text(gameTitle, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Launching $gameTitle...")),
          );
        },
      ),
    );
  }
}
