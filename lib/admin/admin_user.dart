import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminUserManagementScreen extends StatefulWidget {
  const AdminUserManagementScreen({super.key});

  @override
  _AdminUserManagementScreenState createState() => _AdminUserManagementScreenState();
}

class _AdminUserManagementScreenState extends State<AdminUserManagementScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _editUserRole(String userId, String newRole) async {
    await _firestore.collection('users').doc(userId).update({'role': newRole});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("User role updated successfully")),
    );
  }

  Future<void> _deactivateUser(String userId) async {
    await _firestore.collection('users').doc(userId).update({'active': false});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("User deactivated successfully")),
    );
  }

  Future<void> _banUser(String userId) async {
    await _firestore.collection('users').doc(userId).update({'banned': true});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("User has been banned")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin: User Management'),
        backgroundColor: Colors.deepPurple,
      ),
      body: StreamBuilder(
        stream: _firestore.collection('users').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No users found"));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var user = snapshot.data!.docs[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text(user['email']),
                  subtitle: Text("Role: ${user['role']}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          _editUserRole(user.id, 'user');
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.block, color: Colors.orange),
                        onPressed: () => _deactivateUser(user.id),
                      ),
                      IconButton(
                        icon: Icon(Icons.cancel, color: Colors.red),
                        onPressed: () => _banUser(user.id),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
