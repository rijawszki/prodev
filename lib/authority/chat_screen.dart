// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class ChatScreen extends StatefulWidget {
//   final String chatPartnerName;
//   final String receiverId; // Receiver user ID

//   const ChatScreen({
//     super.key,
//     required this.chatPartnerName,
//     required this.receiverId,
//   });

//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   final _auth = FirebaseAuth.instance;
//   final _firestore = FirebaseFirestore.instance;
//   final TextEditingController _controller = TextEditingController();
//   final ScrollController _scrollController = ScrollController();

//   late final String _currentUserId;
//   late final String _chatId;

//   @override
//   void initState() {
//     super.initState();
//     _currentUserId = _auth.currentUser!.uid;
//     _chatId = _getChatId(_currentUserId, widget.receiverId);
//   }

//   String _getChatId(String user1, String user2) {
//     return user1.hashCode <= user2.hashCode
//         ? '$user1\_$user2'
//         : '$user2\_$user1';
//   }

//   void _sendMessage() async {
//   final message = _controller.text.trim();
//   if (message.isEmpty) return;

//   final timestamp = FieldValue.serverTimestamp();

//   // Save message to subcollection
//   await _firestore.collection('chats').doc(_chatId).collection('messages').add({
//     'senderId': _currentUserId,
//     'receiverId': widget.receiverId,
//     'message': message,
//     'timestamp': timestamp,
//   });

//   // Update or create the parent chat document
//   await _firestore.collection('chats').doc(_chatId).set({
//     'participants': [_currentUserId, widget.receiverId],
//     'lastMessage': message,
//     'lastUpdated': Timestamp.now(),
//     'companyId': _currentUserId,
//     'companyName': _auth.currentUser!.displayName ?? 'Company',
//   }, SetOptions(merge: true)); // Merge so it doesn't overwrite existing fields

//   _controller.clear();

//   _scrollController.animateTo(
//     _scrollController.position.maxScrollExtent + 100,
//     duration: const Duration(milliseconds: 300),
//     curve: Curves.easeOut,
//   );
// }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Chat with ${widget.chatPartnerName}'),
//         backgroundColor: Colors.deepPurple,
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: StreamBuilder<QuerySnapshot>(
//               stream: _firestore
//                   .collection('chats')
//                   .doc(_chatId)
//                   .collection('messages')
//                   .orderBy('timestamp')
//                   .snapshots(),
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

//                 var messages = snapshot.data!.docs;

//                 return ListView.builder(
//                   controller: _scrollController,
//                   itemCount: messages.length,
//                   itemBuilder: (context, index) {
//                     var data = messages[index].data() as Map<String, dynamic>;
//                     bool isMe = data['senderId'] == _currentUserId;

//                     return Align(
//                       alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
//                         margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
//                         decoration: BoxDecoration(
//                           color: isMe ? Colors.deepPurple[100] : Colors.grey[300],
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Text(data['message']),
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _controller,
//                     decoration: const InputDecoration(
//                       hintText: "Type your message...",
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 ElevatedButton(
//                   onPressed: _sendMessage,
//                   style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
//                   child: const Icon(Icons.send),
//                 )
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
 
 import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatScreen extends StatefulWidget {
  final String chatPartnerName;
  final String receiverId;

  const ChatScreen({
    super.key,
    required this.chatPartnerName,
    required this.receiverId,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late final String _currentUserId;
  late final String _chatId;

  @override
  void initState() {
    super.initState();
    _currentUserId = _auth.currentUser!.uid;
    _chatId = _getChatId(_currentUserId, widget.receiverId);
  }

  String _getChatId(String user1, String user2) {
    return user1.hashCode <= user2.hashCode
        ? '${user1}_$user2'
        : '${user2}_$user1';
  }

  void _sendMessage() async {
    final message = _controller.text.trim();
    if (message.isEmpty) return;

    final currentUserName = _auth.currentUser?.displayName ?? 'Company';

    final chatRef = _firestore.collection('chats').doc(_chatId);

    // Store message
    await chatRef.collection('messages').add({
      'senderId': _currentUserId,
      'receiverId': widget.receiverId,
      'message': message,
      'timestamp': FieldValue.serverTimestamp(),
    });

    // Update metadata for company
    await chatRef.set({
      'lastMessage': message,
      'lastUpdated': FieldValue.serverTimestamp(),
      'participants': [_currentUserId, widget.receiverId],
      'unreadBy': [widget.receiverId],
      'companyId': _currentUserId,
      'companyName': currentUserName,
      'applicantId': widget.receiverId,
      'applicantName': widget.chatPartnerName,
    }, SetOptions(merge: true));

    _controller.clear();

    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with ${widget.chatPartnerName}'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('chats')
                  .doc(_chatId)
                  .collection('messages')
                  .orderBy('timestamp')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data!.docs;

                return ListView.builder(
                  controller: _scrollController,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final data = messages[index].data() as Map<String, dynamic>;
                    final isMe = data['senderId'] == _currentUserId;

                    return Align(
                      alignment:
                          isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color:
                              isMe ? Colors.deepPurple[100] : Colors.grey[300],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(data['message'] ?? ''),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: "Type your message...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _sendMessage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                  ),
                  child: const Icon(Icons.send),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
 