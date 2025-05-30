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
      setState(() => isLoading = true);

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
          const SnackBar(content: Text('✅ Content uploaded successfully!')),
        );

        titleController.clear();
        previewController.clear();
        setState(() => selectedModule = 'Listening');
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ Error: $e')),
        );
      }

      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('📚 Admin: Upload Content'),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            width: 600,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Upload Study Content",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: selectedModule,
                    decoration: const InputDecoration(
                      labelText: 'Select Module',
                      border: OutlineInputBorder(),
                    ),
                    items: modules.map((module) {
                      return DropdownMenuItem<String>(
                        value: module,
                        child: Text(module),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() => selectedModule = value!);
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.title),
                    ),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Please enter a title' : null,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: previewController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: 'Preview Text',
                      border: OutlineInputBorder(),
                      alignLabelWithHint: true,
                      prefixIcon: Icon(Icons.description),
                    ),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Please enter preview text' : null,
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(Icons.upload_file),
                      label: Text(isLoading ? "Uploading..." : "Upload"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        textStyle: const TextStyle(fontSize: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: isLoading ? null : uploadContent,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
