import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'dart:convert';

class EditProfileScreen extends StatefulWidget {
  final String matricNo;

  const EditProfileScreen({super.key, required this.matricNo});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;

  Uint8List? _webImageBytes;
  String? _currentProfilePicUrl;
  final ImagePicker _picker = ImagePicker();

  bool _isFetchingData = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: 'User Profile');
    _phoneController = TextEditingController(text: '+6012-3456789');
    _loadCurrentProfileData();
  }

  Future<void> _loadCurrentProfileData() async {
    debugPrint("=== Starting Profile Data Fetch for Matric: ${widget.matricNo} ===");
    try {
      final snapshot = await FirebaseDatabase.instanceFor(
        app: Firebase.app(),
        databaseURL: 'https://group-kiosk-default-rtdb.asia-southeast1.firebasedatabase.app',
      ).ref().child('students').child(widget.matricNo).get().timeout(const Duration(seconds: 3));

      if (snapshot.exists && snapshot.value != null) {
        debugPrint("=== Data successfully retrieved from Firebase! ===");
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        if (mounted) {
          setState(() {
            _nameController.text = data['fullName'] ?? 'User Profile';
            _phoneController.text = data['phoneNumber'] ?? '+6012-3456789';
            _currentProfilePicUrl = data['profilePicUrl'];
          });
        }
      } else {
        debugPrint("=== No existing database record found for this student matrix. ===");
      }
    } catch (e) {
      debugPrint("=== Firebase background fetch stopped/timed out: $e ===");
    } finally {
      if (mounted) {
        setState(() {
          _isFetchingData = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

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
                  final Uint8List imageBytes = await pickedFile.readAsBytes();
                  setState(() {
                    _webImageBytes = imageBytes;
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
                  final Uint8List imageBytes = await pickedFile.readAsBytes();
                  setState(() {
                    _webImageBytes = imageBytes;
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
        bottom: _isFetchingData
            ? const PreferredSize(
          preferredSize: Size.fromHeight(4),
          child: LinearProgressIndicator(color: Colors.white, backgroundColor: Colors.transparent),
        )
            : null,
      ),
      body: _isSaving
          ? const Center(
        child: CircularProgressIndicator(color: Color(0xFFE76F2F)),
      )
          : SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            GestureDetector(
              onTap: _pickImage,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.grey[400],
                    backgroundImage: _webImageBytes != null
                        ? MemoryImage(_webImageBytes!)
                        : (_currentProfilePicUrl != null && _currentProfilePicUrl!.isNotEmpty
                        ? (_currentProfilePicUrl!.startsWith('data:image')
                        ? MemoryImage(base64Decode(_currentProfilePicUrl!.split(',').last))
                        : NetworkImage(_currentProfilePicUrl!) as ImageProvider)
                        : null),
                  ),
                  if (_webImageBytes == null && _currentProfilePicUrl == null)
                    const CircleAvatar(
                      radius: 55,
                      backgroundColor: Colors.black26,
                      child: Icon(Icons.camera_alt, color: Colors.white, size: 28),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 32),

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
            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE76F2F),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () async {
                  setState(() {
                    _isSaving = true;
                  });

                  try {
                    String imageUrl = _currentProfilePicUrl ?? "";

                    if (_webImageBytes != null) {
                      String base64String = base64Encode(_webImageBytes!);
                      imageUrl = "data:image/jpeg;base64,$base64String";
                    }

                    final Map<String, dynamic> updatedData = {
                      'fullName': _nameController.text.trim(),
                      'phoneNumber': _phoneController.text.trim(),
                      'profilePicUrl': imageUrl,
                      'updatedAt': DateTime.now().millisecondsSinceEpoch,
                    };

                    await FirebaseDatabase.instanceFor(
                      app: Firebase.app(),
                      databaseURL: 'https://group-kiosk-default-rtdb.asia-southeast1.firebasedatabase.app',
                    ).ref().child('students').child(widget.matricNo).update(updatedData);

                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Profile saved successfully!')),
                      );
                      Navigator.pop(context);
                    }
                  } catch (e) {
                    setState(() {
                      _isSaving = false;
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