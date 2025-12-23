import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/profile_provider.dart';
import '../models/user_profile.dart';
import '../providers/settings_provider.dart';
import 'bmi_calculator_screen.dart';
import 'activity_history_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  void _showEditProfile(BuildContext context, WidgetRef ref, UserProfile profile) {
    final nameController = TextEditingController(text: profile.name);
    final picController = TextEditingController(text: profile.profilePicture);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Profile', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Full Name'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: picController,
              decoration: const InputDecoration(labelText: 'Profile Picture URL'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(profileProvider.notifier).updateProfile(
                profile.copyWith(
                  name: nameController.text,
                  profilePicture: picController.text,
                ),
              );
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_note_rounded),
            onPressed: () => _showEditProfile(context, ref, profile),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                GestureDetector(
                  onTap: () => _showEditProfile(context, ref, profile),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFF6366F1), width: 2),
                    ),
                    child: CircleAvatar(
                      radius: 56,
                      backgroundColor: Colors.grey[900],
                      backgroundImage: profile.profilePicture.startsWith('http') 
                        ? NetworkImage(profile.profilePicture) 
                        : null,
                      child: !profile.profilePicture.startsWith('http') 
                        ? const Icon(Icons.person, size: 50, color: Colors.white24) 
                        : null,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 4,
                  child: GestureDetector(
                    onTap: () => _showEditProfile(context, ref, profile),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Color(0xFF6366F1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.camera_alt_rounded, size: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: () => _showEditProfile(context, ref, profile),
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  children: [
                    Text(
                      profile.name,
                      style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Premium Member since ${profile.memberSince}',
                      style: GoogleFonts.outfit(color: Colors.white38, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => _showEditProfile(context, ref, profile),
              icon: const Icon(Icons.edit_rounded, size: 18),
              label: const Text('Edit Profile Information'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF6366F1),
                side: const BorderSide(color: Color(0xFF6366F1)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 40),
            _buildOption(
              icon: Icons.calculate_rounded,
              title: 'BMI Calculator',
              subtitle: 'Check your Body Mass Index',
              color: const Color(0xFF06B6D4),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const BMICalculatorScreen()),
              ),
            ),
            const SizedBox(height: 16),
            _buildOption(
              icon: Icons.history_rounded,
              title: 'Activity History',
              subtitle: 'View your cumulative stats',
              color: const Color(0xFF6366F1),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ActivityHistoryScreen()),
              ),
            ),
            const SizedBox(height: 16),
            _buildOption(
              icon: Icons.settings_rounded,
              title: 'Settings',
              subtitle: 'App preferences and notifications',
              color: Colors.blueGrey,
              onTap: () {
                _showSettingsDialog(context);
              },
            ),
            const SizedBox(height: 16),
            _buildOption(
              icon: Icons.logout_rounded,
              title: 'Logout',
              subtitle: 'Sign out of your account',
              color: const Color(0xFFF43F5E),
              onTap: () => _showLogoutDialog(context),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Consumer(
        builder: (context, ref, _) {
          final settings = ref.watch(settingsProvider);
          final notifier = ref.read(settingsProvider.notifier);

          return AlertDialog(
            title: Text('Settings', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SwitchListTile(
                  title: const Text('Notifications'),
                  value: settings.notificationsEnabled,
                  activeColor: const Color(0xFF6366F1),
                  onChanged: (v) => notifier.toggleNotifications(v),
                ),
                SwitchListTile(
                  title: const Text('Dark Mode'),
                  value: settings.isDarkMode,
                  activeColor: const Color(0xFF6366F1),
                  onChanged: (v) => notifier.toggleDarkMode(v),
                ),
                ListTile(
                  title: const Text('Language'),
                  subtitle: Text(settings.language, style: const TextStyle(fontSize: 12)),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () {
                    _showLanguagePicker(context, ref);
                  },
                ),
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
            ],
          );
        },
      ),
    );
  }

  void _showLanguagePicker(BuildContext context, WidgetRef ref) {
    final languages = ['English', 'Spanish', 'French', 'German'];
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: languages.map((lang) => ListTile(
            title: Text(lang, style: GoogleFonts.outfit()),
            onTap: () {
              ref.read(settingsProvider.notifier).setLanguage(lang);
              Navigator.pop(context);
            },
            trailing: ref.read(settingsProvider).language == lang 
              ? const Icon(Icons.check_circle, color: Color(0xFF6366F1)) 
              : null,
          )).toList(),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Logout', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        content: const Text('Are you sure you want to exit FitFlow?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF43F5E)),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  Widget _buildOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.outfit(
                      color: Colors.white38,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.white24),
          ],
        ),
      ),
    );
  }
}
