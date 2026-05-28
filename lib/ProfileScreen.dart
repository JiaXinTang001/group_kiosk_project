import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:convert';
import 'package:group_kiosk/CommunityRulesScreen.dart';
import 'package:group_kiosk/OrderHistoryScreen.dart';
import 'package:group_kiosk/SettingsScreen.dart';
import 'package:group_kiosk/FavouriteScreen.dart';
import 'package:group_kiosk/LanguageScreen.dart';
import 'package:group_kiosk/HelpCentreScreen.dart';
import 'package:group_kiosk/PoliciesScreen.dart';
import 'package:group_kiosk/EditProfileScreen.dart';

class ProfileScreen extends StatefulWidget {
  final String matricNo;

  const ProfileScreen({super.key, required this.matricNo});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffEFEFEF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE76F2F),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text('Profile', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: FutureBuilder<DataSnapshot>(
        future: FirebaseDatabase.instanceFor(
          app: Firebase.app(),
          databaseURL: 'https://group-kiosk-default-rtdb.asia-southeast1.firebasedatabase.app',
        ).ref().child('students').child(widget.matricNo).get(),
        builder: (context, snapshot) {
          String displayName = 'User Profile';
          String displayPhone = '+6012-3456789';
          String? displayImage;

          if (snapshot.hasData && snapshot.data!.value != null) {
            final data = Map<String, dynamic>.from(snapshot.data!.value as Map);
            displayName = data['fullName'] ?? displayName;
            displayPhone = data['phoneNumber'] ?? displayPhone;
            if (data['profilePicUrl'] != null && data['profilePicUrl'].toString().isNotEmpty) {
              displayImage = data['profilePicUrl'];
            }
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 10),
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: displayImage != null
                      ? (displayImage.startsWith('data:image')
                      ? MemoryImage(base64Decode(displayImage.split(',').last))
                      : NetworkImage(displayImage) as ImageProvider)
                      : null,
                  child: displayImage == null
                      ? const Icon(Icons.person, size: 50, color: Colors.grey)
                      : null,
                ),
                const SizedBox(height: 12),

                Text(displayName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(
                  '${widget.matricNo}@student.edu.my',
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(height: 12),

                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFE76F2F)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditProfileScreen(matricNo: widget.matricNo),
                      ),
                    );
                    setState(() {});
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                    child: Text('Edit profile', style: TextStyle(color: Color(0xFFE76F2F))),
                  ),
                ),
                const SizedBox(height: 24),

                _buildProfileMenu(context, Icons.history, 'Order history'),
                _buildProfileMenu(context, Icons.settings_outlined, 'Settings'),
                _buildProfileMenu(context, Icons.favorite_border, 'Favourite'),
                _buildProfileMenu(context, Icons.language, 'Language', trailingText: 'English'),
                _buildProfileMenu(context, Icons.help_outline, 'Help Centre'),
                _buildProfileMenu(context, Icons.gavel_outlined, 'Community Rules'),
                _buildProfileMenu(context, Icons.privacy_tip_outlined, 'Policies'),

                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
                  },
                  child: const Text('Log Out', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileMenu(BuildContext context, IconData icon, String title, {String? trailingText}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(icon, color: Colors.black87),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        trailing: trailingText != null
            ? Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(trailingText, style: const TextStyle(color: Colors.grey)),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        )
            : const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: () {
          Widget targetScreen;

          switch (title) {
            case 'Order history':
              targetScreen = const OrderHistoryScreen();
              break;
            case 'Settings':
              targetScreen = const SettingsScreen();
              break;
            case 'Favourite':
              targetScreen = const FavouriteScreen();
              break;
            case 'Language':
              targetScreen = const LanguageScreen();
              break;
            case 'Help Centre':
              targetScreen = const HelpCentreScreen();
              break;
            case 'Community Rules':
              targetScreen = const CommunityRulesScreen();
              break;
            case 'Policies':
              targetScreen = const PoliciesScreen();
              break;
            default:
              return;
          }

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => targetScreen),
          );
        },
      ),
    );
  }
}