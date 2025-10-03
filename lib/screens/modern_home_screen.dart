import 'package:flutter/material.dart';
import 'vision_test_screen.dart';
import '../widgets/app_header.dart';
import '../widgets/app_footer.dart';

class ModernHomeScreen extends StatefulWidget {
  const ModernHomeScreen({super.key});

  @override
  State<ModernHomeScreen> createState() => _ModernHomeScreenState();
}

class _ModernHomeScreenState extends State<ModernHomeScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF), // background-light
      body: SafeArea(
        child: Column(
          children: [
            const AppHeader(title: 'Sighty'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildWelcomeCard(),
                    const SizedBox(height: 32),
                    _buildDailyExercises(),
                    const SizedBox(height: 32),
                    _buildQuickStats(),
                    const SizedBox(height: 32),
                    _buildSearchBar(),
                    const SizedBox(height: 32),
                    _buildTrendingArticles(),
                    const SizedBox(height: 100), // Space for bottom nav
                  ],
                ),
              ),
            ),
            const AppFooter(currentIndex: 0),
          ],
        ),
      ),
    );
  }


  Widget _buildWelcomeCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF10B2D0).withValues(alpha: 0.1), // primary/10
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Good Morning, Suzie!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111718), // foreground-light
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Let\'s keep your eyes healthy today.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF618389), // subtle-light
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const VisionTestScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF10B2D0), // primary
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Start Vision Test',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 24),
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: const Color(0xFF10B2D0).withValues(alpha: 0.2), // primary/20
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person,
              size: 48,
              color: Color(0xFF10B2D0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyExercises() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Daily Exercises',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF111718), // foreground-light
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5), // gray-100
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Exercises Completed',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF111718), // foreground-light
                    ),
                  ),
                  const Text(
                    '6/10',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF618389), // subtle-light
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                height: 8,
                decoration: BoxDecoration(
                  color: const Color(0xFFDBE4E6), // border-light
                  borderRadius: BorderRadius.circular(4),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: 0.6, // 60% progress
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B2D0), // primary
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStats() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Stats',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF111718), // foreground-light
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Screen time today',
                '2h 30m',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                'Last test date',
                '2024-01-15',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5), // gray-100
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF618389), // subtle-light
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111718), // foreground-light
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5), // gray-100
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.transparent),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search articles',
          hintStyle: const TextStyle(
            color: Color(0xFF618389), // subtle-light
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: Color(0xFF618389), // subtle-light
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        style: const TextStyle(
          color: Color(0xFF111718), // foreground-light
        ),
      ),
    );
  }

  Widget _buildTrendingArticles() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Trending Articles',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF111718), // foreground-light
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildArticleCard(
                'Digital Eye Strain: Causes and Solutions',
                'Learn how to protect your eyes from screen fatigue.',
                'https://lh3.googleusercontent.com/aida-public/AB6AXuCRsJ-0Izu0AXqAcWZzyOzME4JtjVuYBjAYGQSfHLR9NPLFicalSZgIPXm6Edsag8CZ4qfO1B5ZPUTOkl1hp2X5p_DeDzWOAOqLgLVGhDq8738sWAz2rx0u5SutZBZOkA3HwynQi3C3gMeqehzEHi6CYQLw1WITDPl4sCqiWyOMRLKwT-Xis_cQDByTPngJvKad7wtIVlBtGARqEoim_MiOr0IEXtO2A5YG56-w3zXbYshAeKGhCNQQ78R7kptbr8E9cuPrAZKLYfQG',
              ),
              const SizedBox(width: 16),
              _buildArticleCard(
                'Understanding Cataracts in Africa',
                'A look at prevalence and treatment options.',
                'https://lh3.googleusercontent.com/aida-public/AB6AXuA-ZZZQl12g-zat5PqBxw2mJzq_rUDKS2Y-PCS-S4k8Aad26AF7VTR28lUogaiJwWLYwKBH27gBUDeAAaQYaLn76PuJNSdwuy12IQoZHj7BfhOLxfufxsKcWiwlbV-JoJs3ebXG3vPRm-gK4bYZei686wC8LzIDqK2BfsHLDRyXyYvDj-GeuyC83AFc0K-2aC61ijiZA9Cx2B2T5c9qerrIxpHIYUKtu1o9JM6pO7axR6WTxqFayS7kcyCk86lD3754FcdLm6TKmI3N',
              ),
              const SizedBox(width: 16),
              _buildArticleCard(
                'The Importance of Regular Eye Exams',
                'Why you shouldn\'t skip your annual check-up.',
                'https://lh3.googleusercontent.com/aida-public/AB6AXuC-1kyQL-xWYOkMPm7ZrXdv2UEMK8iDHPwzim55CWQwuglq4sW7V71Ag5dbx6Xk2Otd30CY7Hta2jA1XkXrH1VyRhqw20OQFSpRnn_JLHTY04McWJ3E2vSfjwsTenglVqSvp2mGbHGqx6BX-WhZcXB7EnTz-9x3BmrDHmXSdW9SU0ex88xjWdx-F9qQXoSS43i4MN5NP59UR4aTIW06Nc15RymkLBiY5S7DpMieTS710R244LS5yvxFnwp8fQcCRg76iuicPAmcyeGi',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildArticleCard(String title, String description, String imageUrl) {
    return Container(
      width: 256, // w-64
      height: 200, // Fixed height to prevent overflow
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFDBE4E6), // border-light
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 128, // h-32
            decoration: BoxDecoration(
              color: const Color(0xFF10B2D0).withValues(alpha: 0.1), // primary/10
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 128,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: const Color(0xFF10B2D0).withValues(alpha: 0.1),
                    child: const Icon(
                      Icons.article,
                      color: Color(0xFF10B2D0),
                      size: 48,
                    ),
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF111718), // foreground-light
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Flexible(
                    child: Text(
                      description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF618389), // subtle-light
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

}
