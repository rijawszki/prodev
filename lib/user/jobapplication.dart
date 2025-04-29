import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class JobApplicationPage extends StatefulWidget {
  final String jobId;
  final String jobTitle;
  final String companyId;
  final String companyName;

  const JobApplicationPage({
    super.key,
    required this.jobId,
    required this.jobTitle,
    required this.companyId,
    required this.companyName,
  });

  @override
  _JobApplicationPageState createState() => _JobApplicationPageState();
}

class _JobApplicationPageState extends State<JobApplicationPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final _formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  final experienceController = TextEditingController();
  final cvController = TextEditingController();

  String relocate = 'Yes';

  Future<void> _submitApplication() async {
    if (!_formKey.currentState!.validate()) return;

    User? user = _auth.currentUser;
    if (user == null) return;

    try {
      var existing = await _firestore
          .collection('applications')
          .where('jobId', isEqualTo: widget.jobId)
          .where('applicantId', isEqualTo: user.uid)
          .get();

      if (existing.docs.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("You already applied for this job.")),
        );
        return;
      }

      await _firestore.collection('applications').add({
        'jobId': widget.jobId,
        'jobTitle': widget.jobTitle,
        'companyId': widget.companyId,
        'companyName': widget.companyName,
        'applicantId': user.uid,
        'applicantName': user.displayName ?? '${firstNameController.text} ${lastNameController.text}',
        'firstName': firstNameController.text,
        'lastName': lastNameController.text,
        'phone': phoneController.text,
        'email': emailController.text,
        'address': addressController.text,
        'relocate': relocate,
        'experience': experienceController.text,
        'cvUrl': cvController.text.isEmpty ? 'Not Provided' : cvController.text,
        'status': 'Pending',
        'appliedDate': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Application submitted successfully!")),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Apply to ${widget.companyName}"),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: firstNameController,
                decoration: const InputDecoration(labelText: "First Name"),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: lastNameController,
                decoration: const InputDecoration(labelText: "Last Name"),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: "Phone Number"),
                keyboardType: TextInputType.phone,
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: "Email"),
                keyboardType: TextInputType.emailAddress,
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: addressController,
                decoration: const InputDecoration(labelText: "Address"),
              ),
              DropdownButtonFormField<String>(
                value: relocate,
                decoration: const InputDecoration(labelText: "Willing to Relocate?"),
                items: ['Yes', 'No']
                    .map((val) => DropdownMenuItem(value: val, child: Text(val)))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    relocate = val!;
                  });
                },
              ),
              TextFormField(
                controller: experienceController,
                decoration: const InputDecoration(labelText: "Experience"),
              ),
              TextFormField(
                controller: cvController,
                decoration: const InputDecoration(labelText: "CV URL"),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _submitApplication,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text("Submit Application", style: TextStyle(fontSize: 18)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
