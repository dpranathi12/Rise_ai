import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: ListView(
        children: [
          _buildSectionHeader("Account"),
          _buildSettingTile(Icons.person_outline, "Profile", "Edit your name and email"),
          _buildSettingTile(Icons.notifications_none, "Notifications", "Manage alarm and reminder alerts"),
          
          _buildSectionHeader("AI & Exercise"),
          _buildSettingTile(Icons.fitness_center, "Exercise Preferences", "Customize your morning challenges"),
          _buildSettingTile(Icons.psychology_outlined, "Adaptive Difficulty", "Manage how AI adjusts challenges"),
          
          _buildSectionHeader("Appearance"),
          _buildSettingTile(Icons.dark_mode_outlined, "Theme", "System default"),
          _buildSettingTile(Icons.language, "Language", "English (India)"),
          
          _buildSectionHeader("Privacy & Security"),
          _buildSettingTile(Icons.lock_outline, "Privacy Policy", ""),
          _buildSettingTile(Icons.security, "Permissions", "Manage camera and notification access"),
          
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
              child: const Text("Logout"),
            ),
          ),
          const SizedBox(height: 16),
          const Center(
            child: Text(
              "RiseAI v1.0.0",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Color(0xFF6200EE),
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildSettingTile(IconData icon, String title, String subtitle) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
      leading: Icon(icon),
      title: Text(title),
      subtitle: subtitle.isNotEmpty ? Text(subtitle) : null,
      trailing: const Icon(Icons.chevron_right, size: 20),
      onTap: () {},
    );
  }
}
