// import 'dart:math' as math;

/// Comprehensive vision test model supporting all test types
class ComprehensiveVisionTest {
  final String id;
  final String userId;
  final DateTime timestamp;
  final String eye; // 'right' or 'left'
  final TestResults results;
  final bool isCompleted;

  ComprehensiveVisionTest({
    required this.id,
    required this.userId,
    required this.timestamp,
    required this.eye,
    required this.results,
    this.isCompleted = false,
  });

  factory ComprehensiveVisionTest.fromMap(Map<String, dynamic> map) {
    return ComprehensiveVisionTest(
      id: map['id'] ?? '',
      userId: map['user_id'] ?? '',
      timestamp: DateTime.parse(map['timestamp'] ?? DateTime.now().toIso8601String()),
      eye: map['eye'] ?? 'right',
      results: TestResults.fromMap(map['results'] ?? {}),
      isCompleted: map['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'timestamp': timestamp.toIso8601String(),
      'eye': eye,
      'results': results.toMap(),
      'isCompleted': isCompleted,
    };
  }
}

/// Complete test results for both eyes
class CompleteTestResults {
  final String userId;
  final DateTime timestamp;
  final TestResults rightEye;
  final TestResults leftEye;
  final EstimatedPrescription estimatedRx;
  final int confidenceScore;
  final List<String> recommendations;

  CompleteTestResults({
    required this.userId,
    required this.timestamp,
    required this.rightEye,
    required this.leftEye,
    required this.estimatedRx,
    required this.confidenceScore,
    required this.recommendations,
  });

