import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildProfileCard(),
                    const SizedBox(height: 30),
                    _buildStatsSection(),
                    const SizedBox(height: 30),
                    _buildSettingsSection(),
                    const SizedBox(height: 30),
                    _buildSupportSection(),
                    const SizedBox(height: 30),
                    _buildLogoutButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(context),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF10B2D0), Color(0xFF0891A6)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 24,
            ),
          ),
          const Expanded(
            child: Center(
              child: Text(
                'Profile',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 32),
        ],
      ),
    );
  }

  Widget _buildProfileCard() {
    return Consumer<UserProvider>(
      builder: (context, provider, child) {
        final user = provider.currentUser;
        if (user == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return Container(
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: const Color(0xFF10B2D0).withValues(alpha: 0.1),
                child: user.profileImageUrl != null
                    ? ClipOval(
                        child: Image.network(
                          user.profileImageUrl!,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      )
                    : const Icon(
                        Icons.person,
                        size: 50,
                        color: Color(0xFF10B2D0),
                      ),
              ),
              const SizedBox(height: 20),
              Text(
                user.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111718),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                user.email,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF618389),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatItem('Tests', '${user.stats.totalVisionTests}'),
                  _buildStatItem('Exercises', '${user.stats.totalExercisesCompleted}'),
                  _buildStatItem('Streak', '${user.stats.currentStreak}'),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF10B2D0),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF618389),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsSection() {
    return Consumer<UserProvider>(
      builder: (context, provider, child) {
        final user = provider.currentUser;
        if (user == null) return const SizedBox.shrink();

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFB),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Your Progress',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111718),
                ),
              ),
              const SizedBox(height: 20),
              _buildProgressItem(
                'Screen Time Today',
                '${user.stats.averageScreenTime.toStringAsFixed(1)} hours',
                Icons.phone_android,
                const Color(0xFFFF6B6B),
              ),
              const SizedBox(height: 15),
              _buildProgressItem(
                'Last Vision Test',
                _formatDate(user.stats.lastVisionTest),
                Icons.visibility,
                const Color(0xFF10B2D0),
              ),
              const SizedBox(height: 15),
              _buildProgressItem(
                'Last Exercise',
                _formatDate(user.stats.lastExercise),
                Icons.fitness_center,
                const Color(0xFF4ECDC4),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProgressItem(String title, String value, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF111718),
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Settings',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF111718),
          ),
        ),
        const SizedBox(height: 15),
        _buildSettingItem(
          'Personal Information',
          Icons.person_outline,
          () {},
        ),
        _buildSettingItem(
          'Notifications',
          Icons.notifications_outlined,
          () {},
        ),
        _buildSettingItem(
          'Dark Mode',
          Icons.dark_mode_outlined,
          () {},
          trailing: Switch(
            value: false,
            onChanged: (value) {},
            activeThumbColor: const Color(0xFF10B2D0),
          ),
        ),
        _buildSettingItem(
          'Language',
          Icons.language_outlined,
          () {},
          trailing: const Text(
            'English',
            style: TextStyle(
              color: Color(0xFF618389),
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSupportSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Support',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF111718),
          ),
        ),
        const SizedBox(height: 15),
        _buildSettingItem(
          'Help & FAQ',
          Icons.help_outline,
          () {},
        ),
        _buildSettingItem(
          'Terms of Service',
          Icons.description_outlined,
          () {},
        ),
        _buildSettingItem(
          'Privacy Policy',
          Icons.privacy_tip_outlined,
          () {},
        ),
        _buildSettingItem(
          'Contact Us',
          Icons.contact_support_outlined,
          () {},
        ),
      ],
    );
  }

  Widget _buildSettingItem(String title, IconData icon, VoidCallback onTap, {Widget? trailing}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: const Color(0xFF10B2D0),
                  size: 24,
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF111718),
                    ),
                  ),
                ),
                if (trailing != null)
                  trailing
                else
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Color(0xFF618389),
                    size: 16,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Consumer<UserProvider>(
      builder: (context, provider, child) {
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => _showLogoutDialog(provider),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6B6B),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Log Out',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomNavigation(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFDBE4E6),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: const Color(0xFF10B2D0),
          unselectedItemColor: const Color(0xFF618389),
          selectedFontSize: 12,
          unselectedFontSize: 12,
          currentIndex: 4,
          onTap: (index) {
            if (index == 0) {
              Navigator.pop(context);
            } else if (index == 1) {
              Navigator.pushNamed(context, '/vision_test');
            } else if (index == 2) {
              Navigator.pushNamed(context, '/exercises');
            } else if (index == 3) {
              Navigator.pushNamed(context, '/chat');
            }
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.visibility),
              label: 'Vision Test',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.fitness_center),
              label: 'Exercises',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.smart_toy),
              label: 'EyeDoctor',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(UserProvider provider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Log Out'),
          content: const Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                provider.signOut();
                // Navigate to login screen or home
              },
              child: const Text(
                'Log Out',
                style: TextStyle(color: Color(0xFFFF6B6B)),
              ),
            ),
          ],
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
