import 'package:flutter/material.dart';
import 'dart:math' as math;
// import 'package:flutter_tts/flutter_tts.dart';

class VisionTestScreen extends StatefulWidget {
  const VisionTestScreen({super.key});

  @override
  State<VisionTestScreen> createState() => _VisionTestScreenState();
}

class _VisionTestScreenState extends State<VisionTestScreen> {
  // Test phases
  String currentPhase = 'calibration'; // 'calibration', 'instructions', 'test', 'switch_eye', 'results'
  String currentEye = 'right'; // Start with right eye
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
  
  // Test results
  Map<String, dynamic> testResults = {
    'leftEye': {
      'visualAcuity': '20/20',
      'bestLine': 0,
    },
    'rightEye': {
      'visualAcuity': '20/20', 
      'bestLine': 0,
    },
    'confidence': 85,
  };
  
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: _buildCurrentPhase(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(context),
    );
  }

  Widget _buildCurrentPhase() {
    switch (currentPhase) {
      case 'calibration':
        return _buildCalibrationStep();
      case 'instructions':
        return _buildInstructions();
      case 'test':
        return _buildSnellenTest();
      case 'switch_eye':
        return _buildSwitchEyeScreen();
      case 'results':
        return _buildResults();
      default:
        return _buildInstructions();
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
            'Snellen Visual Acuity Test',
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
                  'Instructions',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111718),
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  '1. Hold your phone at arm\'s length (about 40 cm away)\n2. Cover your LEFT eye with your hand\n3. Keep your RIGHT eye open\n4. When ready, tap "Start Test" or say "Start"',
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
                'Start Test',
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
                  '1. Cover your RIGHT eye with your hand\n2. Keep your LEFT eye open\n3. When ready, tap "Continue"',
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
                'Continue',
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
            '${currentEye == 'left' ? 'Left' : 'Right'} Eye Test Complete!',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111718),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          if (currentEye == 'right') ...[
            const Text(
              'Now let\'s test your left eye.',
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
                  setState(() {
                    currentPhase = 'switch_eye';
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
                  'Test Left Eye',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ] else ...[
            const Text(
              'All tests completed! Let\'s see your results.',
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
                  setState(() {
                    currentPhase = 'results';
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4ECDC4),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'View Results',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
          const SizedBox(height: 20),
        ],
      ),
    );
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
      // Wrong answer - show retry option
      setState(() {
        isRetry = true;
      });
    }
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
      }
    });
  }

  void _recordBestLine() {
    final acuity = snellenLines[currentLine]['acuity'] as String;
    if (currentEye == 'right') {
      testResults['rightEye']['visualAcuity'] = acuity;
      testResults['rightEye']['bestLine'] = currentLine;
    } else {
      testResults['leftEye']['visualAcuity'] = acuity;
      testResults['leftEye']['bestLine'] = currentLine;
    }
  }

  Widget _buildResults() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 20),
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
            'Vision Test Results',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111718),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            'Confidence Score: ${testResults['confidence']}%',
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF618389),
            ),
          ),
          const SizedBox(height: 30),
          _buildEyeResults('Right Eye', testResults['rightEye']),
          const SizedBox(height: 20),
          _buildEyeResults('Left Eye', testResults['leftEye']),
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3CD),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFFFEAA7)),
            ),
            child: const Text(
              'Great job! These results will be saved. Move to the next test.',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF856404),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  currentPhase = 'calibration';
                  currentEye = 'right';
                  currentLine = 0;
                  currentLetterIndex = 0;
                  selectedLetter = null;
                  isRetry = false;
                  // Reset results
                  testResults = {
                    'leftEye': {'visualAcuity': '20/20', 'bestLine': 0},
                    'rightEye': {'visualAcuity': '20/20', 'bestLine': 0},
                    'confidence': 85,
                  };
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
                'Take Test Again',
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

  Widget _buildEyeResults(String eyeName, Map<String, dynamic> results) {
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
          _buildResultRow('Visual Acuity', results['visualAcuity'], Icons.visibility),
          _buildResultRow('Best Line', 'Line ${results['bestLine'] + 1}', Icons.format_list_numbered),
        ],
      ),
    );
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