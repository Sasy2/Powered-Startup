import 'package:flutter/material.dart';
import '../screens/profile_screen.dart';
import 'sighty_logo.dart';

/// Reusable app header with logo and settings
class AppHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onSettingsTap;
  final bool showSettings;

  const AppHeader({
    super.key,
    this.title = 'Sighty',
    this.onSettingsTap,
    this.showSettings = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
        Row(
          children: [
            const SightyLogo(size: 32),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111718), // foreground-light
              ),
            ),
          ],
        ),
          if (showSettings)
            Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
              ),
              child: IconButton(
                onPressed: onSettingsTap ?? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ProfileScreen()),
                  );
                },
                icon: const Icon(
                  Icons.settings,
                  color: Color(0xFF111718), // foreground-light
                  size: 24,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
