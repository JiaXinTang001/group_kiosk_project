import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:group_kiosk/firebase_options.dart';
import 'package:group_kiosk/LoginScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const UniBiteApp());
}

class UniBiteApp extends StatelessWidget {
  const UniBiteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UniBite',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFFE76F2F),
        scaffoldBackgroundColor: const Color(0xffF3F3F3),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE76F2F),
          primary: const Color(0xFFE76F2F),
        ),
        fontFamily: 'Poppins',
      ),
      home: const SplashScreen(),
    );
  }
}

class FoodItem {
  final String name;
  final double price;
  final String imagePath;
  final String category;

  const FoodItem({
    required this.name,
    required this.price,
    required this.imagePath,
    required this.category,
  });
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE76F2F),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 160,
                height: 160,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.rice_bowl_outlined,
                    size: 90,
                    color: Color(0xFFE76F2F),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'UniBite',
                style: TextStyle(
                  fontFamily: 'Serif',
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Order ahead\nskip the queue',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                  fontWeight: FontWeight.w400,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}