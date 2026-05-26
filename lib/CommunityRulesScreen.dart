import 'package:flutter/material.dart';

class CommunityRulesScreen extends StatelessWidget {
  const CommunityRulesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFE76F2F),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Community Rules', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          '1. Please collect your food within 15 minutes of completion.\n\n'
              '2. Treat cafeteria staff with respect.\n\n'
              '3. Cancel orders before the kitchen starts preparation.',
          style: TextStyle(fontSize: 16, height: 1.5),
        ),
      ),
    );
  }
}