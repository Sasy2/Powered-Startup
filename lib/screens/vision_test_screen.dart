import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../models/comprehensive_vision_test.dart';
import '../widgets/vision_test_painters.dart';
import '../widgets/professional_illustrations.dart';
import '../widgets/app_header.dart';
import '../widgets/app_footer.dart';
import 'vision_test_selection_screen.dart';
import 'vision_test_results_screen.dart';
// import 'package:flutter_tts/flutter_tts.dart';

class VisionTestScreen extends StatefulWidget {
  final String? initialTestType;
  
  const VisionTestScreen({super.key, this.initialTestType});

  @override
  State<VisionTestScreen> createState() => _VisionTestScreenState();
}

class _VisionTestScreenState extends State<VisionTestScreen> {
  // Test phases
  String currentPhase = 'calibration'; // 'calibration', 'instructions', 'test', 'switch_eye', 'results'
  String currentEye = 'right'; // Start with right eye
  String currentTestType = 'visual_acuity'; // 'visual_acuity', 'astigmatism', 'near_vision', 'color_vision'
  int currentTest = 0;
  int currentQuestion = 0;
  bool showResults = false;
  bool showInstructions = true;
  
  // Calibration data
  double pixelToMmRatio = 1.0; // Will be calculated during calibration
  double creditCardWidthMm = 8.56; // Standard credit card width
  double creditCardWidthPixels = 200.0; // Measured during calibration, initialized to default
  double phoneDistanceCm = 40.0; // Distance from phone to eyes
  double simulatedDistanceM = 3.0; // Simulated 3m distance for Snellen test
  
  // Test configuration
  late TestConfiguration testConfig;
  
  // Test results
  TestResults rightEyeResults = TestResults(
    acuityScore: '20/20',
    astigmatismAxis: 0,
    astigmatismCyl: 0.0,
    colorVisionResult: 'normal',
    nearVision: 'N8',
    astigmatismTests: [],
    colorVisionTests: [],
    nearVisionTests: [],
  );
  
  TestResults leftEyeResults = TestResults(
    acuityScore: '20/20',
    astigmatismAxis: 0,
    astigmatismCyl: 0.0,
    colorVisionResult: 'normal',
    nearVision: 'N8',
    astigmatismTests: [],
    colorVisionTests: [],
    nearVisionTests: [],
  );
  
  CompleteTestResults? completeResults;
  
  int correctAnswers = 0;
  int totalQuestions = 0;

  // TTS for voice instructions
  // FlutterTts flutterTts = FlutterTts();

  // Snellen test data - 8 lines with decreasing letter sizes
  final List<Map<String, dynamic>> snellenLines = [
    {'letters': ['E'], 'acuity': '20/200', 'sizeMm': 87.3, 'lineNumber': 0},
    {'letters': ['F', 'P'], 'acuity': '20/160', 'sizeMm': 69.8, 'lineNumber': 1},
    {'letters': ['T', 'O', 'Z'], 'acuity': '20/125', 'sizeMm': 54.6, 'lineNumber': 2},
    {'letters': ['L', 'P', 'E', 'D'], 'acuity': '20/100', 'sizeMm': 43.7, 'lineNumber': 3},
    {'letters': ['F', 'P', 'T', 'O', 'Z'], 'acuity': '20/80', 'sizeMm': 34.9, 'lineNumber': 4},
    {'letters': ['L', 'P', 'E', 'D', 'F', 'P'], 'acuity': '20/63', 'sizeMm': 27.3, 'lineNumber': 5},
    {'letters': ['T', 'O', 'Z', 'L', 'P', 'E', 'D'], 'acuity': '20/50', 'sizeMm': 21.8, 'lineNumber': 6},
    {'letters': ['F', 'P', 'T', 'O', 'Z', 'L', 'P', 'E'], 'acuity': '20/40', 'sizeMm': 17.5, 'lineNumber': 7},
    {'letters': ['D', 'F', 'P', 'T', 'O', 'Z', 'L', 'P', 'E'], 'acuity': '20/32', 'sizeMm': 13.9, 'lineNumber': 8},
    {'letters': ['D', 'F', 'P', 'T', 'O', 'Z', 'L', 'P', 'E', 'D'], 'acuity': '20/25', 'sizeMm': 10.9, 'lineNumber': 9},
    {'letters': ['F', 'P', 'T', 'O', 'Z', 'L', 'P', 'E', 'D', 'F'], 'acuity': '20/20', 'sizeMm': 8.7, 'lineNumber': 10},
  ];

  // Available letters for selection grid
  final List<String> availableLetters = ['C', 'D', 'E', 'F', 'L', 'O', 'P', 'T', 'Z'];
  
  // Current test state
  int currentLine = 0;
  int currentLetterIndex = 0;
  String? selectedLetter;
  bool isRetry = false;

