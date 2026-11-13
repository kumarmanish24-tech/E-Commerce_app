
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 20),

          const CircleAvatar(
            radius: 48,
            backgroundColor: Color(0xFFDCE7F0),
            child: Icon(
              Icons.person,
              size: 55,
              color: Color(0xFF315C81),
            ),
          ),

          const SizedBox(height: 14),

          const Text(
            'Manish Kumar',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const Text(
            'manish@example.com',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),

          const SizedBox(height: 30),

          const ProfileOption(
            icon: Icons.person_outline,
            title: 'Edit Profile',
          ),
          const ProfileOption(
            icon: Icons.shopping_bag_outlined,
            title: 'My Orders',
          ),
          const ProfileOption(
            icon: Icons.location_on_outlined,
            title: 'My Addresses',
          ),
          const ProfileOption(
            icon: Icons.payment_outlined,
            title: 'Payment Methods',
          ),
          const ProfileOption(
            icon: Icons.settings_outlined,
            title: 'Settings',
          ),
          const ProfileOption(
            icon: Icons.logout,
            title: 'Logout',
          ),
        ],
      ),
    );
  }
}

class ProfileOption extends StatelessWidget {
  final IconData icon;
  final String title;

  const ProfileOption({
    super.key,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF315C81)),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {},
    );
  }
}
