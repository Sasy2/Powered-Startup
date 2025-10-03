import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Professional, high-quality illustrations for the EyeCon app
class ProfessionalIllustrations {
  
  /// Vision test completion with modern celebration design
  static Widget visionTestComplete({double? width, double? height, Color? primaryColor}) {
    return CustomPaint(
      size: Size(width ?? 300, height ?? 300),
      painter: VisionTestCompletePainter(primaryColor: primaryColor ?? const Color(0xFF10B2D0)),
    );
  }

  /// Eye exam with sophisticated phone and hand design
  static Widget eyeExamWithPhone({double? width, double? height, Color? primaryColor}) {
    return CustomPaint(
      size: Size(width ?? 300, height ?? 300),
      painter: EyeExamWithPhonePainter(primaryColor: primaryColor ?? const Color(0xFF10B2D0)),
    );
  }

  /// Exercise illustration with modern movement design
  static Widget exerciseMovement({double? width, double? height, Color? primaryColor}) {
    return CustomPaint(
      size: Size(width ?? 300, height ?? 300),
      painter: ExerciseMovementPainter(primaryColor: primaryColor ?? const Color(0xFF4ECDC4)),
    );
  }

  /// AI doctor consultation with professional design
  static Widget aiDoctorConsultation({double? width, double? height, Color? primaryColor}) {
    return CustomPaint(
      size: Size(width ?? 300, height ?? 300),
      painter: AIDoctorConsultationPainter(primaryColor: primaryColor ?? const Color(0xFF10B2D0)),
    );
  }

  /// Prescription renewal with elegant design
  static Widget prescriptionRenewal({double? width, double? height, Color? primaryColor}) {
    return CustomPaint(
      size: Size(width ?? 300, height ?? 300),
      painter: PrescriptionRenewalPainter(primaryColor: primaryColor ?? const Color(0xFF10B2D0)),
    );
  }

  /// Success celebration with modern confetti design
  static Widget successCelebration({double? width, double? height, Color? primaryColor}) {
    return CustomPaint(
      size: Size(width ?? 300, height ?? 300),
      painter: SuccessCelebrationPainter(primaryColor: primaryColor ?? const Color(0xFF4ECDC4)),
    );
  }

  /// Home hero with sophisticated design
  static Widget homeHero({double? width, double? height, Color? primaryColor}) {
    return CustomPaint(
      size: Size(width ?? 300, height ?? 300),
      painter: HomeHeroPainter(primaryColor: primaryColor ?? const Color(0xFF10B2D0)),
    );
  }
}

/// Professional vision test completion painter
class VisionTestCompletePainter extends CustomPainter {
  final Color primaryColor;
  
