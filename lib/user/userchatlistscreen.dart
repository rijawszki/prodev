import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'companychat.dart'; // Ensure this points to your chat screen

class UserChatListScreen extends StatelessWidget {
  const UserChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return const Scaffold(
        body: Center(child: Text("You are not logged in.")),
      );
    }

    final userId = currentUser.uid;

    return Scaffold( 
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('chats')
            .where('participants', arrayContains: userId)
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
              final chatData = chat.data() as Map<String, dynamic>;

              final companyName = chatData['companyName'] ?? "Company";
              final lastMessage = chatData['lastMessage'] ?? "";
              final companyId = chatData['companyId'];
              final unreadBy = chatData['unreadBy'] ?? [];
 
 
              final hasUnread = unreadBy.contains(userId);

              return ListTile(
                title: Text(companyName),
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
                  // Mark messages as read
                  await FirebaseFirestore.instance.collection('chats').doc(chat.id).update({
                    'unreadBy': FieldValue.arrayRemove([userId]),
                  });

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => UserChatScreen(
                        companyId: companyId,
                        companyName: companyName,
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
