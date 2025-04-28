import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CompanyJobsPage extends StatefulWidget {
  const CompanyJobsPage({super.key});

  @override
  _CompanyJobsPageState createState() => _CompanyJobsPageState();
}

class _CompanyJobsPageState extends State<CompanyJobsPage> {
  final TextEditingController _jobTitleController = TextEditingController();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _salaryMinController = TextEditingController();
  final TextEditingController _salaryMaxController = TextEditingController();
  final TextEditingController _jobDescriptionController = TextEditingController();
  final TextEditingController _benefitsController = TextEditingController();

  final TextEditingController _skillController = TextEditingController();
  final TextEditingController _educationController = TextEditingController();
  final TextEditingController _languageController = TextEditingController();

  final List<String> _skills = [];
  final List<String> _educations = [];
  final List<String> _languages = [];

  String _experience = 'Fresher';
  String _jobType = 'Full-time';
  String _shiftType = 'Day Shift';

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final List<String> _experienceOptions = ['Fresher', '1 year', '2 years', '3 years', '4 years', '5 years'];
  final List<String> _jobTypes = ['Full-time', 'Part-time', 'Internship', 'Freelance'];
  final List<String> _shiftTypes = ['Day Shift', 'Night Shift', 'Flexible','Remote'];

  Future<void> _postJob() async {
  User? user = _auth.currentUser;
  if (user != null) {
    if (_jobTitleController.text.trim().isEmpty ||
        _companyNameController.text.trim().isEmpty ||
        _locationController.text.trim().isEmpty ||
        _salaryMinController.text.trim().isEmpty ||
        _salaryMaxController.text.trim().isEmpty ||
        _jobDescriptionController.text.trim().isEmpty ||
        _skills.isEmpty ||
        _educations.isEmpty ||
        _languages.isEmpty ||
        _benefitsController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("All fields are required!")),
      );
      return;
    }

    await _firestore.collection('jobs').add({
      'companyId': user.uid,
      'companyName': _companyNameController.text.trim(),
      'jobTitle': _jobTitleController.text.trim(),
      'location': _locationController.text.trim(),
      'jobType': _jobType,
      'shiftType': _shiftType,
      'salaryRange': '${_salaryMinController.text.trim()} - ${_salaryMaxController.text.trim()}',
      'description': _jobDescriptionController.text.trim(),
      'benefits': _benefitsController.text.trim(),
      'skills': _skills,
      'education': _educations,
      'languages': _languages,
      'experience': _experience,
      'createdAt': FieldValue.serverTimestamp(),
      'approved': false,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Job Posted Successfully!")),
    );

    _clearFields();
  }
}


  void _clearFields() {
    _jobTitleController.clear();
    _companyNameController.clear();
    _locationController.clear();
    _salaryMinController.clear();
    _salaryMaxController.clear();
    _jobDescriptionController.clear();
    _benefitsController.clear();
    _skills.clear();
    _educations.clear();
    _languages.clear();
    _experience = 'Fresher';
    _jobType = 'Full-time';
    _shiftType = 'Day Shift';
    setState(() {});
  }

  void _addItem(String type) {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController controller;
        String label;
        if (type == 'Skills') {
          controller = _skillController;
          label = "Add Skill";
        } else if (type == 'Education') {
          controller = _educationController;
          label = "Add Education";
        } else {
          controller = _languageController;
          label = "Add Language";
        }
        return AlertDialog(
          title: Text(label),
          content: TextField(controller: controller, decoration: InputDecoration(hintText: label)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                controller.clear();
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  setState(() {
                    if (type == 'Skills') {
                      _skills.add(controller.text);
                    } else if (type == 'Education') {
                      _educations.add(controller.text);
                    } else {
                      _languages.add(controller.text);
                    }
                  });
                }
                controller.clear();
                Navigator.pop(context);
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Insights
            const Text("Profile Insights", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            _buildChipsSection("Skills", _skills, () => _addItem('Skills')),
            _buildChipsSection("Education", _educations, () => _addItem('Education')),
            _buildChipsSection("Languages", _languages, () => _addItem('Languages')),

            const SizedBox(height: 10),
            DropdownButtonFormField(
              value: _experience,
              items: _experienceOptions.map((exp) {
                return DropdownMenuItem(value: exp, child: Text(exp));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _experience = value!;
                });
              },
              decoration: const InputDecoration(labelText: "Experience Required"),
            ),

            const SizedBox(height: 20),
            // Job Details
            const Text("Job Details", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            TextField(controller: _jobTitleController, decoration: const InputDecoration(labelText: "Job Title")),
            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _salaryMinController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: "Min Salary (₹)"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _salaryMaxController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: "Max Salary (₹)"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            DropdownButtonFormField(
              value: _jobType,
              items: _jobTypes.map((type) {
                return DropdownMenuItem(value: type, child: Text(type));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _jobType = value!;
                });
              },
              decoration: const InputDecoration(labelText: "Job Type"),
            ),
            const SizedBox(height: 10),

            DropdownButtonFormField(
              value: _shiftType,
              items: _shiftTypes.map((shift) {
                return DropdownMenuItem(value: shift, child: Text(shift));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _shiftType = value!;
                });
              },
              decoration: const InputDecoration(labelText: "Shift and Schedule"),
            ),

            const SizedBox(height: 20),
            // Location
            const Text("Location", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            TextField(controller: _locationController, decoration: const InputDecoration(labelText: "Location")),

            const SizedBox(height: 20),
            // Benefits
            const Text("Benefits", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            TextField(controller: _benefitsController, decoration: const InputDecoration(labelText: "Benefits")),

            const SizedBox(height: 20),
            // Full Job Description
            const Text("Full Job Description", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            TextField(
              controller: _jobDescriptionController,
              maxLines: 6,
              decoration: const InputDecoration(labelText: "Job Description"),
            ),

            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: _postJob,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text("Post Job"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChipsSection(String title, List<String> items, VoidCallback onAdd) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            IconButton(onPressed: onAdd, icon: const Icon(Icons.add_circle, color: Colors.deepPurple)),
          ],
        ),
        Wrap(
          spacing: 8,
          children: items.map((item) => Chip(label: Text(item))).toList(),
        ),
      ],
    );
  }
}