  VisionTestCompletePainter({required this.primaryColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    
    // Background gradient circle with shadow
    final backgroundGradient = RadialGradient(
      colors: [
        primaryColor.withValues(alpha: 0.15),
        primaryColor.withValues(alpha: 0.05),
        Colors.transparent,
      ],
      stops: const [0.0, 0.7, 1.0],
    );
    
    final backgroundPaint = Paint()
      ..shader = backgroundGradient.createShader(Rect.fromCircle(center: center, radius: size.width * 0.45));
    
    canvas.drawCircle(center, size.width * 0.45, backgroundPaint);
    
    // Main eye with sophisticated design
    _drawModernEye(canvas, center, size, primaryColor);
    
    // Checkmark with gradient and shadow
    _drawModernCheckmark(canvas, center, size, primaryColor);
    
    // Floating celebration elements
    _drawCelebrationElements(canvas, center, size, primaryColor);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Professional eye exam with phone painter
class EyeExamWithPhonePainter extends CustomPainter {
  final Color primaryColor;
  
  EyeExamWithPhonePainter({required this.primaryColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    
    // Background with subtle gradient
    final backgroundGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        primaryColor.withValues(alpha: 0.08),
        primaryColor.withValues(alpha: 0.03),
      ],
    );
    
    final backgroundPaint = Paint()
      ..shader = backgroundGradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), backgroundPaint);
    
    // Modern phone with realistic design
    _drawModernPhone(canvas, center, size, primaryColor);
    
    // Professional hand design
    _drawProfessionalHand(canvas, center, size);
    
    // Floating medical elements
    _drawFloatingMedicalElements(canvas, center, size, primaryColor);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Professional exercise movement painter
class ExerciseMovementPainter extends CustomPainter {
  final Color primaryColor;
  
  ExerciseMovementPainter({required this.primaryColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    
    // Background with radial gradient
    final backgroundGradient = RadialGradient(
      colors: [
        primaryColor.withValues(alpha: 0.12),
        primaryColor.withValues(alpha: 0.04),
        Colors.transparent,
      ],
      stops: const [0.0, 0.6, 1.0],
    );
    
    final backgroundPaint = Paint()
      ..shader = backgroundGradient.createShader(Rect.fromCircle(center: center, radius: size.width * 0.45));
    
    canvas.drawCircle(center, size.width * 0.45, backgroundPaint);
    
    // Modern person figure
    _drawModernPerson(canvas, center, size, primaryColor);
    
    // Dynamic movement lines
    _drawDynamicMovementLines(canvas, center, size, primaryColor);
    
    // Exercise indicators
    _drawExerciseIndicators(canvas, center, size, primaryColor);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Professional AI doctor consultation painter
class AIDoctorConsultationPainter extends CustomPainter {
  final Color primaryColor;
  
  AIDoctorConsultationPainter({required this.primaryColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    
    // Background gradient
    final backgroundGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        primaryColor.withValues(alpha: 0.1),
        primaryColor.withValues(alpha: 0.03),
      ],
    );
    
    final backgroundPaint = Paint()
      ..shader = backgroundGradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), backgroundPaint);
    
    // Professional doctor figure
    _drawProfessionalDoctor(canvas, center, size, primaryColor);
    
    // Modern chat bubbles
    _drawModernChatBubbles(canvas, center, size, primaryColor);
    
    // AI indicators
    _drawAIIndicators(canvas, center, size, primaryColor);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Professional prescription renewal painter
class PrescriptionRenewalPainter extends CustomPainter {
  final Color primaryColor;
  
  PrescriptionRenewalPainter({required this.primaryColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    
    // Background with sophisticated gradient
    final backgroundGradient = RadialGradient(
      colors: [
        primaryColor.withValues(alpha: 0.1),
        primaryColor.withValues(alpha: 0.03),
        Colors.transparent,
      ],
      stops: const [0.0, 0.7, 1.0],
    );
    
    final backgroundPaint = Paint()
      ..shader = backgroundGradient.createShader(Rect.fromCircle(center: center, radius: size.width * 0.45));
    
    canvas.drawCircle(center, size.width * 0.45, backgroundPaint);
    
    // Modern phone design
    _drawModernPhone(canvas, center, size, primaryColor);
    
    // Professional prescription paper
    _drawPrescriptionPaper(canvas, center, size, primaryColor);
    
    // Floating eyewear elements
    _drawFloatingEyewear(canvas, center, size, primaryColor);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Professional success celebration painter
class SuccessCelebrationPainter extends CustomPainter {
  final Color primaryColor;
  
  SuccessCelebrationPainter({required this.primaryColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    
    // Background with celebration gradient
    final backgroundGradient = RadialGradient(
      colors: [
        primaryColor.withValues(alpha: 0.15),
        primaryColor.withValues(alpha: 0.05),
        Colors.transparent,
      ],
      stops: const [0.0, 0.6, 1.0],
    );
    
    final backgroundPaint = Paint()
      ..shader = backgroundGradient.createShader(Rect.fromCircle(center: center, radius: size.width * 0.45));
    
    canvas.drawCircle(center, size.width * 0.45, backgroundPaint);
    
    // Modern trophy design
    _drawModernTrophy(canvas, center, size, primaryColor);
    
    // Professional confetti
    _drawProfessionalConfetti(canvas, center, size);
    
    // Celebration stars
    _drawCelebrationStars(canvas, center, size, primaryColor);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Professional home hero painter
class HomeHeroPainter extends CustomPainter {
  final Color primaryColor;
  
  HomeHeroPainter({required this.primaryColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    
    // Background with sophisticated gradient
    final backgroundGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        primaryColor.withValues(alpha: 0.1),
        primaryColor.withValues(alpha: 0.03),
      ],
    );
    
    final backgroundPaint = Paint()
      ..shader = backgroundGradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), backgroundPaint);
    
    // Main eye with modern design
    _drawModernEye(canvas, center, size, primaryColor);
    
    // Floating elements
    _drawFloatingElements(canvas, center, size, primaryColor);
    
    // Decorative lines
    _drawDecorativeLines(canvas, center, size, primaryColor);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Helper methods for professional illustrations

void _drawModernEye(Canvas canvas, Offset center, Size size, Color primaryColor) {
  // Eye outline with gradient
  final eyeGradient = LinearGradient(
    colors: [
      primaryColor,
      primaryColor.withValues(alpha: 0.8),
    ],
  );
  
  final eyePaint = Paint()
    ..shader = eyeGradient.createShader(Rect.fromCenter(
      center: center,
      width: size.width * 0.3,
      height: size.height * 0.18,
    ))
    ..style = PaintingStyle.fill;
  
  // Eye shape with rounded corners
  final eyePath = Path();
  eyePath.addRRect(RRect.fromRectAndRadius(
    Rect.fromCenter(center: center, width: size.width * 0.3, height: size.height * 0.18),
    const Radius.circular(20),
  ));
  canvas.drawPath(eyePath, eyePaint);
  
  // Eye highlight
  final highlightPaint = Paint()
    ..color = Colors.white.withValues(alpha: 0.3)
    ..style = PaintingStyle.fill;
  
  canvas.drawOval(
    Rect.fromCenter(
      center: Offset(center.dx - size.width * 0.05, center.dy - size.height * 0.03),
      width: size.width * 0.08,
      height: size.height * 0.05,
    ),
    highlightPaint,
  );
  
  // Pupil with gradient
  final pupilGradient = RadialGradient(
    colors: [
      Colors.white,
      primaryColor.withValues(alpha: 0.1),
    ],
  );
  
  final pupilPaint = Paint()
    ..shader = pupilGradient.createShader(Rect.fromCircle(center: center, radius: size.width * 0.06));
  
  canvas.drawCircle(center, size.width * 0.06, pupilPaint);
  
  // Iris
  final irisPaint = Paint()
    ..color = primaryColor.withValues(alpha: 0.9)
    ..style = PaintingStyle.fill;
  
  canvas.drawCircle(center, size.width * 0.04, irisPaint);
}

void _drawModernCheckmark(Canvas canvas, Offset center, Size size, Color primaryColor) {
  final checkPaint = Paint()
    ..color = const Color(0xFF4ECDC4)
    ..strokeWidth = 6
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round;
  
  final checkPath = Path();
  checkPath.moveTo(center.dx - size.width * 0.08, center.dy);
  checkPath.lineTo(center.dx - size.width * 0.02, center.dy + size.height * 0.06);
  checkPath.lineTo(center.dx + size.width * 0.1, center.dy - size.height * 0.06);
  
  // Add shadow
  final shadowPaint = Paint()
    ..color = const Color(0xFF4ECDC4).withValues(alpha: 0.3)
    ..strokeWidth = 8
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round;
  
  canvas.drawPath(checkPath, shadowPaint);
  canvas.drawPath(checkPath, checkPaint);
}

void _drawCelebrationElements(Canvas canvas, Offset center, Size size, Color primaryColor) {
  final colors = [
    const Color(0xFF4ECDC4),
    const Color(0xFFFFB74D),
    const Color(0xFF10B2D0),
    const Color(0xFFE91E63),
  ];
  
  for (int i = 0; i < 8; i++) {
    final angle = (i * 45) * (math.pi / 180);
    final radius = size.width * 0.35;
    final x = center.dx + radius * math.cos(angle);
    final y = center.dy + radius * math.sin(angle);
    
    final starPaint = Paint()
      ..color = colors[i % colors.length].withValues(alpha: 0.8)
      ..style = PaintingStyle.fill;
    
    _drawStar(canvas, Offset(x, y), size.width * 0.025, starPaint);
  }
}

void _drawModernPhone(Canvas canvas, Offset center, Size size, Color primaryColor) {
  // Phone body with gradient
  final phoneGradient = LinearGradient(
    colors: [
      Colors.white,
      const Color(0xFFF8F9FA),
    ],
  );
  
  final phonePaint = Paint()
    ..shader = phoneGradient.createShader(Rect.fromCenter(
      center: center,
      width: size.width * 0.35,
      height: size.height * 0.55,
    ))
    ..style = PaintingStyle.fill;
  
  final phoneRect = RRect.fromRectAndRadius(
    Rect.fromCenter(center: center, width: size.width * 0.35, height: size.height * 0.55),
    const Radius.circular(25),
  );
  canvas.drawRRect(phoneRect, phonePaint);
  
  // Phone border with gradient
  final borderGradient = LinearGradient(
    colors: [
      primaryColor,
      primaryColor.withValues(alpha: 0.7),
    ],
  );
  
  final borderPaint = Paint()
    ..shader = borderGradient.createShader(Rect.fromCenter(
      center: center,
      width: size.width * 0.35,
      height: size.height * 0.55,
    ))
    ..style = PaintingStyle.stroke
    ..strokeWidth = 3;
  
  canvas.drawRRect(phoneRect, borderPaint);
  
  // Screen content
  _drawEyeChartOnPhone(canvas, center, size, primaryColor);
}

void _drawEyeChartOnPhone(Canvas canvas, Offset center, Size size, Color primaryColor) {
  final textPainter = TextPainter(
    text: TextSpan(
      text: 'E\nFP\nTOZ\nLPED\nFPTOL',
      style: TextStyle(
        fontSize: size.width * 0.06,
        color: primaryColor,
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

void _drawProfessionalHand(Canvas canvas, Offset center, Size size) {
  final handGradient = LinearGradient(
    colors: [
      const Color(0xFFFFF3E0),
      const Color(0xFFFFE0B2),
    ],
  );
  
  final handPaint = Paint()
    ..shader = handGradient.createShader(Rect.fromCenter(
      center: center,
      width: size.width * 0.4,
      height: size.height * 0.3,
    ))
    ..style = PaintingStyle.fill;
  
  final handPath = Path();
  handPath.moveTo(center.dx - size.width * 0.2, center.dy + size.height * 0.1);
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
  
  // Hand shadow
  final shadowPaint = Paint()
    ..color = Colors.black.withValues(alpha: 0.1)
    ..style = PaintingStyle.fill;
  
  final shadowPath = Path();
  shadowPath.addPath(handPath, const Offset(2, 2));
  canvas.drawPath(shadowPath, shadowPaint);
  canvas.drawPath(handPath, handPaint);
}

void _drawFloatingMedicalElements(Canvas canvas, Offset center, Size size, Color primaryColor) {
  // Glasses
  _drawFloatingGlasses(canvas, center, size, primaryColor);
  
  // Contacts
  _drawFloatingContacts(canvas, center, size, primaryColor);
  
  // Medical cross
  _drawMedicalCross(canvas, center, size, primaryColor);
}

void _drawFloatingGlasses(Canvas canvas, Offset center, Size size, Color primaryColor) {
  final glassesPaint = Paint()
    ..color = primaryColor.withValues(alpha: 0.8)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 3;
  
  // Left lens
  canvas.drawCircle(Offset(center.dx - size.width * 0.25, center.dy - size.height * 0.15), size.width * 0.05, glassesPaint);
  // Right lens
  canvas.drawCircle(Offset(center.dx + size.width * 0.25, center.dy - size.height * 0.15), size.width * 0.05, glassesPaint);
  // Bridge
  canvas.drawLine(
    Offset(center.dx - size.width * 0.2, center.dy - size.height * 0.15),
    Offset(center.dx + size.width * 0.2, center.dy - size.height * 0.15),
    glassesPaint,
  );
}

void _drawFloatingContacts(Canvas canvas, Offset center, Size size, Color primaryColor) {
  final contactPaint = Paint()
    ..color = primaryColor.withValues(alpha: 0.7)
    ..style = PaintingStyle.fill;
  
  canvas.drawOval(
    Rect.fromCenter(center: Offset(center.dx - size.width * 0.2, center.dy + size.height * 0.2), width: size.width * 0.06, height: size.height * 0.04),
    contactPaint,
  );
  canvas.drawOval(
    Rect.fromCenter(center: Offset(center.dx + size.width * 0.2, center.dy + size.height * 0.2), width: size.width * 0.06, height: size.height * 0.04),
    contactPaint,
  );
}

void _drawMedicalCross(Canvas canvas, Offset center, Size size, Color primaryColor) {
  final crossPaint = Paint()
    ..color = const Color(0xFF4ECDC4)
    ..style = PaintingStyle.fill;
  
  final crossSize = size.width * 0.03;
  final crossCenter = Offset(center.dx, center.dy - size.height * 0.25);
  
  // Vertical line
  canvas.drawRect(
    Rect.fromCenter(center: crossCenter, width: crossSize * 0.3, height: crossSize),
    crossPaint,
  );
  // Horizontal line
  canvas.drawRect(
    Rect.fromCenter(center: crossCenter, width: crossSize, height: crossSize * 0.3),
    crossPaint,
  );
}

void _drawModernPerson(Canvas canvas, Offset center, Size size, Color primaryColor) {
  // Head
  final headGradient = LinearGradient(
    colors: [
      const Color(0xFFFFF3E0),
      const Color(0xFFFFE0B2),
    ],
  );
  
  final headPaint = Paint()
    ..shader = headGradient.createShader(Rect.fromCircle(center: Offset(center.dx, center.dy - size.height * 0.1), radius: size.width * 0.12));
  
  canvas.drawCircle(Offset(center.dx, center.dy - size.height * 0.1), size.width * 0.12, headPaint);
  
  // Eyes
  final eyePaint = Paint()
    ..color = primaryColor
    ..style = PaintingStyle.fill;
  
  canvas.drawCircle(Offset(center.dx - size.width * 0.04, center.dy - size.height * 0.1), size.width * 0.025, eyePaint);
  canvas.drawCircle(Offset(center.dx + size.width * 0.04, center.dy - size.height * 0.1), size.width * 0.025, eyePaint);
  
  // Body
  final bodyGradient = LinearGradient(
    colors: [
      primaryColor.withValues(alpha: 0.8),
      primaryColor.withValues(alpha: 0.6),
    ],
  );
  
  final bodyPaint = Paint()
    ..shader = bodyGradient.createShader(Rect.fromCenter(
      center: Offset(center.dx, center.dy + size.height * 0.05),
      width: size.width * 0.2,
      height: size.height * 0.25,
    ));
  
  final bodyRect = RRect.fromRectAndRadius(
    Rect.fromCenter(center: Offset(center.dx, center.dy + size.height * 0.05), width: size.width * 0.2, height: size.height * 0.25),
    const Radius.circular(20),
  );
  canvas.drawRRect(bodyRect, bodyPaint);
}

void _drawDynamicMovementLines(Canvas canvas, Offset center, Size size, Color primaryColor) {
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
    
    // Add glow effect
    final glowPaint = Paint()
      ..color = primaryColor.withValues(alpha: 0.3)
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    
    canvas.drawLine(Offset(startX, startY), Offset(endX, endY), glowPaint);
    canvas.drawLine(Offset(startX, startY), Offset(endX, endY), movementPaint);
  }
}

void _drawExerciseIndicators(Canvas canvas, Offset center, Size size, Color primaryColor) {
  final dotPaint = Paint()
    ..color = primaryColor.withValues(alpha: 0.6)
    ..style = PaintingStyle.fill;
  
  for (int i = 0; i < 6; i++) {
    final angle = (i * 60) * (math.pi / 180);
    final radius = size.width * 0.3;
    final x = center.dx + radius * math.cos(angle);
    final y = center.dy + radius * math.sin(angle);
    
    // Add glow
    final glowPaint = Paint()
      ..color = primaryColor.withValues(alpha: 0.2)
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(Offset(x, y), size.width * 0.03, glowPaint);
    canvas.drawCircle(Offset(x, y), size.width * 0.02, dotPaint);
  }
}

void _drawProfessionalDoctor(Canvas canvas, Offset center, Size size, Color primaryColor) {
  // Doctor head
  final headGradient = LinearGradient(
    colors: [
      const Color(0xFFFFF3E0),
      const Color(0xFFFFE0B2),
    ],
  );
  
  final headPaint = Paint()
    ..shader = headGradient.createShader(Rect.fromCircle(center: Offset(center.dx, center.dy - size.height * 0.1), radius: size.width * 0.12));
  
  canvas.drawCircle(Offset(center.dx, center.dy - size.height * 0.1), size.width * 0.12, headPaint);
  
  // Doctor body
  final bodyGradient = LinearGradient(
    colors: [
      Colors.white,
      const Color(0xFFF8F9FA),
    ],
  );
  
  final bodyPaint = Paint()
    ..shader = bodyGradient.createShader(Rect.fromCenter(
      center: Offset(center.dx, center.dy + size.height * 0.05),
      width: size.width * 0.2,
      height: size.height * 0.25,
    ));
  
  final bodyRect = RRect.fromRectAndRadius(
    Rect.fromCenter(center: Offset(center.dx, center.dy + size.height * 0.05), width: size.width * 0.2, height: size.height * 0.25),
    const Radius.circular(20),
  );
  canvas.drawRRect(bodyRect, bodyPaint);
  
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
}

void _drawModernChatBubbles(Canvas canvas, Offset center, Size size, Color primaryColor) {
  // First bubble
  final bubble1Gradient = LinearGradient(
    colors: [
      primaryColor.withValues(alpha: 0.1),
      primaryColor.withValues(alpha: 0.05),
    ],
  );
  
  final bubble1Paint = Paint()
    ..shader = bubble1Gradient.createShader(Rect.fromCenter(
      center: Offset(center.dx + size.width * 0.15, center.dy - size.height * 0.1),
      width: size.width * 0.25,
      height: size.height * 0.12,
    ));
  
  final bubble1Rect = RRect.fromRectAndRadius(
    Rect.fromCenter(center: Offset(center.dx + size.width * 0.15, center.dy - size.height * 0.1), width: size.width * 0.25, height: size.height * 0.12),
    const Radius.circular(15),
  );
  canvas.drawRRect(bubble1Rect, bubble1Paint);
  
  // Second bubble
  final bubble2Gradient = LinearGradient(
    colors: [
      primaryColor.withValues(alpha: 0.08),
      primaryColor.withValues(alpha: 0.03),
    ],
  );
  
  final bubble2Paint = Paint()
    ..shader = bubble2Gradient.createShader(Rect.fromCenter(
      center: Offset(center.dx - size.width * 0.15, center.dy + size.height * 0.1),
      width: size.width * 0.2,
      height: size.height * 0.1,
    ));
  
  final bubble2Rect = RRect.fromRectAndRadius(
    Rect.fromCenter(center: Offset(center.dx - size.width * 0.15, center.dy + size.height * 0.1), width: size.width * 0.2, height: size.height * 0.1),
    const Radius.circular(15),
  );
  canvas.drawRRect(bubble2Rect, bubble2Paint);
}

void _drawAIIndicators(Canvas canvas, Offset center, Size size, Color primaryColor) {
  final indicatorPaint = Paint()
    ..color = primaryColor
    ..style = PaintingStyle.fill;
  
  for (int i = 0; i < 4; i++) {
    final angle = (i * 90) * (math.pi / 180);
    final radius = size.width * 0.3;
    final x = center.dx + radius * math.cos(angle);
    final y = center.dy + radius * math.sin(angle);
    
    // Add glow
    final glowPaint = Paint()
      ..color = primaryColor.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(Offset(x, y), size.width * 0.02, glowPaint);
    canvas.drawCircle(Offset(x, y), size.width * 0.015, indicatorPaint);
  }
}

void _drawPrescriptionPaper(Canvas canvas, Offset center, Size size, Color primaryColor) {
  // Paper with gradient
  final paperGradient = LinearGradient(
    colors: [
      Colors.white,
      const Color(0xFFFAFAFA),
    ],
  );
  
  final paperPaint = Paint()
    ..shader = paperGradient.createShader(Rect.fromCenter(
      center: Offset(center.dx + size.width * 0.08, center.dy),
      width: size.width * 0.2,
      height: size.height * 0.35,
    ));
  
  final paperRect = RRect.fromRectAndRadius(
    Rect.fromCenter(center: Offset(center.dx + size.width * 0.08, center.dy), width: size.width * 0.2, height: size.height * 0.35),
    const Radius.circular(8),
  );
  canvas.drawRRect(paperRect, paperPaint);
  
  // Paper border
  final borderPaint = Paint()
    ..color = primaryColor.withValues(alpha: 0.2)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2;
  
  canvas.drawRRect(paperRect, borderPaint);
  
  // Rx symbol
  _drawRxSymbol(canvas, center, size, primaryColor);
}

void _drawRxSymbol(Canvas canvas, Offset center, Size size, Color primaryColor) {
  final textPainter = TextPainter(
    text: TextSpan(
      text: 'Rx',
      style: TextStyle(
        fontSize: size.width * 0.06,
        color: primaryColor,
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

void _drawFloatingEyewear(Canvas canvas, Offset center, Size size, Color primaryColor) {
  // Glasses
  _drawFloatingGlasses(canvas, center, size, primaryColor);
  
  // Contacts
  _drawFloatingContacts(canvas, center, size, primaryColor);
}

void _drawModernTrophy(Canvas canvas, Offset center, Size size, Color primaryColor) {
  // Trophy cup with gradient
  final trophyGradient = LinearGradient(
    colors: [
      const Color(0xFFFFB74D),
      const Color(0xFFFF9800),
    ],
  );
  
  final trophyPaint = Paint()
    ..shader = trophyGradient.createShader(Rect.fromCenter(
      center: center,
      width: size.width * 0.12,
      height: size.height * 0.2,
    ));
  
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
  final baseGradient = LinearGradient(
    colors: [
      primaryColor,
      primaryColor.withValues(alpha: 0.8),
    ],
  );
  
  final basePaint = Paint()
    ..shader = baseGradient.createShader(Rect.fromCenter(
      center: Offset(center.dx, center.dy + size.height * 0.12),
      width: size.width * 0.15,
      height: size.height * 0.04,
    ));
  
  canvas.drawRRect(
    RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(center.dx, center.dy + size.height * 0.12), width: size.width * 0.15, height: size.height * 0.04),
      const Radius.circular(8),
    ),
    basePaint,
  );
}

void _drawProfessionalConfetti(Canvas canvas, Offset center, Size size) {
  final confettiColors = [
    const Color(0xFF4ECDC4),
    const Color(0xFFFFB74D),
    const Color(0xFF10B2D0),
    const Color(0xFFE91E63),
    const Color(0xFF9B59B6),
  ];
  
  for (int i = 0; i < 15; i++) {
    final angle = (i * 24) * (math.pi / 180);
    final radius = size.width * 0.35;
    final x = center.dx + radius * math.cos(angle);
    final y = center.dy + radius * math.sin(angle);
    
    final confettiPaint = Paint()
      ..color = confettiColors[i % confettiColors.length]
      ..style = PaintingStyle.fill;
    
    // Different shapes
    if (i % 3 == 0) {
      canvas.drawCircle(Offset(x, y), size.width * 0.015, confettiPaint);
    } else if (i % 3 == 1) {
      canvas.drawRect(
        Rect.fromCenter(center: Offset(x, y), width: size.width * 0.02, height: size.width * 0.02),
        confettiPaint,
      );
    } else {
      _drawStar(canvas, Offset(x, y), size.width * 0.015, confettiPaint);
    }
  }
}

void _drawCelebrationStars(Canvas canvas, Offset center, Size size, Color primaryColor) {
  final starPaint = Paint()
    ..color = primaryColor.withValues(alpha: 0.8)
    ..style = PaintingStyle.fill;
  
  for (int i = 0; i < 8; i++) {
    final angle = (i * 45) * (math.pi / 180);
    final radius = size.width * 0.25;
    final x = center.dx + radius * math.cos(angle);
    final y = center.dy + radius * math.sin(angle);
    _drawStar(canvas, Offset(x, y), size.width * 0.02, starPaint);
  }
}

void _drawFloatingElements(Canvas canvas, Offset center, Size size, Color primaryColor) {
  // Floating elements around the main eye
  _drawFloatingGlasses(canvas, center, size, primaryColor);
  _drawFloatingContacts(canvas, center, size, primaryColor);
  _drawMedicalCross(canvas, center, size, primaryColor);
}

void _drawDecorativeLines(Canvas canvas, Offset center, Size size, Color primaryColor) {
  final linePaint = Paint()
    ..color = primaryColor.withValues(alpha: 0.3)
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
