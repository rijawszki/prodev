import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminUserManagementScreen extends StatefulWidget {
  const AdminUserManagementScreen({super.key});

  @override
  _AdminUserManagementScreenState createState() =>
      _AdminUserManagementScreenState();
}

class _AdminUserManagementScreenState
    extends State<AdminUserManagementScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _deleteUser(String userId) async {
    final confirmation = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this user?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete')),
        ],
      ),
    );

    if (confirmation == true) {
      await _firestore.collection('users').doc(userId).delete();
      _showSnackbar("User deleted successfully");
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.deepPurple),
    );
  }
void _showUserDetails(Map<String, dynamic> userData) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Profile image
              CircleAvatar(
                radius: 45,
                backgroundImage: userData['profileImageUrl'] != null && userData['profileImageUrl'] != ''
                    ? NetworkImage(userData['profileImageUrl'])
                    : null,
                backgroundColor: Colors.deepPurple.shade100,
                child: userData['profileImageUrl'] == null || userData['profileImageUrl'] == ''
                    ? Icon(Icons.person, size: 40, color: Colors.deepPurple)
                    : null,
              ),
              const SizedBox(height: 16),
              Text(
                userData['name'] ?? 'No Name',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(height: 4),
              Text(userData['email'] ?? 'No Email', style: const TextStyle(color: Colors.grey)),

              const SizedBox(height: 20),
              _detailRow("Age", userData['age']?.toString()),
              _detailRow("Date of Birth", userData['dob']),
              _detailRow("Address", userData['address']),
              _detailRow("Bio", userData['bio']),
              _detailRow("Skills", userData['skills']),
              _detailRow("Languages", userData['languages']),
              _detailRow("Qualification", userData['qualification']),
              _detailRow("Role", userData['role']),
            ],
          ),
        ),
      );
    },
  );
}

Widget _detailRow(String title, String? value) {
  return value != null && value.isNotEmpty
      ? Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("$title: ",
                  style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black87)),
              Expanded(child: Text(value, style: const TextStyle(color: Colors.black87))),
            ],
          ),
        )
      : const SizedBox.shrink();
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade50,
      appBar: AppBar(
        title: const Text('User Management'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 4,
      ),
      body: StreamBuilder(
        stream: _firestore.collection('users').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No users found"));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: snapshot.data!.docs.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              var user = snapshot.data!.docs[index];
              var data = user.data() as Map<String, dynamic>;

              return GestureDetector(
                onTap: () => _showUserDetails(data),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.deepPurple.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    leading: CircleAvatar(
                      backgroundColor: Colors.deepPurple.shade100,
                      backgroundImage: data['profileImageUrl'] != null
                          ? NetworkImage(data['profileImageUrl'])
                          : null,
                      child: data['profileImageUrl'] == null
                          ? Icon(Icons.person, color: Colors.deepPurple)
                          : null,
                    ),
                    title: Text(
                      data['email'] ?? 'No Email',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    subtitle: Text("Role: ${data['role'] ?? 'Unknown'}"),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                      tooltip: "Delete User",
                      onPressed: () => _deleteUser(user.id),
                    ),
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
