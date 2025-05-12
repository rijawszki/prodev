
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:flutter/foundation.dart' show kIsWeb;
// import 'dart:typed_data';

// class RegistrationUser extends StatefulWidget {
//   const RegistrationUser({super.key});

//   @override
//   _RegisterScreenState createState() => _RegisterScreenState();
// }

// class _RegisterScreenState extends State<RegistrationUser> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _ageController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _confirmPasswordController = TextEditingController();
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   File? _image;
//   Uint8List? _webImage;
//   bool _isUploading = false;
//   bool _isPasswordVisible = false;
//   bool _isConfirmPasswordVisible = false;
//   String? _imageUrl;

//   /// **Pick Image (Supports Web & Mobile)**
//   Future<void> _pickImage() async {
//     final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

//     if (pickedFile != null) {
//       if (kIsWeb) {
//         final bytes = await pickedFile.readAsBytes();
//         setState(() {
//           _webImage = bytes;
//         });
//       } else {
//         setState(() {
//           _image = File(pickedFile.path);
//         });
//       }
//     }
//   }

//   /// **Upload Image to Cloudinary**
//   Future<String?> _uploadImageToCloudinary(File imageFile) async {
//     setState(() => _isUploading = true);

//     try {
//       const cloudinaryUrl = "https://api.cloudinary.com/v1_1/dvijd3hxi/image/upload";
//       const uploadPreset = "profile_images";

//       final request = http.MultipartRequest('POST', Uri.parse(cloudinaryUrl))
//         ..fields['upload_preset'] = uploadPreset
//         ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

//       final response = await request.send();
//       final responseData = await response.stream.bytesToString();
//       final data = json.decode(responseData);

//       return response.statusCode == 200 ? data['secure_url'] : null;
//     } catch (e) {
//       print("❌ Cloudinary Upload Error: $e");
//       return null;
//     } finally {
//       setState(() => _isUploading = false);
//     }
//   }

//   /// **Register User**
//   void _registerUser() async {
//     if (!_formKey.currentState!.validate()) return;

//     if (_passwordController.text.trim() != _confirmPasswordController.text.trim()) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Passwords do not match!')),
//       );
//       return;
//     }

//     if (_image == null && _webImage == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Please select a profile image!')),
//       );
//       return;
//     }

//     try {
//       String? imageUrl;
//       if (!kIsWeb && _image != null) {
//         imageUrl = await _uploadImageToCloudinary(_image!);
//       }

//       UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
//         email: _emailController.text.trim(),
//         password: _passwordController.text.trim(),
//       );

//       User? user = userCredential.user;
//       if (user != null) {
//         await _firestore.collection('users').doc(user.uid).set({
//           'name': _nameController.text.trim(),
//           'email': _emailController.text.trim(),
//           'age': int.parse(_ageController.text.trim()),
//           'uid': user.uid,
//           'profileImageUrl': imageUrl ?? '',
//           'role': 'user',
//         });

//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Registration Successful!')),
//         );

