import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'chat_screen.dart'; // Make sure this points to your company chat screen

class CompanyChatListScreen extends StatelessWidget {
  const CompanyChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return const Scaffold(
        body: Center(child: Text("You are not logged in.")),
      );
    }

    final companyId = currentUser.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Candidate Chats"),
        backgroundColor: Colors.deepPurple,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('chats')
            .where('participants', arrayContains: companyId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final chatDocs = snapshot.data!.docs;

          if (chatDocs.isEmpty) {
            return const Center(child: Text("No chats yet."));
          }

          return ListView.builder(
            itemCount: chatDocs.length,
            itemBuilder: (context, index) {
              final chat = chatDocs[index];
              final data = chat.data() as Map<String, dynamic>;

              final lastMessage = data['lastMessage'] ?? '';
              final unreadBy = data['unreadBy'] ?? [];
              final participants = List<String>.from(data['participants'] ?? []);

              // Get applicantId by excluding the companyId from participants
              final applicantId = participants.firstWhere(
                (id) => id != companyId,
                orElse: () => '',
              );

              final applicantName = data['applicantName'] ?? 'Candidate';
              final hasUnread = unreadBy.contains(companyId);

              if (applicantId.isEmpty) {
                return const ListTile(
                  title: Text("Unknown candidate"),
                  subtitle: Text("Missing applicant ID."),
                );
              }

              return ListTile(
                title: Text(applicantName),
                subtitle: Text(
                  lastMessage,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: hasUnread
                    ? const CircleAvatar(
                        radius: 8,
                        backgroundColor: Colors.red,
                        child: Text(" ", style: TextStyle(fontSize: 0)),
                      )
                    : null,
                onTap: () async {
                  // Clear unread for this company
                  await FirebaseFirestore.instance.collection('chats').doc(chat.id).update({
                    'unreadBy': FieldValue.arrayRemove([companyId]),
                  });

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChatScreen(
                        chatPartnerName: applicantName,
                        receiverId: applicantId,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
