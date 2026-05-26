import 'package:flutter/material.dart';
import 'package:group_kiosk/MainNavigationScreen.dart';
import 'package:group_kiosk/ForgotPasswordScreen.dart';
import 'package:group_kiosk/RegisterScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // FIXED: Added a controller to read what the user types live
  final TextEditingController _matricController = TextEditingController();

  @override
  void dispose() {
    _matricController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF3F3F3),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.rice_bowl, size: 80, color: Color(0xFFE76F2F)),
            const SizedBox(height: 12),
            const Text(
              'Welcome Back!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFFE76F2F)),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _matricController, // FIXED: Linked controller here
              decoration: const InputDecoration(
                labelText: 'Student ID / Matric No',
                prefixIcon: Icon(Icons.person_outline),
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            const TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock_outline),
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()),
                  );
                },
                child: const Text('Forgot Password?', style: TextStyle(color: Color(0xFFE76F2F))),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE76F2F),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              onPressed: () {
                // FIXED: Pass the text value typed in the login textfield over to the dashboard
                String loggedInUser = _matricController.text.trim();
                if (loggedInUser.isEmpty) {
                  loggedInUser = "Guest User"; // Fallback placeholder text if blank
                }

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MainNavigationScreen(username: loggedInUser),
                  ),
                );
              },
              child: const Text('Sign In', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account? "),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RegisterScreen()),
                    );
                  },
                  child: const Text(
                    'Register here',
                    style: TextStyle(color: Color(0xFFE76F2F), fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}