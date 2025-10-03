import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Creative illustration widgets inspired by modern app designs
class CreativeIllustrations {
  
  /// Vision test completion with celebration
  static Widget visionTestComplete({double? width, double? height, Color? primaryColor}) {
    return CustomPaint(
      size: Size(width ?? 300, height ?? 300),
      painter: VisionTestCompletePainter(primaryColor: primaryColor ?? const Color(0xFF10B2D0)),
    );
  }

  /// Eye exam with phone and hand
  static Widget eyeExamWithPhone({double? width, double? height, Color? primaryColor}) {
    return CustomPaint(
      size: Size(width ?? 300, height ?? 300),
      painter: EyeExamWithPhonePainter(primaryColor: primaryColor ?? const Color(0xFF10B2D0)),
    );
  }

  /// Exercise illustration with movement
  static Widget exerciseMovement({double? width, double? height, Color? primaryColor}) {
    return CustomPaint(
      size: Size(width ?? 300, height ?? 300),
      painter: ExerciseMovementPainter(primaryColor: primaryColor ?? const Color(0xFF4ECDC4)),
    );
  }

  /// AI doctor consultation
  static Widget aiDoctorConsultation({double? width, double? height, Color? primaryColor}) {
    return CustomPaint(
      size: Size(width ?? 300, height ?? 300),
      painter: AIDoctorConsultationPainter(primaryColor: primaryColor ?? const Color(0xFF10B2D0)),
    );
  }

  /// Prescription renewal with floating elements
  static Widget prescriptionRenewal({double? width, double? height, Color? primaryColor}) {
    return CustomPaint(
      size: Size(width ?? 300, height ?? 300),
      painter: PrescriptionRenewalPainter(primaryColor: primaryColor ?? const Color(0xFF10B2D0)),
    );
  }

  /// Success celebration with confetti
  static Widget successCelebration({double? width, double? height, Color? primaryColor}) {
    return CustomPaint(
      size: Size(width ?? 300, height ?? 300),
      painter: SuccessCelebrationPainter(primaryColor: primaryColor ?? const Color(0xFF4ECDC4)),
    );
  }

  /// Home screen hero illustration
  static Widget homeHero({double? width, double? height, Color? primaryColor}) {
    return CustomPaint(
      size: Size(width ?? 300, height ?? 300),
      painter: HomeHeroPainter(primaryColor: primaryColor ?? const Color(0xFF10B2D0)),
    );
  }
}

/// Vision test completion painter with modern design
class VisionTestCompletePainter extends CustomPainter {
  final Color primaryColor;
  
  VisionTestCompletePainter({required this.primaryColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    
    // Background gradient circle
    final backgroundPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          primaryColor.withValues(alpha: 0.1),
          primaryColor.withValues(alpha: 0.05),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: size.width * 0.4));
    
    canvas.drawCircle(center, size.width * 0.4, backgroundPaint);
    
    // Main eye icon
    final eyePaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill;
    
    // Eye shape
    final eyePath = Path();
    eyePath.addOval(Rect.fromCenter(
      center: center,
      width: size.width * 0.25,
      height: size.height * 0.15,
    ));
    canvas.drawPath(eyePath, eyePaint);
    
    // Pupil
    final pupilPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, size.width * 0.06, pupilPaint);
    
    // Iris
    final irisPaint = Paint()
      ..color = primaryColor.withValues(alpha: 0.8)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, size.width * 0.04, irisPaint);
    
    // Checkmark
    final checkPaint = Paint()
      ..color = const Color(0xFF4ECDC4)
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    
    final checkPath = Path();
    checkPath.moveTo(center.dx - size.width * 0.08, center.dy);
    checkPath.lineTo(center.dx - size.width * 0.02, center.dy + size.height * 0.06);
    checkPath.lineTo(center.dx + size.width * 0.1, center.dy - size.height * 0.06);
    canvas.drawPath(checkPath, checkPaint);
    
    // Floating stars
    _drawFloatingStars(canvas, center, size, primaryColor);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Eye exam with phone painter
class EyeExamWithPhonePainter extends CustomPainter {
  final Color primaryColor;
  
  EyeExamWithPhonePainter({required this.primaryColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    
    // Background
    final backgroundPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          primaryColor.withValues(alpha: 0.1),
          primaryColor.withValues(alpha: 0.05),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), backgroundPaint);
    
