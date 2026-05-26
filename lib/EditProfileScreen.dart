import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Handles choosing gallery/camera files
import 'package:firebase_storage/firebase_storage.dart'; // Handles file uploads
import 'package:cloud_firestore/cloud_firestore.dart'; // Handles text databases
import 'package:firebase_auth/firebase_auth.dart'; // For dynamic user tracking

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController(text: 'User Profile');
  final _phoneController = TextEditingController(text: '+6012-3456789');

  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false; // Controls screen loading blocker state during database upload

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  // Method to trigger the bottom sheet menu for image source options
  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library, color: Color(0xFFE76F2F)),
              title: const Text('Choose from Gallery'),
              onTap: () async {
                Navigator.pop(context);
                final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
                if (pickedFile != null) {
                  setState(() {
                    _selectedImage = File(pickedFile.path);
                  });
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Color(0xFFE76F2F)),
              title: const Text('Take a Photo'),
              onTap: () async {
                Navigator.pop(context);
                final XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera);
                if (pickedFile != null) {
                  setState(() {
                    _selectedImage = File(pickedFile.path);
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffEFEFEF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE76F2F),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Edit Profile', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(color: Color(0xFFE76F2F)),
      )
          : Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // INTERACTIVE AVATAR WITH PHOTO UPLOADER CHANNELS
            GestureDetector(
              onTap: _pickImage,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.grey[400],
                    backgroundImage: _selectedImage != null
                        ? FileImage(_selectedImage!)
                        : null,
                  ),
                  if (_selectedImage == null)
                    const CircleAvatar(
                      radius: 55,
                      backgroundColor: Colors.black26,
                      child: Icon(Icons.camera_alt, color: Colors.white, size: 28),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Name Field Block
            TextField(
              controller: _nameController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16),

            // Phone Field Block
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) {
                FocusScope.of(context).unfocus();
              },
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE76F2F),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () async {
                  final userId = FirebaseAuth.instance.currentUser?.uid ?? 'guest_user';

                  setState(() {
                    _isLoading = true;
                  });

                  try {
                    String imageUrl = "";

                    // 1. FIREBASE STORAGE: Upload local image file to storage bucket if it exists
                    if (_selectedImage != null) {
                      String fileName = 'profile_${userId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
                      Reference storageRef = FirebaseStorage.instance.ref().child('user_profiles/$fileName');

                      UploadTask uploadTask = storageRef.putFile(_selectedImage!);
                      TaskSnapshot snapshot = await uploadTask;
                      imageUrl = await snapshot.ref.getDownloadURL();
                    }

                    // 2. CLOUD FIRESTORE: Save text values and profile picture web link securely
                    await FirebaseFirestore.instance.collection('students').doc(userId).set({
                      'fullName': _nameController.text.trim(),
                      'phoneNumber': _phoneController.text.trim(),
                      if (imageUrl.isNotEmpty) 'profilePicUrl': imageUrl,
                      'updatedAt': Timestamp.now(),
                    }, SetOptions(merge: true));

                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Profile synced to Firebase online!')),
                      );
                      Navigator.pop(context);
                    }
                  } catch (e) {
                    setState(() {
                      _isLoading = false;
                    });
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Firebase error: $e')),
                      );
                    }
                  }
                },
                child: const Text('Save Changes', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}