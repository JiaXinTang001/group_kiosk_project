import 'package:flutter/material.dart';
import 'package:group_kiosk/CommunityRulesScreen.dart';

class ProfileScreen extends StatelessWidget {
  final String matricNo;

  const ProfileScreen({super.key, required this.matricNo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFE76F2F),
        title: const Text('Profile', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey,
              backgroundImage: NetworkImage('https://via.placeholder.com/150'),
            ),
            const SizedBox(height: 12),
            const Text('User Profile', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

            Text(
              '$matricNo@student.edu.my',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 12),

            OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFE76F2F)),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Opening Edit Profile...'), duration: Duration(seconds: 1)),
                );
              },
              child: const Text('Edit profile', style: TextStyle(color: Color(0xFFE76F2F))),
            ),
            const SizedBox(height: 24),

            // FIXED: Removed the floating onTap chunk that was breaking the Column list
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
              child: const Text('Log Out', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  // FIXED: The navigation routing logic now lives inside the helper template down here!
  Widget _buildProfileMenu(BuildContext context, IconData icon, String title, {String? trailingText}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(icon, color: Colors.black87),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        trailing: trailingText != null
            ? Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(trailingText, style: const TextStyle(color: Colors.grey)),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        )
            : const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: () {
          // It checks the title string dynamically here when tapped
          if (title == 'Community Rules') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CommunityRulesScreen()),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Opening $title...'), duration: const Duration(seconds: 1)),
            );
          }
        },
      ),
    );
  }
}