    // Phone
    final phonePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    
    final phoneRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: center, width: size.width * 0.35, height: size.height * 0.55),
      const Radius.circular(25),
    );
    canvas.drawRRect(phoneRect, phonePaint);
    
    // Phone border
    final phoneBorderPaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawRRect(phoneRect, phoneBorderPaint);
    
    // Eye chart on phone
    _drawEyeChart(canvas, center, size, primaryColor);
    
    // Hand holding phone
    _drawHand(canvas, center, size);
    
    // Floating elements
    _drawFloatingElements(canvas, center, size, primaryColor);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Exercise movement painter
class ExerciseMovementPainter extends CustomPainter {
  final Color primaryColor;
  
  ExerciseMovementPainter({required this.primaryColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    
    // Background
    final backgroundPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          primaryColor.withValues(alpha: 0.1),
          primaryColor.withValues(alpha: 0.05),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: size.width * 0.4));
    
    canvas.drawCircle(center, size.width * 0.4, backgroundPaint);
    
    // Person head
    final headPaint = Paint()
      ..color = const Color(0xFFFFF3E0)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(center.dx, center.dy - size.height * 0.1), size.width * 0.12, headPaint);
    
    // Eyes
    final eyePaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(center.dx - size.width * 0.04, center.dy - size.height * 0.1), size.width * 0.025, eyePaint);
    canvas.drawCircle(Offset(center.dx + size.width * 0.04, center.dy - size.height * 0.1), size.width * 0.025, eyePaint);
    
    // Exercise movement lines
    final movementPaint = Paint()
      ..color = primaryColor
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    
    for (int i = 0; i < 8; i++) {
      final angle = (i * 45) * (math.pi / 180);
      final startRadius = size.width * 0.15;
      final endRadius = size.width * 0.25;
      
      final startX = center.dx + startRadius * math.cos(angle);
      final startY = center.dy + startRadius * math.sin(angle);
      final endX = center.dx + endRadius * math.cos(angle);
      final endY = center.dy + endRadius * math.sin(angle);
      
      canvas.drawLine(Offset(startX, startY), Offset(endX, endY), movementPaint);
    }
    
    // Exercise dots
    final dotPaint = Paint()
      ..color = primaryColor.withValues(alpha: 0.6)
      ..style = PaintingStyle.fill;
    
    for (int i = 0; i < 6; i++) {
      final angle = (i * 60) * (math.pi / 180);
      final radius = size.width * 0.3;
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);
      canvas.drawCircle(Offset(x, y), size.width * 0.02, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// AI doctor consultation painter
class AIDoctorConsultationPainter extends CustomPainter {
  final Color primaryColor;
  
  AIDoctorConsultationPainter({required this.primaryColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    
    // Background
    final backgroundPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          primaryColor.withValues(alpha: 0.1),
          primaryColor.withValues(alpha: 0.05),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), backgroundPaint);
    
    // Doctor figure
    final doctorPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    
    // Doctor head
    canvas.drawCircle(Offset(center.dx, center.dy - size.height * 0.1), size.width * 0.12, doctorPaint);
    
    // Doctor body
    final bodyRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(center.dx, center.dy + size.height * 0.05), width: size.width * 0.2, height: size.height * 0.25),
      const Radius.circular(20),
    );
    canvas.drawRRect(bodyRect, doctorPaint);
    
    // Stethoscope
    final stethPaint = Paint()
      ..color = primaryColor
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    
    final stethPath = Path();
    stethPath.moveTo(center.dx - size.width * 0.08, center.dy - size.height * 0.05);
    stethPath.quadraticBezierTo(
      center.dx - size.width * 0.12, center.dy - size.height * 0.15,
      center.dx - size.width * 0.05, center.dy - size.height * 0.2,
    );
    canvas.drawPath(stethPath, stethPaint);
    
    // Chat bubbles
    _drawChatBubbles(canvas, center, size, primaryColor);
    
    // AI indicators
    _drawAIIndicators(canvas, center, size, primaryColor);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Prescription renewal painter
class PrescriptionRenewalPainter extends CustomPainter {
  final Color primaryColor;
  
  PrescriptionRenewalPainter({required this.primaryColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    
    // Background
    final backgroundPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          primaryColor.withValues(alpha: 0.1),
          primaryColor.withValues(alpha: 0.05),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: size.width * 0.4));
    
