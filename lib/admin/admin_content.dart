import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminContentManagementScreen extends StatefulWidget {
  const AdminContentManagementScreen({super.key});

  @override
  _AdminContentManagementScreenState createState() => _AdminContentManagementScreenState();
}

class _AdminContentManagementScreenState extends State<AdminContentManagementScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _addContent(String category, String title, String description) async {
    await _firestore.collection('content').add({
      'category': category,
      'title': title,
      'description': description,
      'timestamp': FieldValue.serverTimestamp(),
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Content added successfully")),
    );
  }

  Future<void> _editContent(String contentId, String newTitle, String newDescription) async {
    await _firestore.collection('content').doc(contentId).update({
      'title': newTitle,
      'description': newDescription,
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Content updated successfully")),
    );
  }

  Future<void> _deleteContent(String contentId) async {
    await _firestore.collection('content').doc(contentId).delete();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Content deleted")),
    );
  }

  void _showEditDialog(String contentId, String title, String description) {
    TextEditingController titleController = TextEditingController(text: title);
    TextEditingController descriptionController = TextEditingController(text: description);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Edit Content"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleController, decoration: InputDecoration(labelText: "Title")),
            TextField(controller: descriptionController, decoration: InputDecoration(labelText: "Description")),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
          TextButton(
            onPressed: () {
              _editContent(contentId, titleController.text, descriptionController.text);
              Navigator.pop(context);
            },
            child: Text("Save"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin: Content Management'),
        backgroundColor: Colors.deepPurple,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          TextEditingController categoryController = TextEditingController();
          TextEditingController titleController = TextEditingController();
          TextEditingController descriptionController = TextEditingController();

          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text("Add Content"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(controller: categoryController, decoration: InputDecoration(labelText: "Category")),
                  TextField(controller: titleController, decoration: InputDecoration(labelText: "Title")),
                  TextField(controller: descriptionController, decoration: InputDecoration(labelText: "Description")),
                ],
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
                TextButton(
                  onPressed: () {
                    _addContent(categoryController.text, titleController.text, descriptionController.text);
                    Navigator.pop(context);
                  },
                  child: Text("Add"),
                ),
              ],
            ),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.deepPurple,
      ),
      body: StreamBuilder(
        stream: _firestore.collection('content').orderBy('timestamp', descending: true).snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No content available"));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var content = snapshot.data!.docs[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text(content['title']),
                  subtitle: Text("Category: ${content['category']}\n${content['description']}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _showEditDialog(content.id, content['title'], content['description']),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteContent(content.id),
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
