import 'package:flutter/material.dart';
import '../screens/modern_home_screen.dart';
import '../screens/comprehensive_exercises_screen.dart';
import '../screens/vision_test_screen.dart';
import '../screens/eye_doctor_screen.dart';

/// Reusable app footer with rounded design and four navigation icons
class AppFooter extends StatelessWidget {
  final int currentIndex;

  const AppFooter({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF).withValues(alpha: 0.8), // background-light/80
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF).withValues(alpha: 0.8), // white/80
          borderRadius: BorderRadius.circular(40),
          border: Border.all(
            color: const Color(0xFFDBE4E6), // border-light
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(context, 0, Icons.home, 'Home'),
            _buildNavItem(context, 1, Icons.self_improvement, 'Exercises'),
            _buildNavItem(context, 2, Icons.visibility, 'Vision Test'),
            _buildNavItem(context, 3, Icons.support_agent, 'EyeDoctor'),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, int index, IconData icon, String label) {
    final isSelected = currentIndex == index;
    return GestureDetector(
      onTap: () {
        if (isSelected) return; // Don't navigate if already on current screen
        
        switch (index) {
          case 0:
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const ModernHomeScreen()),
              (route) => false,
            );
            break;
          case 1:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ComprehensiveExercisesScreen()),
            );
            break;
          case 2:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const VisionTestScreen()),
            );
            break;
          case 3:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const EyeDoctorScreen()),
            );
            break;
        }
      },
      child: SizedBox(
        width: 80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected 
                  ? const Color(0xFF10B2D0) // primary
                  : const Color(0xFF618389), // subtle-light
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isSelected 
                    ? const Color(0xFF10B2D0) // primary
                    : const Color(0xFF618389), // subtle-light
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