    canvas.drawCircle(center, size.width * 0.4, backgroundPaint);
    
    // Phone
    final phonePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    
    final phoneRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: center, width: size.width * 0.3, height: size.height * 0.5),
      const Radius.circular(20),
    );
    canvas.drawRRect(phoneRect, phonePaint);
    
    // Phone border
    final phoneBorderPaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawRRect(phoneRect, phoneBorderPaint);
    
    // Prescription paper
    final paperPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    
    final paperRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(center.dx + size.width * 0.08, center.dy), width: size.width * 0.2, height: size.height * 0.35),
      const Radius.circular(8),
    );
    canvas.drawRRect(paperRect, paperPaint);
    
    // Paper border
    final paperBorderPaint = Paint()
      ..color = primaryColor.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawRRect(paperRect, paperBorderPaint);
    
    // Rx symbol
    _drawRxSymbol(canvas, center, size, primaryColor);
    
    // Floating glasses and contacts
    _drawFloatingGlasses(canvas, center, size, primaryColor);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Success celebration painter
class SuccessCelebrationPainter extends CustomPainter {
  final Color primaryColor;
  
  SuccessCelebrationPainter({required this.primaryColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    
    // Background
    final backgroundPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          primaryColor.withValues(alpha: 0.15),
          primaryColor.withValues(alpha: 0.05),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: size.width * 0.4));
    
    canvas.drawCircle(center, size.width * 0.4, backgroundPaint);
    
    // Trophy
    _drawTrophy(canvas, center, size, primaryColor);
    
    // Confetti
    _drawConfetti(canvas, center, size);
    
    // Celebration stars
    _drawCelebrationStars(canvas, center, size, primaryColor);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Home hero painter
class HomeHeroPainter extends CustomPainter {
  final Color primaryColor;
  
  HomeHeroPainter({required this.primaryColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    
    // Background gradient
    final backgroundPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          primaryColor.withValues(alpha: 0.1),
          primaryColor.withValues(alpha: 0.05),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), backgroundPaint);
    
    // Main eye icon
    _drawMainEye(canvas, center, size, primaryColor);
    
    // Floating elements
    _drawFloatingElements(canvas, center, size, primaryColor);
    
