import 'package:flutter/material.dart';
import '../widgets/app_footer.dart';

class VisionTestResultsScreen extends StatefulWidget {
  const VisionTestResultsScreen({super.key});

  @override
  State<VisionTestResultsScreen> createState() => _VisionTestResultsScreenState();
}

class _VisionTestResultsScreenState extends State<VisionTestResultsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF), // background-light
      body: SafeArea(
        child: Column(
          children: [
            _buildStickyHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    _buildTitleSection(),
                    const SizedBox(height: 32),
                    _buildVisualAcuityCard(),
                    const SizedBox(height: 32),
                    _buildPrescriptionCard(),
                    const SizedBox(height: 32),
                    _buildVerificationSection(),
                    const SizedBox(height: 100), // Space for footer
                  ],
                ),
              ),
            ),
            const AppFooter(currentIndex: 1), // Vision Test highlighted
          ],
        ),
      ),
    );
  }

  Widget _buildStickyHeader() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF).withValues(alpha: 0.8), // background-light/80
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(8),
                child: const Icon(
                  Icons.arrow_back,
                  color: Color(0xFF111718), // foreground-light
                  size: 24,
                ),
              ),
            ),
            const Expanded(
              child: Text(
                'Vision Test Results',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111718), // foreground-light
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(width: 40), // Balance the back button
          ],
        ),
      ),
    );
  }

  Widget _buildTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your Results are Ready!',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF111718), // foreground-light
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Based on your recent comprehensive eye exam.',
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF618389), // foreground-muted-light
          ),
        ),
      ],
    );
  }

  Widget _buildVisualAcuityCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F4F4), // card-light
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Visual Acuity',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111718), // foreground-light
                ),
              ),
              const Text(
                '20/20',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF10B2D0), // primary
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Center(
            child: Text(
              'E D F C Z P',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                letterSpacing: 4,
                color: Color(0xFF111718), // foreground-light
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'You have successfully read the 20/20 line.',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF618389), // foreground-muted-light
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Container(
            height: 1,
            color: const Color(0xFFE3E5E5), // border-light
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Astigmatism',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111718), // foreground-light
                ),
              ),
              const Text(
                'Pass',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF10B2D0), // primary
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Near Vision',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111718), // foreground-light
                ),
              ),
              const Text(
                'Normal',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF10B2D0), // primary
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            height: 1,
            color: const Color(0xFFE3E5E5), // border-light
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Color Vision',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111718), // foreground-light
                ),
              ),
              const Text(
                'Normal',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF10B2D0), // primary
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPrescriptionCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F4F4), // card-light
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const Text(
            'Lens Prescription',
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
                child: Column(
                  children: [
                    const Text(
                      'Right (OD)',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF618389), // foreground-muted-light
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      '-1.25',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111718), // foreground-light
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    const Text(
                      'Left (OS)',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF618389), // foreground-muted-light
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      '-1.50',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111718), // foreground-light
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    const Text(
                      'PD',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF618389), // foreground-muted-light
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      '63',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111718), // foreground-light
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'This is a preliminary prescription. For a final prescription, please consult a licensed doctor.',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF618389), // foreground-muted-light
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildVerificationSection() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF10B2D0).withValues(alpha: 0.1), // primary/10
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Column(
            children: [
              Text(
                'Get Your Prescription Verified',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF10B2D0), // primary
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 4),
              Text(
                'Upgrade to our premium plan to submit your results to a licensed doctor for review and get a certified prescription.',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF10B2D0), // primary with opacity
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              // Handle premium submission
              _showPremiumDialog();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B2D0), // primary
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 0,
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.verified_user, size: 20),
                SizedBox(width: 8),
                Text(
                  'Submit to Doctor (Premium)',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              // Handle download results
              _downloadResults();
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF10B2D0), // primary
              side: const BorderSide(color: Color(0xFF10B2D0)),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.download, size: 20),
                SizedBox(width: 8),
                Text(
                  'Download Results',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showPremiumDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Premium Feature'),
        content: const Text('This feature requires a premium subscription. Would you like to upgrade?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Handle premium upgrade
            },
            child: const Text('Upgrade'),
          ),
        ],
      ),
    );
  }

  void _downloadResults() {
    // Handle download results
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Results downloaded successfully!'),
        backgroundColor: Color(0xFF10B2D0),
      ),
    );
  }
}
