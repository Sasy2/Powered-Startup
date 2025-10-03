import 'package:flutter/material.dart';
import '../widgets/app_footer.dart';
import 'vision_test_screen.dart';

class VisionTestSelectionScreen extends StatefulWidget {
  const VisionTestSelectionScreen({super.key});

  @override
  State<VisionTestSelectionScreen> createState() => _VisionTestSelectionScreenState();
}

class _VisionTestSelectionScreenState extends State<VisionTestSelectionScreen> {
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
                    _buildTestCards(),
                    const SizedBox(height: 100), // Space for footer
                  ],
                ),
              ),
            ),
            const AppFooter(currentIndex: 2),
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
      child: Column(
        children: [
          Padding(
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
                    'Vision Test',
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
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Test Progress',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF10B2D0), // primary
                      ),
                    ),
                    const Text(
                      '0%',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF10B2D0), // primary
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Container(
                  width: double.infinity,
                  height: 8,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5E7EB), // gray-200
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: 0.0, // 0% progress
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
      ),
    );
  }

  Widget _buildTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Start a new vision test',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF111718), // foreground-light
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Results are combined to estimate your prescription.',
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF618389), // foreground-muted-light
          ),
        ),
      ],
    );
  }

  Widget _buildTestCards() {
    return Column(
      children: [
        _buildTestCard(
          'Visual Acuity',
          'Snellen chart to test sharpness of your vision. Uses your screen and a credit card for calibration.',
          _buildVisualAcuityIcon(),
          () => _startTest('visual_acuity'),
        ),
        const SizedBox(height: 16),
        _buildTestCard(
          'Astigmatism Test',
          'Fan chart, clock dial, and parallel lines to check for astigmatism.',
          _buildAstigmatismIcon(),
          () => _startTest('astigmatism'),
        ),
        const SizedBox(height: 16),
        _buildTestCard(
          'Near Vision Test',
          'Read blocks of text in decreasing font sizes to test your near vision.',
          _buildNearVisionIcon(),
          () => _startTest('near_vision'),
        ),
        const SizedBox(height: 16),
        _buildTestCard(
          'Color Vision Test',
          'Ishihara plates to check for color vision deficiency.',
          _buildColorVisionIcon(),
          () => _startTest('color_vision'),
        ),
      ],
    );
  }

  Widget _buildTestCard(String title, String description, Widget icon, VoidCallback onTap) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F4F4), // card-light
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111718), // foreground-light
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF618389), // foreground-muted-light
                  ),
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: onTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B2D0).withValues(alpha: 0.2), // primary/20
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Start Test',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF10B2D0), // primary
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.arrow_forward,
                          size: 16,
                          color: Color(0xFF10B2D0), // primary
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: const Color(0xFFE5E7EB), // gray-200
              borderRadius: BorderRadius.circular(12),
            ),
            child: icon,
          ),
        ],
      ),
    );
  }

  Widget _buildVisualAcuityIcon() {
    return const Center(
      child: Text(
        'E',
        style: TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.bold,
          color: Color(0xFF111718), // foreground-light
        ),
      ),
    );
  }

  Widget _buildAstigmatismIcon() {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Image.network(
        'https://lh3.googleusercontent.com/aida-public/AB6AXuDsmalMQKg2tuTlRcAgLEo473_-Jktot3Hoh8c8Knqe5Ki8xMVMP6wLt1A0tBk8hWiG0YlRxD7fT0hlLhopdlSt_ZDdW6cDUGolbHHMe7z4h-wremqZa11vMRRaqiFxnIaE9CvRV98k5Og6Z4QE6ESy6q-sZjN77RCx6yMB2JQIItkUU-7R08J7sxzGIdbcH-7hnkeKwHM0A55zbAJMIosBfMFgXFD8_a3Z0XNMSORSCWrt2VddMF70LYd3ZWOUb0npC6256H3tMhBf',
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(
            Icons.radar,
            size: 32,
            color: Color(0xFF10B2D0),
          );
        },
      ),
    );
  }

  Widget _buildNearVisionIcon() {
    return Container(
      padding: const EdgeInsets.all(8),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'The quick brown fox',
            style: TextStyle(fontSize: 8, color: Color(0xFF111718)),
          ),
          Text(
            'jumps over the lazy dog',
            style: TextStyle(fontSize: 6, color: Color(0xFF111718)),
          ),
          Text(
            'And packs my box with',
            style: TextStyle(fontSize: 5, color: Color(0xFF111718)),
          ),
          Text(
            'five dozen liquor jugs',
            style: TextStyle(fontSize: 4, color: Color(0xFF111718)),
          ),
        ],
      ),
    );
  }

  Widget _buildColorVisionIcon() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: const DecorationImage(
          image: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuABy8wZt1-zSFkbk7ZGh3KnAbWsm5dxCpel0uy3H-7kCXeg33c7AgRwtgf1iS--GF65qYIl4gsugbbqf4yBxU-Bv5rXU7ObA-feFKtjuOxfI4aBxv7GZBWoqzRewtf30Yre_XgtXTeDI92UX7sLwxuQzV3pqL3lrwArsEayqR86j5VxwbounAGwcA3nTu-WhOkbOU3BWZic4kZqP18UzuxaSQ02EB2nlmZe0UdM6ycHs9yyi6a5ORmYs6KbTgsxowepgRTILFJArtA9'),
          fit: BoxFit.cover,
        ),
      ),
      child: null,
    );
  }

  void _startTest(String testType) {
    // Navigate to the vision test screen with the specific test type
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => VisionTestScreen(initialTestType: testType),
      ),
    );
  }
}
