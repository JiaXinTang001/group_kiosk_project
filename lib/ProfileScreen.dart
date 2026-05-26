import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Handles fetching data online
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
      // LIVE DATA STREAM: Fetches student data dynamically from Firestore using the matric number
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('students').doc(widget.matricNo).get(),
        builder: (context, snapshot) {
          // Fallback placeholders while loading or if data doesn't exist yet
          String displayName = 'User Profile';
          String displayPhone = '+6012-3456789';
          String displayImage = 'https://via.placeholder.com/150';

          if (snapshot.hasData && snapshot.data!.exists) {
            final data = snapshot.data!.data() as Map<String, dynamic>;
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
                // Dynamic Profile Image
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey,
                  backgroundImage: NetworkImage(displayImage),
                ),
                const SizedBox(height: 12),
                // Dynamic Student Name
                Text(displayName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                // Dynamic Student Email/Matric
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
                    // Passes the current dynamic data over to the editor screen
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EditProfileScreen(),
                      ),
                    );

                    // Triggers a UI refresh when they return from editing
                    setState(() {});
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                    child: Text('Edit profile', style: TextStyle(color: Color(0xFFE76F2F))),
                  ),
                ),
                const SizedBox(height: 24),

                // Profile Menu Options
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