//         Navigator.pushReplacementNamed(context, '/login');
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error: $e')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: Text('User Registration', style: TextStyle(color: Colors.white)),
//         backgroundColor: Colors.white,
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Center(
//           child: SingleChildScrollView(
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 children: [
//                   // Profile Image Picker
//                   GestureDetector(
//                     onTap: _pickImage,
//                     child: CircleAvatar(
//                       radius: 50,
//                       backgroundColor: Colors.black,
//                       backgroundImage: _webImage != null
//                           ? MemoryImage(_webImage!)
//                           : _image != null
//                               ? FileImage(_image!) as ImageProvider
//                               : null,
//                       child: (_image == null && _webImage == null)
//                           ? Icon(Icons.camera_alt, color: Colors.white)
//                           : null,
//                     ),
//                   ),
//                   SizedBox(height: 20),

//                   // Name
//                   _buildTextField(_nameController, 'Name', Icons.person, false),

//                   // Email
//                   _buildTextField(_emailController, 'Email', Icons.email, false),

//                   // Age
//                   _buildTextField(_ageController, 'Age', Icons.calendar_today, false, isNumber: true),

//                   // Password
//                   _buildTextField(_passwordController, 'Password', Icons.lock, true, isPassword: true),

//                   // Confirm Password
//                   _buildTextField(_confirmPasswordController, 'Confirm Password', Icons.lock, true, isPassword: true),

//                   SizedBox(height: 20),

//                   // Register Button
//                   _isUploading
//                       ? CircularProgressIndicator()
//                       : ElevatedButton(
//                           onPressed: _registerUser,
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.white,
//                             padding: EdgeInsets.symmetric(horizontal: 50, vertical: 12),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(20),
//                             ),
//                           ),
//                           child: Text(
//                             'Register',
//                             style: TextStyle(color: Colors.deepPurple, fontSize: 16, fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   /// **Reusable TextField Widget**
//   Widget _buildTextField(TextEditingController controller, String label, IconData icon, bool obscureText,
//       {bool isPassword = false, bool isNumber = false}) {
//     return Padding(
//       padding: EdgeInsets.only(bottom: 15),
//       child: TextFormField(
//         controller: controller,
//         obscureText: isPassword ? (!_isPasswordVisible) : obscureText,
//         keyboardType: isNumber ? TextInputType.number : TextInputType.text,
//         validator: (value) => value!.isEmpty ? 'Enter your $label' : null,
//         decoration: InputDecoration(
//           labelText: label,
//           prefixIcon: Icon(icon, color: Colors.white),
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//           suffixIcon: isPassword
//               ? IconButton(
//                   icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off),
//                   onPressed: () {
//                     setState(() {
//                       _isPasswordVisible = !_isPasswordVisible;
//                     });
//                   },
//                 )
//               : null,
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:typed_data';

// 🎨 Professional Color Palette
const kPrimaryColor = Color(0xFF4B0082);       // Indigo
const kAccentColor = Color(0xFF6A5ACD);        // Slate Blue
const kBackgroundColor = Color(0xFFF9F9FC);    // Soft white
const kTextPrimary = Color(0xFF1F1F1F);         // Dark grey/black
const kTextSecondary = Color(0xFF6C6C6C);       // Muted grey

class RegistrationUser extends StatefulWidget {
  const RegistrationUser({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegistrationUser> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  // New Fields
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _skillsController = TextEditingController();
  final TextEditingController _languagesController = TextEditingController();
  final TextEditingController _qualificationController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  File? _image;
  Uint8List? _webImage;
  bool _isUploading = false;
  bool _isPasswordVisible = false;
  String? _imageUrl;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      if (kIsWeb) {
        final bytes = await pickedFile.readAsBytes();
        setState(() => _webImage = bytes);
      } else {
        setState(() => _image = File(pickedFile.path));
      }
    }
  }

  Future<String?> _uploadImageToCloudinary(File imageFile) async {
    setState(() => _isUploading = true);
    try {
      const cloudinaryUrl = "https://api.cloudinary.com/v1_1/dvijd3hxi/image/upload";
      const uploadPreset = "profile_images";

      final request = http.MultipartRequest('POST', Uri.parse(cloudinaryUrl))
        ..fields['upload_preset'] = uploadPreset
        ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

      final response = await request.send();
      final responseData = await response.stream.bytesToString();
      final data = json.decode(responseData);

      return response.statusCode == 200 ? data['secure_url'] : null;
    } catch (e) {
      print("❌ Cloudinary Upload Error: $e");
      return null;
    } finally {
      setState(() => _isUploading = false);
    }
  }

  void _registerUser() async {
    if (!_formKey.currentState!.validate()) return;

    if (_passwordController.text.trim() != _confirmPasswordController.text.trim()) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Passwords do not match!')));
      return;
    }

    if (_image == null && _webImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please select a profile image!')));
      return;
    }

    try {
      String? imageUrl;
      if (!kIsWeb && _image != null) {
        imageUrl = await _uploadImageToCloudinary(_image!);
      }

      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      User? user = userCredential.user;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'name': _nameController.text.trim(),
          'email': _emailController.text.trim(),
          'age': int.parse(_ageController.text.trim()),
          'uid': user.uid,
          'profileImageUrl': imageUrl ?? '',
          'role': 'user',
          'address': _addressController.text.trim(),
          'dob': _dobController.text.trim(),
          'bio': _bioController.text.trim(),
          'skills': _skillsController.text.trim(),
          'languages': _languagesController.text.trim(),
          'qualification': _qualificationController.text.trim(),
        });

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Registration Successful!')));
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        title: Text('User Registration', style: TextStyle(color: Colors.white)),
        backgroundColor: kPrimaryColor,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: kPrimaryColor,
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
                  SizedBox(height: 20),
                  _buildTextField(_nameController, 'Name', Icons.person, false),
                  _buildTextField(_emailController, 'Email', Icons.email, false),
                  _buildTextField(_ageController, 'Age', Icons.calendar_today, false, isNumber: true),
                  _buildTextField(_addressController, 'Address', Icons.location_on, false),
                  _buildTextField(_dobController, 'Date of Birth (YYYY-MM-DD)', Icons.cake, false),
                  _buildTextField(_bioController, 'Bio', Icons.info_outline, false),
                  _buildTextField(_skillsController, 'Skills (comma-separated)', Icons.build, false),
                  _buildTextField(_languagesController, 'Languages Known', Icons.language, false),
                  _buildTextField(_qualificationController, 'Qualification', Icons.school, false),
                  _buildTextField(_passwordController, 'Password', Icons.lock, true, isPassword: true),
                  _buildTextField(_confirmPasswordController, 'Confirm Password', Icons.lock, true, isPassword: true),
                  SizedBox(height: 20),
                  _isUploading
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: _registerUser,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kPrimaryColor,
                            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          ),
                          child: Text(
                            'Register',
                            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
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

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon,
    bool obscureText, {
    bool isPassword = false,
    bool isNumber = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword ? !_isPasswordVisible : obscureText,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        validator: (value) => value!.isEmpty ? 'Enter your $label' : null,
        style: TextStyle(color: kTextPrimary),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: kTextSecondary),
          prefixIcon: Icon(icon, color: kPrimaryColor),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: kPrimaryColor)),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off, color: kPrimaryColor),
                  onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                )
              : null,
        ),
      ),
    );
  }
}
