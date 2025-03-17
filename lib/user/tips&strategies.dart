import 'package:flutter/material.dart';

class TipsPage extends StatelessWidget {
  const TipsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tips & Strategies"), backgroundColor: Colors.deepPurple),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildTipSection(
              "Listening Tips",
              [
                "Read the instructions carefully before each section.",
                "Listen for keywords and synonyms, not exact words.",
                "Stay focused; answers usually appear in order.",
              ],
            ),
            _buildTipSection(
              "Reading Tips",
              [
                "Skim the passage before reading questions.",
                "Focus on headings and keywords.",
                "Don’t spend too much time on one question.",
              ],
            ),
            _buildTipSection(
              "Writing Tips",
              [
                "Plan your essay before writing.",
                "Use a clear introduction, body, and conclusion.",
                "Avoid repeating the same words; use synonyms.",
              ],
            ),
            _buildTipSection(
              "Speaking Tips",
              [
                "Speak naturally and confidently.",
                "Expand your answers instead of giving short responses.",
                "Don’t memorize answers; be spontaneous.",
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// **Reusable Expandable Tip Section**
  Widget _buildTipSection(String title, List<String> tips) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ExpansionTile(
        leading: const Icon(Icons.lightbulb, color: Colors.deepPurple),
        title: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        children: tips.map((tip) => ListTile(title: Text("• $tip"))).toList(),
      ),
    );
  }
}
