import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminContentPage extends StatefulWidget {
  @override
  _AdminContentPageState createState() => _AdminContentPageState();
}

class _AdminContentPageState extends State<AdminContentPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController previewController = TextEditingController();

  String selectedModule = 'Listening';

  final List<String> modules = ['All', 'Listening', 'Reading', 'Writing', 'Speaking'];

  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  Future<void> uploadContent() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      try {
        List<String> targetModules = selectedModule == 'All'
            ? ['Listening', 'Reading', 'Writing', 'Speaking']
            : [selectedModule];

        for (String module in targetModules) {
          await FirebaseFirestore.instance.collection('resources').add({
            'module': module,
            'title': titleController.text.trim(),
            'preview': previewController.text.trim(),
            'timestamp': FieldValue.serverTimestamp(),
          });
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Content uploaded successfully!')),
        );

        titleController.clear();
        previewController.clear();
        setState(() {
          selectedModule = 'Listening';
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error uploading content: $e')),
        );
      }

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Upload Content'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<String>(
                value: selectedModule,
                decoration: InputDecoration(labelText: 'Select Module'),
                items: modules.map((module) {
                  return DropdownMenuItem<String>(
                    value: module,
                    child: Text(module),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedModule = value!;
                  });
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter a title' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: previewController,
                maxLines: 4,
                decoration: InputDecoration(labelText: 'Preview Text'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Enter preview text'
                    : null,
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: isLoading ? null : uploadContent,
                child: isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text('Upload'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
