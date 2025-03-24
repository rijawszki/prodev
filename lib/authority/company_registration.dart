
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:typed_data';

class CompanyRegistration extends StatefulWidget {
  const CompanyRegistration({super.key});

  @override
  _CompanyRegistrationState createState() => _CompanyRegistrationState();
}

class _CompanyRegistrationState extends State<CompanyRegistration> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  File? _image;
  Uint8List? _webImage;
  bool _isUploading = false;
  String? _imageUrl;

  /// **Pick Image (Supports Web & Mobile)**
  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      if (kIsWeb) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _webImage = bytes;
          _image = null;
        });
      } else {
        setState(() {
          _image = File(pickedFile.path);
          _webImage = null;
        });
      }
    }
  }

  /// **Upload Image to Cloudinary**
  Future<String?> _uploadImageToCloudinary() async {
    setState(() {
      _isUploading = true;
    });

    try {
      const cloudinaryUrl = "https://api.cloudinary.com/v1_1/dvijd3hxi/image/upload";
      const uploadPreset = "profile_images";

      var request = http.MultipartRequest('POST', Uri.parse(cloudinaryUrl));
      request.fields['upload_preset'] = uploadPreset;

      if (!kIsWeb && _image != null) {
        request.files.add(await http.MultipartFile.fromPath('file', _image!.path));
      } else if (kIsWeb && _webImage != null) {
        request.files.add(http.MultipartFile.fromBytes('file', _webImage!,
            filename: 'profile.png'));
      } else {
        return null;
      }

      final response = await request.send();
      final responseData = await response.stream.bytesToString();
      final data = json.decode(responseData);

      if (response.statusCode == 200) {
        return data['secure_url'];
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Image upload failed!')),
        );
        return null;
      }
    } catch (e) {
      print("❌ Cloudinary Upload Error: $e");
      return null;
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  /// **Register User**
  void _registerUser() async {
    if (!_formKey.currentState!.validate()) return;

    if (_passwordController.text.trim() != _confirmPasswordController.text.trim()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Passwords do not match!')),
      );
      return;
    }

    if (_image == null && _webImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a profile image!')),
      );
      return;
    }

    try {
      String? imageUrl = await _uploadImageToCloudinary();

      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      User? user = userCredential.user;
      if (user != null) {
        await _firestore.collection('company').doc(user.uid).set({
          'name': _nameController.text.trim(),
          'email': _emailController.text.trim(),
          'phone': _phoneController.text.trim(),
          'age': int.parse(_ageController.text.trim()),
          'uid': user.uid,
          'profileImageUrl': imageUrl ?? '',
          'role': 'Company',
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration Successful!')),
        );

        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Colors.white,
      appBar: AppBar(
        title: Text('Company Registration', style: TextStyle(color: Colors.white)),
        backgroundColor:Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // Profile Image Picker
                  GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[800],
                      backgroundImage: _webImage != null
                          ? MemoryImage(_webImage!)
                          : _image != null
                              ? FileImage(_image!) as ImageProvider
                              : null,
                      child: (_image == null && _webImage == null)
                          ? Icon(Icons.camera_alt, color: Colors.white)
                          : null,
                    ),
                  ),
                  SizedBox(height: 10),

                  // Name
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Company Name'),
                    validator: (value) => value!.isEmpty ? 'Enter company name' : null,
                  ),
                  SizedBox(height: 10),

                  // Email
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) => !value!.contains('@') ? 'Enter valid email' : null,
                  ),
                  SizedBox(height: 10),

                  // Phone Number
                  TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(labelText: 'Phone Number'),
                    keyboardType: TextInputType.phone,
                    validator: (value) => value!.isEmpty ? 'Enter phone number' : null,
                  ),
                  SizedBox(height: 10),

                  // Age
                  TextFormField(
                    controller: _ageController,
                    decoration: InputDecoration(labelText: 'since'),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 10),

                  // Password
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    validator: (value) => value!.length < 6 ? 'Password must be 6+ chars' : null,
                  ),
                  SizedBox(height: 10),

                  // Confirm Password
                  TextFormField(
                    controller: _confirmPasswordController,
                    decoration: InputDecoration(labelText: 'Confirm Password'),
                    obscureText: true,
                    validator: (value) => value != _passwordController.text ? 'Passwords do not match' : null,
                  ),
                  SizedBox(height: 20),

                  _isUploading
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: _registerUser,
                          child: Text('Register'),
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
