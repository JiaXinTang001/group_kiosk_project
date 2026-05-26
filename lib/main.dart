import 'package:flutter/material.dart';
import 'package:group_kiosk/LoginScreen.dart';

void main() {
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
      // FIXED: Swapped MainNavigationScreen for LoginScreen so users must authenticate first
      home: const LoginScreen(),
    );
  }
}

// Simple Model for Food Items
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