  @override
  void initState() {
    super.initState();
    // Initialize pixelToMmRatio with a default value based on initial screen density
    pixelToMmRatio = creditCardWidthMm / creditCardWidthPixels;
    
    // Initialize test configuration
    testConfig = TestConfiguration(
      pixelToMmRatio: pixelToMmRatio,
      phoneDistanceCm: phoneDistanceCm,
      simulatedDistanceM: simulatedDistanceM,
      creditCardWidthMm: creditCardWidthMm,
      creditCardWidthPixels: creditCardWidthPixels,
      useProximitySensor: false,
      enableVoiceInstructions: true,
    );
    
    // Set initial test type if provided
    if (widget.initialTestType != null) {
      currentTestType = widget.initialTestType!;
      currentPhase = 'test'; // Skip calibration and instructions, go directly to test
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const AppHeader(title: 'Vision Test'),
            Expanded(
              child: _buildCurrentPhase(),
            ),
            const AppFooter(currentIndex: 2),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentPhase() {
    switch (currentPhase) {
      case 'calibration':
        return _buildCalibrationStep();
      case 'instructions':
        return _buildInstructions();
      case 'test':
        return _buildCurrentTest();
      case 'switch_eye':
        return _buildSwitchEyeScreen();
      case 'results':
        return _buildResults();
      default:
        return _buildInstructions();
    }
  }

  Widget _buildCurrentTest() {
    switch (currentTestType) {
      case 'visual_acuity':
        return _buildSnellenTest();
      case 'astigmatism':
        return _buildAstigmatismTest();
      case 'near_vision':
        return _buildNearVisionTest();
      case 'color_vision':
        return _buildColorVisionTest();
      default:
        return _buildSnellenTest();
    }
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
      child: Column(
        children: [
          Row(
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
                    'Snellen Visual Acuity Test',
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
          if (currentPhase == 'test') ...[
          const SizedBox(height: 20),
            Text(
              'Testing ${currentEye == 'left' ? 'Left' : 'Right'} Eye',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Line ${currentLine + 1} of ${snellenLines.length}',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCalibrationStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 40),
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xFF10B2D0).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(60),
            ),
            child: const Icon(
              Icons.straighten,
              size: 60,
              color: Color(0xFF10B2D0),
            ),
          ),
          const SizedBox(height: 30),
          const Text(
            'Calibration Step',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111718),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          const Text(
            'To ensure accurate test results, we need to calibrate your phone screen.',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF618389),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFB),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Column(
              children: [
                const Text(
                  'Credit Card Calibration',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111718),
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  '1. Get a standard credit card (8.56 cm wide)\n2. Place it on the outline below\n3. Adjust the slider until it matches perfectly',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF618389),
                  ),
                ),
                const SizedBox(height: 20),
                // Credit card outline
                Container(
                  width: 200,
                  height: 126,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFF10B2D0), width: 2),
                  ),
                  child: const Center(
                    child: Text(
                      'Credit Card\nOutline\n8.56 cm',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF10B2D0),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Scale slider
                Column(
                  children: [
          Text(
                      'Width: ${creditCardWidthPixels.toStringAsFixed(1)} pixels',
            style: const TextStyle(
              fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF111718),
                      ),
                    ),
                    Slider(
                      value: creditCardWidthPixels,
                      min: 100,
                      max: 400,
                      divisions: 30,
                      onChanged: (value) {
                        setState(() {
                          creditCardWidthPixels = value;
                          pixelToMmRatio = creditCardWidthMm / value;
                        });
                      },
                      activeColor: const Color(0xFF10B2D0),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  currentPhase = 'instructions';
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10B2D0),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Continue to Instructions',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildInstructions() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 40),
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xFF10B2D0).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(60),
            ),
            child: const Icon(
              Icons.visibility,
              size: 60,
              color: Color(0xFF10B2D0),
            ),
          ),
          const SizedBox(height: 30),
          const Text(
            'Comprehensive Vision Test',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111718),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFB),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.medical_services,
                  size: 60,
                  color: Color(0xFF10B2D0),
                ),
                const SizedBox(height: 15),
                const Text(
                  'Test Overview',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111718),
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  'This comprehensive test includes:\n\n• Visual Acuity (Snellen chart)\n• Astigmatism detection\n• Near vision assessment\n• Color vision testing\n\nEach test will be performed on both eyes separately.',
                  style: TextStyle(
                    fontSize: 14,
              color: Color(0xFF618389),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFB),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.person,
                  size: 60,
                  color: Color(0xFF10B2D0),
                ),
                const SizedBox(height: 15),
                const Text(
                  'Instructions',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111718),
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  '1. Hold your phone at arm\'s length (about 40 cm away)\n2. Cover your LEFT eye with your hand\n3. Keep your RIGHT eye open\n4. Follow the on-screen instructions for each test\n5. Tap to select your answers',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF618389),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Navigate to test selection screen
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const VisionTestSelectionScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10B2D0),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Start Comprehensive Test',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSnellenTest() {
    if (currentLine >= snellenLines.length) {
      return _buildTestComplete();
    }

    final currentLineData = snellenLines[currentLine];
    final letterToShow = currentLineData['letters'][currentLetterIndex] as String;
    final letterSizePixels = _calculateLetterSizePixels(currentLineData['sizeMm'] as double);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 20),
          // Progress bar
          LinearProgressIndicator(
            value: (currentLine + 1) / snellenLines.length,
            backgroundColor: const Color(0xFFF0F4F4),
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF10B2D0)),
          ),
          const SizedBox(height: 40),
          // Letter display - responsive container
          Container(
            constraints: BoxConstraints(
              minWidth: 200,
              maxWidth: MediaQuery.of(context).size.width * 0.9,
              minHeight: 200,
              maxHeight: MediaQuery.of(context).size.height * 0.5,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Center(
              child: FittedBox(
                fit: BoxFit.contain,
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.8,
                    maxHeight: MediaQuery.of(context).size.height * 0.4,
                  ),
              child: Text(
                    letterToShow,
                style: TextStyle(
                      fontSize: letterSizePixels,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF111718),
                ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.visible,
              ),
            ),
          ),
            ),
          ),
          const SizedBox(height: 40),
          const Text(
            'Tap the letter you see on the screen',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Color(0xFF111718),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          // Letter selection grid
          _buildLetterGrid(letterToShow),
          const SizedBox(height: 20),
          // Retry button if wrong answer
          if (isRetry) ...[
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isRetry = false;
                  selectedLetter = null;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6B6B),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Try Again',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
          // Return button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Back'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF618389),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
              Text(
                'Line ${currentLine + 1} of ${snellenLines.length}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF618389),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLetterGrid(String correctLetter) {
    // Shuffle the letters but ensure the correct one is included
    final letters = List<String>.from(availableLetters);
    letters.shuffle();
    
    // Ensure correct letter is in the grid
    if (!letters.contains(correctLetter)) {
      letters[0] = correctLetter;
    }

    return Wrap(
      spacing: 15,
      runSpacing: 15,
      children: letters.map((letter) {
        final isSelected = selectedLetter == letter;
        final isCorrect = letter == correctLetter;
        
        return GestureDetector(
          onTap: () => _handleLetterSelection(letter, correctLetter),
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: isSelected 
                  ? (isCorrect ? const Color(0xFF4ECDC4) : const Color(0xFFFF6B6B))
                  : const Color(0xFFF0F4F4),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: isSelected 
                    ? (isCorrect ? const Color(0xFF4ECDC4) : const Color(0xFFFF6B6B))
                    : const Color(0xFFDBE4E6),
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Center(
              child: Text(
                letter,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isSelected 
                      ? Colors.white
                      : const Color(0xFF111718),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSwitchEyeScreen() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 40),
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xFF10B2D0).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(60),
            ),
            child: const Icon(
              Icons.swap_horiz,
              size: 60,
              color: Color(0xFF10B2D0),
            ),
          ),
          const SizedBox(height: 30),
          const Text(
            'Switch Eye',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111718),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFB),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.person,
                  size: 60,
                  color: Color(0xFF10B2D0),
                ),
                const SizedBox(height: 15),
                const Text(
                  'Now test your LEFT eye',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111718),
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  '1. Cover your RIGHT eye with your hand\n2. Keep your LEFT eye open\n3. Repeat all tests for your left eye\n4. When ready, tap "Continue"',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF618389),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  currentPhase = 'test';
                  currentEye = 'left';
                  currentTestType = 'visual_acuity'; // Reset to first test
                  currentTest = 0;
                  currentLine = 0;
                  currentLetterIndex = 0;
                  selectedLetter = null;
                  isRetry = false;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10B2D0),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Continue to Test Selection',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildTestComplete() {
    // This method should rarely be called now since we auto-proceed
    // But if it is called, show a simple completion message
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: const Color(0xFF4ECDC4).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(50),
            ),
            child: const Icon(
              Icons.check_circle,
              size: 50,
              color: Color(0xFF4ECDC4),
            ),
          ),
          const SizedBox(height: 30),
          Text(
            '${_getTestTypeName()} Complete!',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111718),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          const Text(
            'Moving to next test...',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF618389),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                _nextTest();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10B2D0),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Continue to ${_getNextTestTypeName()}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  String _getTestTypeName() {
    switch (currentTestType) {
      case 'visual_acuity':
        return 'Visual Acuity Test';
      case 'astigmatism':
        return 'Astigmatism Test';
      case 'near_vision':
        return 'Near Vision Test';
      case 'color_vision':
        return 'Color Vision Test';
      default:
        return 'Test';
    }
  }

  String _getNextTestTypeName() {
    final testTypes = ['visual_acuity', 'astigmatism', 'near_vision', 'color_vision'];
    final currentIndex = testTypes.indexOf(currentTestType);
    if (currentIndex < testTypes.length - 1) {
      final nextType = testTypes[currentIndex + 1];
      switch (nextType) {
        case 'visual_acuity':
          return 'Visual Acuity Test';
        case 'astigmatism':
          return 'Astigmatism Test';
        case 'near_vision':
          return 'Near Vision Test';
        case 'color_vision':
          return 'Color Vision Test';
        default:
          return 'Next Test';
      }
    }
    return 'Next Test';
  }


  void _nextTest() {
    final testTypes = ['visual_acuity', 'astigmatism', 'near_vision', 'color_vision'];
    final currentIndex = testTypes.indexOf(currentTestType);
    
    if (currentIndex < testTypes.length - 1) {
      final nextTestType = testTypes[currentIndex + 1];
      setState(() {
        currentTestType = nextTestType;
        currentTest = 0;
        currentLine = 0;
        currentLetterIndex = 0;
        selectedLetter = null;
        isRetry = false;
      });
    } else {
      // All tests complete, navigate to results screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const VisionTestResultsScreen(),
        ),
      );
    }
  }

  // Helper method to calculate letter size in pixels based on Snellen formula
  double _calculateLetterSizePixels(double sizeMm) {
    // Snellen formula: LetterHeight = 2 × Distance × tan(θ/2)
    // Where θ = 5 arcminutes (Snellen standard letter angle)
    // Distance = 3m (simulated) or 40cm (actual)
    
    const double thetaRadians = (5.0 / 60.0) * (math.pi / 180.0); // Convert 5 arcminutes to radians
    const double simulatedDistanceMm = 3000.0; // 3 meters in mm
    
    // Calculate the actual letter height needed for 3m distance
    final double actualLetterHeightMm = 2.0 * simulatedDistanceMm * math.tan(thetaRadians / 2.0);
    
    // Scale the letter based on the acuity level (sizeMm represents the standard size for that acuity)
    final double scaleFactor = sizeMm / actualLetterHeightMm;
    final double scaledLetterHeightMm = actualLetterHeightMm * scaleFactor;
    
    // Convert to pixels using our calibration ratio
    final double sizePixels = scaledLetterHeightMm / pixelToMmRatio;
    
    // Get screen dimensions for better sizing
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    // Calculate maximum size based on container constraints
    final double maxWidth = screenWidth * 0.8; // 80% of screen width
    final double maxHeight = screenHeight * 0.4; // 40% of screen height
    final double maxSize = math.min(maxWidth, maxHeight) * 0.8; // 80% of container size
    
    // Ensure minimum size for visibility and maximum for screen constraints
    return math.max(math.min(sizePixels, maxSize), 30.0);
  }

  // Handle letter selection
  void _handleLetterSelection(String selected, String correct) {
    setState(() {
      selectedLetter = selected;
    });

    if (selected == correct) {
      // Correct answer - move to next letter or line
      _handleCorrectAnswer();
    } else {
      // Wrong answer - record and continue to next letter
      _recordWrongAnswer();
      _handleCorrectAnswer(); // Continue to next letter/line
    }
  }

  void _recordWrongAnswer() {
    // Record wrong answer for analytics/tracking
    // You can add more detailed tracking here if needed
    // For now, we just continue to the next letter/line
  }

  void _handleCorrectAnswer() {
    setState(() {
      if (currentLetterIndex < (snellenLines[currentLine]['letters'] as List).length - 1) {
        // More letters in this line
        currentLetterIndex++;
        selectedLetter = null;
        isRetry = false;
      } else {
        // Line complete - move to next line
        _recordBestLine();
        currentLine++;
        currentLetterIndex = 0;
        selectedLetter = null;
        isRetry = false;
        
        // Check if we've completed all lines for this test type
        if (currentLine >= snellenLines.length) {
          // Visual acuity test complete, move to next test or switch eyes
          if (currentTestType == 'visual_acuity') {
            if (currentEye == 'right') {
              // Right eye complete, switch to left eye
              currentPhase = 'switch_eye';
            } else {
              // Left eye complete, move to next test type
              _nextTest();
            }
          } else {
            // Other test types, move to next test or switch eyes
            if (currentEye == 'right') {
              currentPhase = 'switch_eye';
            } else {
              _nextTest();
            }
          }
        }
      }
    });
  }

  void _recordBestLine() {
    final acuity = snellenLines[currentLine]['acuity'] as String;
    if (currentEye == 'right') {
      rightEyeResults = TestResults(
        acuityScore: acuity,
        astigmatismAxis: rightEyeResults.astigmatismAxis,
        astigmatismCyl: rightEyeResults.astigmatismCyl,
        colorVisionResult: rightEyeResults.colorVisionResult,
        nearVision: rightEyeResults.nearVision,
        astigmatismTests: rightEyeResults.astigmatismTests,
        colorVisionTests: rightEyeResults.colorVisionTests,
        nearVisionTests: rightEyeResults.nearVisionTests,
      );
    } else {
      leftEyeResults = TestResults(
        acuityScore: acuity,
        astigmatismAxis: leftEyeResults.astigmatismAxis,
        astigmatismCyl: leftEyeResults.astigmatismCyl,
        colorVisionResult: leftEyeResults.colorVisionResult,
        nearVision: leftEyeResults.nearVision,
        astigmatismTests: leftEyeResults.astigmatismTests,
        colorVisionTests: leftEyeResults.colorVisionTests,
        nearVisionTests: leftEyeResults.nearVisionTests,
      );
    }
  }

  // Astigmatism Test Methods
  Widget _buildAstigmatismTest() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Text(
            'Astigmatism Test - ${_getAstigmatismTestName()}',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111718),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            'Testing ${currentEye == 'left' ? 'Left' : 'Right'} Eye',
            style: const TextStyle(
              fontSize: 18,
              color: Color(0xFF618389),
            ),
          ),
          const SizedBox(height: 30),
          _buildAstigmatismChart(),
          const SizedBox(height: 30),
          const Text(
            'Tap the line that appears darkest or clearest',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF111718),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          // Return button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Back'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF618389),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
              Text(
                'Test ${currentTest + 1} of 3',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF618389),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getAstigmatismTestName() {
    switch (currentTest) {
      case 0:
        return 'Fan Chart';
      case 1:
        return 'Clock Dial';
      case 2:
        return 'Parallel Lines';
      default:
        return 'Fan Chart';
    }
  }

  Widget _buildAstigmatismChart() {
    switch (currentTest) {
      case 0:
        return _buildFanChart();
      case 1:
        return _buildClockDial();
      case 2:
        return _buildParallelLines();
      default:
        return _buildFanChart();
    }
  }

  Widget _buildFanChart() {
    return Container(
      width: 300,
      height: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: CustomPaint(
        painter: FanChartPainter(),
        child: GestureDetector(
          onTapDown: (details) => _handleFanChartTap(details),
          child: Container(),
        ),
      ),
    );
  }

  Widget _buildClockDial() {
    return Container(
      width: 300,
      height: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: CustomPaint(
        painter: ClockDialPainter(),
        child: GestureDetector(
          onTapDown: (details) => _handleClockDialTap(details),
          child: Container(),
        ),
      ),
    );
  }

  Widget _buildParallelLines() {
    return Container(
      width: 300,
            height: 200,
            decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: CustomPaint(
        painter: ParallelLinesPainter(),
        child: GestureDetector(
          onTapDown: (details) => _handleParallelLinesTap(details),
          child: Container(),
        ),
      ),
    );
  }

  void _handleFanChartTap(TapDownDetails details) {
    // Calculate which line was tapped
    final center = const Offset(150, 150);
    final tapPoint = details.localPosition;
    final angle = math.atan2(tapPoint.dy - center.dy, tapPoint.dx - center.dx);
    final degrees = (angle * 180 / math.pi + 360) % 360;
    final lineNumber = (degrees / 15).round() % 24; // 24 lines, 15 degrees apart
    
    _recordAstigmatismResult('fan_chart', lineNumber, lineNumber, true, 0.8);
    _nextAstigmatismTest();
  }

  void _handleClockDialTap(TapDownDetails details) {
    // Calculate which hour was tapped
    final center = const Offset(150, 150);
    final tapPoint = details.localPosition;
    final angle = math.atan2(tapPoint.dy - center.dy, tapPoint.dx - center.dx);
    final degrees = (angle * 180 / math.pi + 90) % 360; // Start from 12 o'clock
    final hour = (degrees / 30).round() % 12; // 12 hours, 30 degrees apart
    
    _recordAstigmatismResult('clock_dial', hour, hour, true, 0.8);
    _nextAstigmatismTest();
  }

  void _handleParallelLinesTap(TapDownDetails details) {
    // Determine which set of lines was tapped
    final y = details.localPosition.dy;
    final setNumber = y < 100 ? 0 : 1; // Top or bottom set
    
    _recordAstigmatismResult('parallel_lines', setNumber, setNumber, true, 0.8);
    _nextAstigmatismTest();
  }

  void _recordAstigmatismResult(String testType, int selectedLine, int correctLine, bool isCorrect, double confidence) {
    final result = AstigmatismTestResult(
      testType: testType,
      selectedLine: selectedLine,
      correctLine: correctLine,
      isCorrect: isCorrect,
      confidence: confidence,
    );

    if (currentEye == 'right') {
      rightEyeResults = TestResults(
        acuityScore: rightEyeResults.acuityScore,
        astigmatismAxis: rightEyeResults.astigmatismAxis,
        astigmatismCyl: rightEyeResults.astigmatismCyl,
        colorVisionResult: rightEyeResults.colorVisionResult,
        nearVision: rightEyeResults.nearVision,
        astigmatismTests: [...rightEyeResults.astigmatismTests, result],
        colorVisionTests: rightEyeResults.colorVisionTests,
        nearVisionTests: rightEyeResults.nearVisionTests,
      );
    } else {
      leftEyeResults = TestResults(
        acuityScore: leftEyeResults.acuityScore,
        astigmatismAxis: leftEyeResults.astigmatismAxis,
        astigmatismCyl: leftEyeResults.astigmatismCyl,
        colorVisionResult: leftEyeResults.colorVisionResult,
        nearVision: leftEyeResults.nearVision,
        astigmatismTests: [...leftEyeResults.astigmatismTests, result],
        colorVisionTests: leftEyeResults.colorVisionTests,
        nearVisionTests: leftEyeResults.nearVisionTests,
      );
    }
  }

  void _nextAstigmatismTest() {
    setState(() {
      currentTest++;
      if (currentTest >= 3) {
        // All astigmatism tests complete
        if (currentEye == 'right') {
          currentPhase = 'switch_eye';
        } else {
          // Left eye complete, move to next test type
          _nextTest();
        }
      }
    });
  }

  // Near Vision Test Methods
  Widget _buildNearVisionTest() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 20),
          const Text(
            'Near Vision Test',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111718),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            'Testing ${currentEye == 'left' ? 'Left' : 'Right'} Eye',
            style: const TextStyle(
              fontSize: 18,
              color: Color(0xFF618389),
            ),
          ),
          const SizedBox(height: 30),
          _buildNearVisionText(),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => _recordNearVisionResult(true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4ECDC4),
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
                child: const Text('Yes, I can read this'),
              ),
              ElevatedButton(
                onPressed: () => _recordNearVisionResult(false),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6B6B),
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
                child: const Text('No, I cannot read this'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Return button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Back'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF618389),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
              Text(
                'Test ${currentTest + 1} of 3',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF618389),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNearVisionText() {
    final textSizes = ['N12', 'N10', 'N8', 'N6', 'N5'];
    final currentSize = textSizes[math.min(currentTest, textSizes.length - 1)];
    final fontSize = _getNearVisionFontSize(currentSize);
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
        color: Colors.white,
              borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
              child: Text(
        'The quick brown fox jumps over the lazy dog. This is a standard reading test to check your near vision ability.',
        style: TextStyle(
          fontSize: fontSize,
          color: const Color(0xFF111718),
          height: 1.5,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  double _getNearVisionFontSize(String size) {
    switch (size) {
      case 'N12': return 24.0;
      case 'N10': return 20.0;
      case 'N8': return 16.0;
      case 'N6': return 12.0;
      case 'N5': return 10.0;
      default: return 16.0;
    }
  }

  void _recordNearVisionResult(bool canRead) {
    final textSizes = ['N12', 'N10', 'N8', 'N6', 'N5'];
    final currentSize = textSizes[math.min(currentTest, textSizes.length - 1)];
    final fontSize = _getNearVisionFontSize(currentSize);
    
    final result = NearVisionTestResult(
      textSize: currentSize,
      canRead: canRead,
      textContent: 'The quick brown fox jumps over the lazy dog.',
      fontSize: fontSize,
    );

    if (currentEye == 'right') {
      rightEyeResults = TestResults(
        acuityScore: rightEyeResults.acuityScore,
        astigmatismAxis: rightEyeResults.astigmatismAxis,
        astigmatismCyl: rightEyeResults.astigmatismCyl,
        colorVisionResult: rightEyeResults.colorVisionResult,
        nearVision: canRead ? currentSize : rightEyeResults.nearVision,
        astigmatismTests: rightEyeResults.astigmatismTests,
        colorVisionTests: rightEyeResults.colorVisionTests,
        nearVisionTests: [...rightEyeResults.nearVisionTests, result],
      );
    } else {
      leftEyeResults = TestResults(
        acuityScore: leftEyeResults.acuityScore,
        astigmatismAxis: leftEyeResults.astigmatismAxis,
        astigmatismCyl: leftEyeResults.astigmatismCyl,
        colorVisionResult: leftEyeResults.colorVisionResult,
        nearVision: canRead ? currentSize : leftEyeResults.nearVision,
        astigmatismTests: leftEyeResults.astigmatismTests,
        colorVisionTests: leftEyeResults.colorVisionTests,
        nearVisionTests: [...leftEyeResults.nearVisionTests, result],
      );
    }

    setState(() {
      currentTest++;
      if (currentTest >= 5 || !canRead) {
        // All near vision tests complete or user can't read current size
        if (currentEye == 'right') {
          currentPhase = 'switch_eye';
        } else {
          // Left eye complete, move to next test type
          _nextTest();
        }
      }
    });
  }

  // Color Vision Test Methods
  Widget _buildColorVisionTest() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 20),
          const Text(
            'Color Vision Test',
            style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111718),
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            'Testing ${currentEye == 'left' ? 'Left' : 'Right'} Eye',
            style: const TextStyle(
              fontSize: 18,
              color: Color(0xFF618389),
            ),
          ),
          const SizedBox(height: 30),
          _buildIshiharaPlate(),
          const SizedBox(height: 30),
          const Text(
            'What number do you see in the circle?',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF111718),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          _buildNumberGrid(),
          const SizedBox(height: 20),
          // Return button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Back'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF618389),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
              Text(
                'Test ${currentTest + 1} of 3',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF618389),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIshiharaPlate() {
    return Container(
      width: 250,
      height: 250,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(125),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: CustomPaint(
        painter: IshiharaPlatePainter(plateNumber: currentTest + 1),
        child: Container(),
      ),
    );
  }

  Widget _buildNumberGrid() {
    final numbers = ['12', '8', '6', '3', '5', '2', '9', '7', '1', '4'];

    return Wrap(
      spacing: 15,
      runSpacing: 15,
      children: numbers.map((number) {
        return GestureDetector(
          onTap: () => _handleColorVisionSelection(number),
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F4F4),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: const Color(0xFFDBE4E6)),
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111718),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  void _handleColorVisionSelection(String selectedNumber) {
    final correctAnswers = ['12', '8', '6', '3', '5']; // Correct answers for plates 1-5
    final correctAnswer = correctAnswers[math.min(currentTest, correctAnswers.length - 1)];
    final isCorrect = selectedNumber == correctAnswer;
    
    final result = ColorVisionTestResult(
      plateNumber: currentTest + 1,
      userAnswer: selectedNumber,
      correctAnswer: correctAnswer,
      isCorrect: isCorrect,
      plateType: 'ishihara',
    );

    if (currentEye == 'right') {
      rightEyeResults = TestResults(
        acuityScore: rightEyeResults.acuityScore,
        astigmatismAxis: rightEyeResults.astigmatismAxis,
        astigmatismCyl: rightEyeResults.astigmatismCyl,
        colorVisionResult: isCorrect ? 'normal' : 'deuteranopia',
        nearVision: rightEyeResults.nearVision,
        astigmatismTests: rightEyeResults.astigmatismTests,
        colorVisionTests: [...rightEyeResults.colorVisionTests, result],
        nearVisionTests: rightEyeResults.nearVisionTests,
      );
    } else {
      leftEyeResults = TestResults(
        acuityScore: leftEyeResults.acuityScore,
        astigmatismAxis: leftEyeResults.astigmatismAxis,
        astigmatismCyl: leftEyeResults.astigmatismCyl,
        colorVisionResult: isCorrect ? 'normal' : 'deuteranopia',
        nearVision: leftEyeResults.nearVision,
        astigmatismTests: leftEyeResults.astigmatismTests,
        colorVisionTests: [...leftEyeResults.colorVisionTests, result],
        nearVisionTests: leftEyeResults.nearVisionTests,
      );
    }

    setState(() {
      currentTest++;
      if (currentTest >= 5) {
        // All color vision tests complete
        if (currentEye == 'right') {
          currentPhase = 'switch_eye';
        } else {
          // Left eye complete, move to next test type
          _nextTest();
        }
      }
    });
  }

  Widget _buildResults() {
    // Calculate complete results
    completeResults = CompleteTestResults(
      userId: 'demo_user',
      timestamp: DateTime.now(),
      rightEye: rightEyeResults,
      leftEye: leftEyeResults,
      estimatedRx: RefractionEstimator.estimatePrescription(rightEyeResults, leftEyeResults),
      confidenceScore: 85,
      recommendations: _generateRecommendations(),
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 20),
          // Celebration header
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF4ECDC4), Color(0xFF44A08D)],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4ECDC4).withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                SizedBox(
            width: 120,
            height: 120,
                  child: ProfessionalIllustrations.successCelebration(
                    primaryColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Wahoo! You completed the test!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'An eye doctor will review your results in about 48 hours.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          // Results summary
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                const Text(
                  'Your Vision Test Results',
                style: TextStyle(
                    fontSize: 20,
                  fontWeight: FontWeight.bold,
                    color: Color(0xFF111718),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildResultMetric('Confidence', '${completeResults?.confidenceScore ?? 85}%', Icons.analytics),
                    _buildResultMetric('Right Eye', rightEyeResults.acuityScore, Icons.visibility),
                    _buildResultMetric('Left Eye', leftEyeResults.acuityScore, Icons.visibility),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _buildEyeResults('Right Eye', rightEyeResults),
          const SizedBox(height: 16),
          _buildEyeResults('Left Eye', leftEyeResults),
          const SizedBox(height: 20),
          _buildPrescriptionCard(),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3CD),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFFFEAA7)),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  color: Color(0xFF856404),
                  size: 20,
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'These are preliminary results. Please consult an eye care professional for accurate diagnosis and prescription.',
            style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF856404),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
              onPressed: () {
                setState(() {
                      currentPhase = 'calibration';
                      currentEye = 'right';
                      currentTestType = 'visual_acuity';
                  currentTest = 0;
                      currentLine = 0;
                  currentLetterIndex = 0;
                      selectedLetter = null;
                      isRetry = false;
                      // Reset results
                      rightEyeResults = TestResults(
                        acuityScore: '20/20',
                        astigmatismAxis: 0,
                        astigmatismCyl: 0.0,
                        colorVisionResult: 'normal',
                        nearVision: 'N8',
                        astigmatismTests: [],
                        colorVisionTests: [],
                        nearVisionTests: [],
                      );
                      leftEyeResults = TestResults(
                        acuityScore: '20/20',
                        astigmatismAxis: 0,
                        astigmatismCyl: 0.0,
                        colorVisionResult: 'normal',
                        nearVision: 'N8',
                        astigmatismTests: [],
                        colorVisionTests: [],
                        nearVisionTests: [],
                      );
                });
              },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    side: const BorderSide(color: Color(0xFF10B2D0)),
                  ),
                  child: const Text(
                    'Retake Test',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF10B2D0),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const VisionTestResultsScreen(),
                    ),
                  );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10B2D0),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                    'Continue',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildEyeResults(String eyeName, TestResults results) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFB),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFDBE4E6)),
        ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            eyeName,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111718),
            ),
          ),
          const SizedBox(height: 15),
          _buildResultRow('Visual Acuity', results.acuityScore, Icons.visibility),
          _buildResultRow('Astigmatism Axis', '${results.astigmatismAxis}°', Icons.rotate_right),
          _buildResultRow('Color Vision', results.colorVisionResult, Icons.palette),
          _buildResultRow('Near Vision', results.nearVision, Icons.text_fields),
        ],
      ),
    );
  }

  Widget _buildPrescriptionCard() {
    if (completeResults == null) return const SizedBox.shrink();
    
    return Container(
      padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
        color: const Color(0xFF10B2D0).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFF10B2D0)),
      ),
      child: Column(
        children: [
          const Text(
            'Estimated Prescription',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111718),
            ),
          ),
          const SizedBox(height: 15),
          Text(
            completeResults!.estimatedRx.formattedPrescription,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF10B2D0),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'SPH: ${completeResults!.estimatedRx.sph >= 0 ? '+' : ''}${completeResults!.estimatedRx.sph.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 16, color: Color(0xFF111718)),
          ),
          Text(
            'CYL: ${completeResults!.estimatedRx.cyl >= 0 ? '+' : ''}${completeResults!.estimatedRx.cyl.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 16, color: Color(0xFF111718)),
          ),
          Text(
            'Axis: ${completeResults!.estimatedRx.axis}°',
            style: const TextStyle(fontSize: 16, color: Color(0xFF111718)),
          ),
        ],
      ),
    );
  }

  List<String> _generateRecommendations() {
    final recommendations = <String>[];
    
    // Visual acuity recommendations
    if (rightEyeResults.acuityScore != '20/20' || leftEyeResults.acuityScore != '20/20') {
      recommendations.add('Consider getting a comprehensive eye exam for accurate prescription');
    }
    
    // Astigmatism recommendations
    if (rightEyeResults.astigmatismCyl.abs() > 0.5 || leftEyeResults.astigmatismCyl.abs() > 0.5) {
      recommendations.add('Astigmatism detected - consult an eye care professional');
    }
    
    // Color vision recommendations
    if (rightEyeResults.colorVisionResult != 'normal' || leftEyeResults.colorVisionResult != 'normal') {
      recommendations.add('Color vision deficiency detected - consider professional evaluation');
    }
    
    // Near vision recommendations
    if (rightEyeResults.nearVision == 'N12' || leftEyeResults.nearVision == 'N12') {
      recommendations.add('Near vision may need correction - consider reading glasses');
    }
    
    if (recommendations.isEmpty) {
      recommendations.add('Your vision appears to be within normal ranges');
    }
    
    return recommendations;
  }

  Widget _buildResultRow(String title, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF10B2D0), size: 20),
          const SizedBox(width: 10),
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
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF10B2D0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultMetric(String title, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF10B2D0), size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF111718),
          ),
        ),
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF618389),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavigation(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFDBE4E6)),
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
          currentIndex: 1,
          onTap: (index) {
            if (index == 0) {
              Navigator.pop(context);
            } else if (index == 2) {
              Navigator.pushNamed(context, '/exercises');
            } else if (index == 3) {
              Navigator.pushNamed(context, '/chat');
            } else if (index == 4) {
              Navigator.pushNamed(context, '/profile');
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
}