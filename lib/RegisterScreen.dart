import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _matricController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _matricController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF3F3F3),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE76F2F),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Create Account', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 10),
            const Icon(Icons.app_registration_outlined, size: 70, color: Color(0xFFE76F2F)),
            const SizedBox(height: 24),

            // Full Name Input
            TextField(
              controller: _nameController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                prefixIcon: Icon(Icons.badge_outlined),
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16),

            // Email Input Field
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Email Address',
                prefixIcon: Icon(Icons.email_outlined),
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16),

            // Matric ID Input
            TextField(
              controller: _matricController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Student ID / Matric No',
                prefixIcon: Icon(Icons.assignment_ind_outlined),
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16),

            // Phone Number Input
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                prefixIcon: Icon(Icons.phone_android_outlined),
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16),

            // Password Input
            TextField(
              controller: _passwordController,
              obscureText: true,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(
                labelText: 'Create Password',
                prefixIcon: Icon(Icons.lock_open_outlined),
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 32),

            // Action Button / Spinner
            _isLoading
                ? const Center(child: CircularProgressIndicator(color: Color(0xFFE76F2F)))
                : ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE76F2F),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              onPressed: () async {
                if (_nameController.text.trim().isEmpty ||
                    _emailController.text.trim().isEmpty ||
                    _matricController.text.trim().isEmpty ||
                    _phoneController.text.trim().isEmpty ||
                    _passwordController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill out all fields!')),
                  );
                  return;
                }

                setState(() {
                  _isLoading = true;
                });

                try {
                  // 1. FIREBASE AUTH: Register User
                  UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                    email: _emailController.text.trim(),
                    password: _passwordController.text.trim(),
                  );

                  // 2. CLOUD FIRESTORE: Save Extra Student Data
                  await FirebaseFirestore.instance.collection('students').doc(userCredential.user!.uid).set({
                    'email': _emailController.text.trim(),
                    'matricNo': _matricController.text.trim(),
                    'fullName': _nameController.text.trim(),
                    'phoneNumber': _phoneController.text.trim(),
                    'profilePicUrl': 'https://via.placeholder.com/150',
                    'createdAt': Timestamp.now(),
                  });

                  // 3. SUCCESS PIPELINE: Turn off loading, show green snackbar, and route pop backward
                  if (mounted) {
                    setState(() {
                      _isLoading = false;
                    });

                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Account registered successfully!'),
                        backgroundColor: Colors.green,
                      ),
                    );

                    Navigator.of(context).pop();
                  }
                } catch (e) {
                  // 4. ERROR PIPELINE: Reset spinner and print error string safely
                  if (mounted) {
                    setState(() {
                      _isLoading = false;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Registration Failed: ${e.toString().split(']').last}')),
                    );
                  }
                }
              },
              child: const Text(
                'Register Now',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}