  factory CompleteTestResults.fromMap(Map<String, dynamic> map) {
    return CompleteTestResults(
      userId: map['user_id'] ?? '',
      timestamp: DateTime.parse(map['timestamp'] ?? DateTime.now().toIso8601String()),
      rightEye: TestResults.fromMap(map['right_eye'] ?? {}),
      leftEye: TestResults.fromMap(map['left_eye'] ?? {}),
      estimatedRx: EstimatedPrescription.fromMap(map['estimated_rx'] ?? {}),
      confidenceScore: map['confidence_score'] ?? 0,
      recommendations: List<String>.from(map['recommendations'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'timestamp': timestamp.toIso8601String(),
      'right_eye': rightEye.toMap(),
      'left_eye': leftEye.toMap(),
      'estimated_rx': estimatedRx.toMap(),
      'confidence_score': confidenceScore,
      'recommendations': recommendations,
    };
  }
}

/// Individual test results for one eye
class TestResults {
  final String acuityScore; // e.g., "20/25"
  final int astigmatismAxis; // 0-180 degrees
  final double astigmatismCyl; // cylinder power
  final String colorVisionResult; // "normal", "deuteranopia", etc.
  final String nearVision; // e.g., "N8"
  final List<AstigmatismTestResult> astigmatismTests;
  final List<ColorVisionTestResult> colorVisionTests;
  final List<NearVisionTestResult> nearVisionTests;

  TestResults({
    required this.acuityScore,
    required this.astigmatismAxis,
    required this.astigmatismCyl,
    required this.colorVisionResult,
    required this.nearVision,
    required this.astigmatismTests,
    required this.colorVisionTests,
    required this.nearVisionTests,
  });

  factory TestResults.fromMap(Map<String, dynamic> map) {
    return TestResults(
      acuityScore: map['acuity_score'] ?? '20/20',
      astigmatismAxis: map['astigmatism_axis'] ?? 0,
      astigmatismCyl: (map['astigmatism_cyl'] ?? 0.0).toDouble(),
      colorVisionResult: map['color_vision_result'] ?? 'normal',
      nearVision: map['near_vision'] ?? 'N8',
      astigmatismTests: (map['astigmatism_tests'] as List<dynamic>?)
          ?.map((t) => AstigmatismTestResult.fromMap(t))
          .toList() ?? [],
      colorVisionTests: (map['color_vision_tests'] as List<dynamic>?)
          ?.map((t) => ColorVisionTestResult.fromMap(t))
          .toList() ?? [],
      nearVisionTests: (map['near_vision_tests'] as List<dynamic>?)
          ?.map((t) => NearVisionTestResult.fromMap(t))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'acuity_score': acuityScore,
      'astigmatism_axis': astigmatismAxis,
      'astigmatism_cyl': astigmatismCyl,
      'color_vision_result': colorVisionResult,
      'near_vision': nearVision,
      'astigmatism_tests': astigmatismTests.map((t) => t.toMap()).toList(),
      'color_vision_tests': colorVisionTests.map((t) => t.toMap()).toList(),
      'near_vision_tests': nearVisionTests.map((t) => t.toMap()).toList(),
    };
  }
}

/// Estimated prescription from test results
class EstimatedPrescription {
  final double sph; // sphere power
  final double cyl; // cylinder power
  final int axis; // axis in degrees
  final String note; // additional notes

  EstimatedPrescription({
    required this.sph,
    required this.cyl,
    required this.axis,
    required this.note,
  });

  factory EstimatedPrescription.fromMap(Map<String, dynamic> map) {
    return EstimatedPrescription(
      sph: (map['SPH'] ?? 0.0).toDouble(),
      cyl: (map['CYL'] ?? 0.0).toDouble(),
      axis: map['Axis'] ?? 0,
      note: map['note'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'SPH': sph,
      'CYL': cyl,
      'Axis': axis,
      'note': note,
    };
  }

  String get formattedPrescription {
    if (cyl == 0.0) {
      return '${sph >= 0 ? '+' : ''}${sph.toStringAsFixed(2)}';
    }
    return '${sph >= 0 ? '+' : ''}${sph.toStringAsFixed(2)} ${cyl >= 0 ? '+' : ''}${cyl.toStringAsFixed(2)} x $axis°';
  }
}

/// Astigmatism test results
class AstigmatismTestResult {
  final String testType; // 'fan_chart', 'clock_dial', 'parallel_lines'
  final int selectedLine; // line number selected
  final int correctLine; // correct line number
  final bool isCorrect;
  final double confidence;

  AstigmatismTestResult({
    required this.testType,
    required this.selectedLine,
    required this.correctLine,
    required this.isCorrect,
    required this.confidence,
  });

  factory AstigmatismTestResult.fromMap(Map<String, dynamic> map) {
    return AstigmatismTestResult(
      testType: map['test_type'] ?? '',
      selectedLine: map['selected_line'] ?? 0,
      correctLine: map['correct_line'] ?? 0,
      isCorrect: map['is_correct'] ?? false,
      confidence: (map['confidence'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'test_type': testType,
      'selected_line': selectedLine,
      'correct_line': correctLine,
      'is_correct': isCorrect,
      'confidence': confidence,
    };
  }
}

/// Color vision test results
class ColorVisionTestResult {
  final int plateNumber;
  final String userAnswer;
  final String correctAnswer;
  final bool isCorrect;
  final String plateType; // 'ishihara', 'd15', etc.

  ColorVisionTestResult({
    required this.plateNumber,
    required this.userAnswer,
    required this.correctAnswer,
    required this.isCorrect,
    required this.plateType,
  });

  factory ColorVisionTestResult.fromMap(Map<String, dynamic> map) {
    return ColorVisionTestResult(
      plateNumber: map['plate_number'] ?? 0,
      userAnswer: map['user_answer'] ?? '',
      correctAnswer: map['correct_answer'] ?? '',
      isCorrect: map['is_correct'] ?? false,
      plateType: map['plate_type'] ?? 'ishihara',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'plate_number': plateNumber,
      'user_answer': userAnswer,
      'correct_answer': correctAnswer,
      'is_correct': isCorrect,
      'plate_type': plateType,
    };
  }
}

/// Near vision test results
class NearVisionTestResult {
  final String textSize; // e.g., "N8", "N12"
  final bool canRead;
  final String textContent;
  final double fontSize; // in pixels

  NearVisionTestResult({
    required this.textSize,
    required this.canRead,
    required this.textContent,
    required this.fontSize,
  });

  factory NearVisionTestResult.fromMap(Map<String, dynamic> map) {
    return NearVisionTestResult(
      textSize: map['text_size'] ?? 'N8',
      canRead: map['can_read'] ?? false,
      textContent: map['text_content'] ?? '',
      fontSize: (map['font_size'] ?? 12.0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text_size': textSize,
      'can_read': canRead,
      'text_content': textContent,
      'font_size': fontSize,
    };
  }
}

/// Test configuration and calibration data
class TestConfiguration {
  final double pixelToMmRatio;
  final double phoneDistanceCm;
  final double simulatedDistanceM;
  final double creditCardWidthMm;
  final double creditCardWidthPixels;
  final bool useProximitySensor;
  final bool enableVoiceInstructions;

  TestConfiguration({
    required this.pixelToMmRatio,
    required this.phoneDistanceCm,
    required this.simulatedDistanceM,
    required this.creditCardWidthMm,
    required this.creditCardWidthPixels,
    this.useProximitySensor = false,
    this.enableVoiceInstructions = true,
  });

  factory TestConfiguration.fromMap(Map<String, dynamic> map) {
    return TestConfiguration(
      pixelToMmRatio: (map['pixel_to_mm_ratio'] ?? 1.0).toDouble(),
      phoneDistanceCm: (map['phone_distance_cm'] ?? 40.0).toDouble(),
      simulatedDistanceM: (map['simulated_distance_m'] ?? 3.0).toDouble(),
      creditCardWidthMm: (map['credit_card_width_mm'] ?? 8.56).toDouble(),
      creditCardWidthPixels: (map['credit_card_width_pixels'] ?? 200.0).toDouble(),
      useProximitySensor: map['use_proximity_sensor'] ?? false,
      enableVoiceInstructions: map['enable_voice_instructions'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'pixel_to_mm_ratio': pixelToMmRatio,
      'phone_distance_cm': phoneDistanceCm,
      'simulated_distance_m': simulatedDistanceM,
      'credit_card_width_mm': creditCardWidthMm,
      'credit_card_width_pixels': creditCardWidthPixels,
      'use_proximity_sensor': useProximitySensor,
      'enable_voice_instructions': enableVoiceInstructions,
    };
  }
}

/// Refraction estimation logic
class RefractionEstimator {
  static EstimatedPrescription estimatePrescription(TestResults rightEye, TestResults leftEye) {
    // Convert Snellen acuity to diopters
    final rightAcuity = _acuityToDiopters(rightEye.acuityScore);
    final leftAcuity = _acuityToDiopters(leftEye.acuityScore);
    
    // Calculate average sphere power
    final avgSph = (rightAcuity + leftAcuity) / 2.0;
    
    // Calculate astigmatism from test results
    final rightAstig = _calculateAstigmatism(rightEye.astigmatismTests);
    final leftAstig = _calculateAstigmatism(leftEye.astigmatismTests);
    
    // Use the eye with more significant astigmatism
    final astigmatism = rightAstig.cyl.abs() > leftAstig.cyl.abs() ? rightAstig : leftAstig;
    
    return EstimatedPrescription(
      sph: avgSph,
      cyl: astigmatism.cyl,
      axis: astigmatism.axis,
      note: 'Estimated from digital vision test. Consult eye care professional for accurate prescription.',
    );
  }
  
  static double _acuityToDiopters(String acuity) {
    // Convert Snellen acuity (20/XX) to approximate diopters
    final parts = acuity.split('/');
    if (parts.length != 2) return 0.0;
    
    final denominator = double.tryParse(parts[1]) ?? 20.0;
    
    // Rough conversion: 20/20 = 0D, 20/40 = -1D, 20/60 = -1.5D, etc.
    if (denominator <= 20) return 0.0;
    return -((denominator - 20) / 20.0);
  }
  
  static ({double cyl, int axis}) _calculateAstigmatism(List<AstigmatismTestResult> tests) {
    if (tests.isEmpty) return (cyl: 0.0, axis: 0);
    
    // Simple algorithm: find the most commonly selected axis
    final axisCounts = <int, int>{};
    for (final test in tests) {
      if (test.isCorrect) {
        axisCounts[test.selectedLine] = (axisCounts[test.selectedLine] ?? 0) + 1;
      }
    }
    
    if (axisCounts.isEmpty) return (cyl: 0.0, axis: 0);
    
    final mostCommonAxis = axisCounts.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
    
    // Estimate cylinder power based on test confidence
    final avgConfidence = tests.map((t) => t.confidence).reduce((a, b) => a + b) / tests.length;
    final estimatedCyl = -avgConfidence * 2.0; // Rough estimation
    
    return (cyl: estimatedCyl, axis: mostCommonAxis);
  }
}