    // Decorative lines
    _drawDecorativeLines(canvas, center, size, primaryColor);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Helper methods

void _drawFloatingStars(Canvas canvas, Offset center, Size size, Color color) {
  final starPaint = Paint()
    ..color = color.withValues(alpha: 0.6)
    ..style = PaintingStyle.fill;
  
  for (int i = 0; i < 6; i++) {
    final angle = (i * 60) * (math.pi / 180);
    final radius = size.width * 0.35;
    final x = center.dx + radius * math.cos(angle);
    final y = center.dy + radius * math.sin(angle);
    _drawStar(canvas, Offset(x, y), size.width * 0.03, starPaint);
  }
}

void _drawStar(Canvas canvas, Offset center, double size, Paint paint) {
  final path = Path();
  for (int i = 0; i < 5; i++) {
    final angle = (i * 144) * (math.pi / 180);
    final x = center.dx + size * math.cos(angle);
    final y = center.dy + size * math.sin(angle);
    if (i == 0) {
      path.moveTo(x, y);
    } else {
      path.lineTo(x, y);
    }
  }
  path.close();
  canvas.drawPath(path, paint);
}

void _drawEyeChart(Canvas canvas, Offset center, Size size, Color color) {
  final textPainter = TextPainter(
    text: TextSpan(
      text: 'E\nFP\nTOZ\nLPED\nFPTOL',
      style: TextStyle(
        fontSize: size.width * 0.06,
        color: color,
        fontWeight: FontWeight.bold,
        height: 1.2,
      ),
    ),
    textDirection: TextDirection.ltr,
  );
  textPainter.layout();
  textPainter.paint(canvas, Offset(
    center.dx - textPainter.width / 2,
    center.dy - textPainter.height / 2,
  ));
}

void _drawHand(Canvas canvas, Offset center, Size size) {
  final handPaint = Paint()
    ..color = const Color(0xFFFFF3E0)
    ..style = PaintingStyle.fill;
  
  final handPath = Path();
  handPath.moveTo(center.dx - size.width * 0.2, center.dy + size.height * 0.15);
  handPath.quadraticBezierTo(
    center.dx - size.width * 0.1, center.dy + size.height * 0.05,
    center.dx - size.width * 0.05, center.dy + size.height * 0.1,
  );
  handPath.quadraticBezierTo(
    center.dx, center.dy + size.height * 0.15,
    center.dx + size.width * 0.05, center.dy + size.height * 0.1,
  );
  handPath.quadraticBezierTo(
    center.dx + size.width * 0.1, center.dy + size.height * 0.05,
    center.dx + size.width * 0.15, center.dy + size.height * 0.1,
  );
  handPath.quadraticBezierTo(
    center.dx + size.width * 0.2, center.dy + size.height * 0.15,
    center.dx + size.width * 0.2, center.dy + size.height * 0.25,
  );
  handPath.close();
  canvas.drawPath(handPath, handPaint);
}

void _drawFloatingElements(Canvas canvas, Offset center, Size size, Color color) {
  final elementPaint = Paint()
    ..color = color.withValues(alpha: 0.7)
    ..style = PaintingStyle.fill;
  
  // Glasses
  canvas.drawCircle(Offset(center.dx - size.width * 0.25, center.dy - size.height * 0.15), size.width * 0.04, elementPaint);
  canvas.drawCircle(Offset(center.dx + size.width * 0.25, center.dy - size.height * 0.15), size.width * 0.04, elementPaint);
  
  // Contacts
  canvas.drawOval(
    Rect.fromCenter(center: Offset(center.dx - size.width * 0.2, center.dy + size.height * 0.2), width: size.width * 0.06, height: size.height * 0.04),
    elementPaint,
  );
  canvas.drawOval(
    Rect.fromCenter(center: Offset(center.dx + size.width * 0.2, center.dy + size.height * 0.2), width: size.width * 0.06, height: size.height * 0.04),
    elementPaint,
  );
}

void _drawChatBubbles(Canvas canvas, Offset center, Size size, Color color) {
  final bubblePaint = Paint()
    ..color = color.withValues(alpha: 0.1)
    ..style = PaintingStyle.fill;
  
  // First bubble
  final bubble1Rect = RRect.fromRectAndRadius(
    Rect.fromCenter(center: Offset(center.dx + size.width * 0.15, center.dy - size.height * 0.1), width: size.width * 0.25, height: size.height * 0.12),
    const Radius.circular(15),
  );
  canvas.drawRRect(bubble1Rect, bubblePaint);
  
  // Second bubble
  final bubble2Rect = RRect.fromRectAndRadius(
    Rect.fromCenter(center: Offset(center.dx - size.width * 0.15, center.dy + size.height * 0.1), width: size.width * 0.2, height: size.height * 0.1),
    const Radius.circular(15),
  );
  canvas.drawRRect(bubble2Rect, bubblePaint);
}

void _drawAIIndicators(Canvas canvas, Offset center, Size size, Color color) {
  final indicatorPaint = Paint()
    ..color = color
    ..style = PaintingStyle.fill;
  
  for (int i = 0; i < 4; i++) {
    final angle = (i * 90) * (math.pi / 180);
    final radius = size.width * 0.3;
    final x = center.dx + radius * math.cos(angle);
    final y = center.dy + radius * math.sin(angle);
    canvas.drawCircle(Offset(x, y), size.width * 0.015, indicatorPaint);
  }
}

void _drawRxSymbol(Canvas canvas, Offset center, Size size, Color color) {
  final textPainter = TextPainter(
    text: TextSpan(
      text: 'Rx',
      style: TextStyle(
        fontSize: size.width * 0.06,
        color: color,
        fontWeight: FontWeight.bold,
      ),
    ),
    textDirection: TextDirection.ltr,
  );
  textPainter.layout();
  textPainter.paint(canvas, Offset(
    center.dx + size.width * 0.02,
    center.dy - size.height * 0.08,
  ));
}

void _drawFloatingGlasses(Canvas canvas, Offset center, Size size, Color color) {
  final glassesPaint = Paint()
    ..color = color.withValues(alpha: 0.7)
    ..style = PaintingStyle.fill;
  
  // Glasses frames
  canvas.drawCircle(Offset(center.dx - size.width * 0.2, center.dy - size.height * 0.1), size.width * 0.05, glassesPaint);
  canvas.drawCircle(Offset(center.dx + size.width * 0.2, center.dy - size.height * 0.1), size.width * 0.05, glassesPaint);
  
  // Bridge
  canvas.drawRect(
    Rect.fromCenter(center: Offset(center.dx, center.dy - size.height * 0.1), width: size.width * 0.08, height: size.height * 0.02),
    glassesPaint,
  );
}

void _drawTrophy(Canvas canvas, Offset center, Size size, Color color) {
  final trophyPaint = Paint()
    ..color = const Color(0xFFFFB74D)
    ..style = PaintingStyle.fill;
  
  // Trophy cup
  final trophyPath = Path();
  trophyPath.moveTo(center.dx - size.width * 0.06, center.dy + size.height * 0.08);
  trophyPath.lineTo(center.dx - size.width * 0.06, center.dy - size.height * 0.08);
  trophyPath.lineTo(center.dx - size.width * 0.03, center.dy - size.height * 0.12);
  trophyPath.lineTo(center.dx + size.width * 0.03, center.dy - size.height * 0.12);
  trophyPath.lineTo(center.dx + size.width * 0.06, center.dy - size.height * 0.08);
  trophyPath.lineTo(center.dx + size.width * 0.06, center.dy + size.height * 0.08);
  trophyPath.close();
  canvas.drawPath(trophyPath, trophyPaint);
  
  // Trophy base
  final basePaint = Paint()
    ..color = color
    ..style = PaintingStyle.fill;
  canvas.drawRect(
    Rect.fromCenter(center: Offset(center.dx, center.dy + size.height * 0.12), width: size.width * 0.15, height: size.height * 0.04),
    basePaint,
  );
}

void _drawConfetti(Canvas canvas, Offset center, Size size) {
  final confettiColors = [
    const Color(0xFF4ECDC4),
    const Color(0xFFFFB74D),
    const Color(0xFF10B2D0),
    const Color(0xFFE91E63),
  ];
  
  for (int i = 0; i < 12; i++) {
    final angle = (i * 30) * (math.pi / 180);
    final radius = size.width * 0.35;
    final x = center.dx + radius * math.cos(angle);
    final y = center.dy + radius * math.sin(angle);
    
    final confettiPaint = Paint()
      ..color = confettiColors[i % confettiColors.length]
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(Offset(x, y), size.width * 0.015, confettiPaint);
  }
}

void _drawCelebrationStars(Canvas canvas, Offset center, Size size, Color color) {
  final starPaint = Paint()
    ..color = color.withValues(alpha: 0.8)
    ..style = PaintingStyle.fill;
  
  for (int i = 0; i < 8; i++) {
    final angle = (i * 45) * (math.pi / 180);
    final radius = size.width * 0.25;
    final x = center.dx + radius * math.cos(angle);
    final y = center.dy + radius * math.sin(angle);
    _drawStar(canvas, Offset(x, y), size.width * 0.02, starPaint);
  }
}

void _drawMainEye(Canvas canvas, Offset center, Size size, Color color) {
  final eyePaint = Paint()
    ..color = color
    ..style = PaintingStyle.fill;
  
  // Eye shape
  final eyePath = Path();
  eyePath.addOval(Rect.fromCenter(
    center: center,
    width: size.width * 0.3,
    height: size.height * 0.2,
  ));
  canvas.drawPath(eyePath, eyePaint);
  
  // Pupil
  final pupilPaint = Paint()
    ..color = Colors.white
    ..style = PaintingStyle.fill;
  canvas.drawCircle(center, size.width * 0.08, pupilPaint);
  
  // Iris
  final irisPaint = Paint()
    ..color = color.withValues(alpha: 0.8)
    ..style = PaintingStyle.fill;
  canvas.drawCircle(center, size.width * 0.06, irisPaint);
}

void _drawDecorativeLines(Canvas canvas, Offset center, Size size, Color color) {
  final linePaint = Paint()
    ..color = color.withValues(alpha: 0.3)
    ..strokeWidth = 2
    ..style = PaintingStyle.stroke;
  
  // Curved lines
  for (int i = 0; i < 3; i++) {
    final path = Path();
    final startAngle = (i * 120) * (math.pi / 180);
    final endAngle = startAngle + (60 * math.pi / 180);
    final radius = size.width * 0.3;
    
    path.addArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      endAngle - startAngle,
    );
    canvas.drawPath(path, linePaint);
  }
}
