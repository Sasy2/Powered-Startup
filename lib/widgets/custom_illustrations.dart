import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Custom illustration widgets for consistent design throughout the app
class CustomIllustrations {
  
  /// Vision test completion illustration
  static Widget visionTestComplete({double? width, double? height}) {
    return CustomPaint(
      size: Size(width ?? 200, height ?? 200),
      painter: VisionTestCompletePainter(),
    );
  }

  /// Eye exam illustration
  static Widget eyeExam({double? width, double? height}) {
    return CustomPaint(
      size: Size(width ?? 200, height ?? 200),
      painter: EyeExamPainter(),
    );
  }

  /// Exercise illustration
  static Widget exercise({double? width, double? height}) {
    return CustomPaint(
      size: Size(width ?? 200, height ?? 200),
      painter: ExercisePainter(),
    );
  }

  /// Eye doctor consultation illustration
  static Widget eyeDoctor({double? width, double? height}) {
    return CustomPaint(
      size: Size(width ?? 200, height ?? 200),
      painter: EyeDoctorPainter(),
    );
  }

  /// Prescription renewal illustration
  static Widget prescriptionRenewal({double? width, double? height}) {
    return CustomPaint(
      size: Size(width ?? 200, height ?? 200),
      painter: PrescriptionRenewalPainter(),
    );
  }

  /// Success celebration illustration
  static Widget successCelebration({double? width, double? height}) {
    return CustomPaint(
      size: Size(width ?? 200, height ?? 200),
      painter: SuccessCelebrationPainter(),
    );
  }
}

/// Vision test completion painter
class VisionTestCompletePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final center = Offset(size.width / 2, size.height / 2);
    
    // Background circle
    paint.color = const Color(0xFFE3F2FD);
    canvas.drawCircle(center, size.width * 0.4, paint);
    
    // Eye icon
    paint.color = const Color(0xFF10B2D0);
    paint.style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromCenter(center: center, width: size.width * 0.3, height: size.height * 0.2),
      paint,
    );
    
    // Pupil
    paint.color = Colors.white;
    canvas.drawCircle(center, size.width * 0.08, paint);
    
    // Checkmark
    paint.color = const Color(0xFF4ECDC4);
    paint.strokeWidth = 4;
    paint.style = PaintingStyle.stroke;
    final checkPath = Path();
    checkPath.moveTo(center.dx - size.width * 0.1, center.dy);
    checkPath.lineTo(center.dx - size.width * 0.02, center.dy + size.height * 0.08);
    checkPath.lineTo(center.dx + size.width * 0.12, center.dy - size.height * 0.08);
    canvas.drawPath(checkPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Eye exam painter
class EyeExamPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final center = Offset(size.width / 2, size.height / 2);
    
    // Phone outline
    paint.color = const Color(0xFF10B2D0);
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 3;
    final phoneRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: center, width: size.width * 0.4, height: size.height * 0.6),
      const Radius.circular(20),
    );
    canvas.drawRRect(phoneRect, paint);
    
    // Eye chart on phone
    final textPainter = TextPainter(
      text: TextSpan(
        text: 'E\nFP\nTOZ',
        style: TextStyle(
          fontSize: size.width * 0.08,
          color: const Color(0xFF10B2D0),
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(center.dx - size.width * 0.1, center.dy - size.height * 0.15));
    
    // Hand holding phone
    paint.color = const Color(0xFFFFF3E0);
    paint.style = PaintingStyle.fill;
    final handPath = Path();
    handPath.moveTo(center.dx - size.width * 0.25, center.dy + size.height * 0.2);
    handPath.quadraticBezierTo(
      center.dx - size.width * 0.15, center.dy + size.height * 0.1,
      center.dx - size.width * 0.1, center.dy + size.height * 0.15,
    );
    handPath.quadraticBezierTo(
      center.dx - size.width * 0.05, center.dy + size.height * 0.2,
      center.dx, center.dy + size.height * 0.15,
    );
    handPath.quadraticBezierTo(
      center.dx + size.width * 0.05, center.dy + size.height * 0.1,
      center.dx + size.width * 0.15, center.dy + size.height * 0.15,
    );
    handPath.quadraticBezierTo(
      center.dx + size.width * 0.25, center.dy + size.height * 0.2,
      center.dx + size.width * 0.25, center.dy + size.height * 0.3,
    );
    handPath.close();
    canvas.drawPath(handPath, paint);
    
    // Floating elements
    _drawFloatingElement(canvas, center, size, -0.3, -0.2, Icons.visibility, const Color(0xFF10B2D0));
    _drawFloatingElement(canvas, center, size, 0.3, -0.1, Icons.medical_services, const Color(0xFF4ECDC4));
    _drawFloatingElement(canvas, center, size, -0.2, 0.3, Icons.star, const Color(0xFFFFB74D));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Exercise painter
class ExercisePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final center = Offset(size.width / 2, size.height / 2);
    
    // Person doing eye exercise
    paint.color = const Color(0xFFE3F2FD);
    paint.style = PaintingStyle.fill;
    canvas.drawCircle(center, size.width * 0.4, paint);
    
    // Head
    paint.color = const Color(0xFFFFF3E0);
    canvas.drawCircle(Offset(center.dx, center.dy - size.height * 0.1), size.width * 0.15, paint);
    
    // Eyes
    paint.color = const Color(0xFF10B2D0);
    canvas.drawCircle(Offset(center.dx - size.width * 0.05, center.dy - size.height * 0.1), size.width * 0.03, paint);
    canvas.drawCircle(Offset(center.dx + size.width * 0.05, center.dy - size.height * 0.1), size.width * 0.03, paint);
    
    // Exercise movement lines
    paint.color = const Color(0xFF4ECDC4);
    paint.strokeWidth = 3;
    paint.style = PaintingStyle.stroke;
    for (int i = 0; i < 3; i++) {
      final angle = (i * 120) * (3.14159 / 180);
      final startX = center.dx + (size.width * 0.2) * cos(angle);
      final startY = center.dy + (size.height * 0.2) * sin(angle);
      final endX = center.dx + (size.width * 0.3) * cos(angle);
      final endY = center.dy + (size.height * 0.3) * sin(angle);
      canvas.drawLine(Offset(startX, startY), Offset(endX, endY), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Eye doctor painter
class EyeDoctorPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final center = Offset(size.width / 2, size.height / 2);
    
    // Doctor figure
    paint.color = const Color(0xFFE3F2FD);
    paint.style = PaintingStyle.fill;
    canvas.drawCircle(center, size.width * 0.4, paint);
    
    // Doctor head with stethoscope
    paint.color = const Color(0xFFFFF3E0);
    canvas.drawCircle(Offset(center.dx, center.dy - size.height * 0.1), size.width * 0.15, paint);
    
    // Stethoscope
    paint.color = const Color(0xFF10B2D0);
    paint.strokeWidth = 3;
    paint.style = PaintingStyle.stroke;
    final stethPath = Path();
    stethPath.moveTo(center.dx - size.width * 0.1, center.dy - size.height * 0.05);
    stethPath.quadraticBezierTo(
      center.dx - size.width * 0.15, center.dy - size.height * 0.15,
      center.dx - size.width * 0.05, center.dy - size.height * 0.2,
    );
    canvas.drawPath(stethPath, paint);
    
    // AI/Chat bubbles
    _drawChatBubble(canvas, center, size, 0.2, -0.1, "Hi! I'm EyeDoctor");
    _drawChatBubble(canvas, center, size, -0.2, 0.1, "How can I help?");
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Prescription renewal painter
class PrescriptionRenewalPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final center = Offset(size.width / 2, size.height / 2);
    
    // Phone with prescription
    paint.color = const Color(0xFF10B2D0);
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 3;
    final phoneRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: center, width: size.width * 0.4, height: size.height * 0.6),
      const Radius.circular(20),
    );
    canvas.drawRRect(phoneRect, paint);
    
    // Prescription paper
    paint.color = Colors.white;
    paint.style = PaintingStyle.fill;
    final paperRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(center.dx + size.width * 0.1, center.dy), width: size.width * 0.25, height: size.height * 0.4),
      const Radius.circular(8),
    );
    canvas.drawRRect(paperRect, paint);
    
    // Rx symbol
    final rxTextPainter = TextPainter(
      text: TextSpan(
        text: 'Rx',
        style: TextStyle(
          fontSize: size.width * 0.08,
          color: const Color(0xFF10B2D0),
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    rxTextPainter.layout();
    rxTextPainter.paint(canvas, Offset(center.dx + size.width * 0.05, center.dy - size.height * 0.1));
    
    // Glasses floating around
    _drawFloatingElement(canvas, center, size, -0.3, -0.2, Icons.visibility, const Color(0xFF10B2D0));
    _drawFloatingElement(canvas, center, size, 0.3, -0.1, Icons.visibility, const Color(0xFF4ECDC4));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Success celebration painter
class SuccessCelebrationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final center = Offset(size.width / 2, size.height / 2);
    
    // Celebration background
    paint.color = const Color(0xFFE8F5E8);
    canvas.drawCircle(center, size.width * 0.4, paint);
    
    // Trophy/cup
    paint.color = const Color(0xFFFFB74D);
    paint.style = PaintingStyle.fill;
    final trophyPath = Path();
    trophyPath.moveTo(center.dx - size.width * 0.08, center.dy + size.height * 0.1);
    trophyPath.lineTo(center.dx - size.width * 0.08, center.dy - size.height * 0.1);
    trophyPath.lineTo(center.dx - size.width * 0.05, center.dy - size.height * 0.15);
    trophyPath.lineTo(center.dx + size.width * 0.05, center.dy - size.height * 0.15);
    trophyPath.lineTo(center.dx + size.width * 0.08, center.dy - size.height * 0.1);
    trophyPath.lineTo(center.dx + size.width * 0.08, center.dy + size.height * 0.1);
    trophyPath.close();
    canvas.drawPath(trophyPath, paint);
    
    // Base
    paint.color = const Color(0xFF4ECDC4);
    canvas.drawRect(
      Rect.fromCenter(center: Offset(center.dx, center.dy + size.height * 0.15), width: size.width * 0.2, height: size.height * 0.05),
      paint,
    );
    
    // Confetti
    for (int i = 0; i < 8; i++) {
      final angle = (i * 45) * (3.14159 / 180);
      final x = center.dx + (size.width * 0.3) * cos(angle);
      final y = center.dy + (size.height * 0.3) * sin(angle);
      paint.color = [const Color(0xFF4ECDC4), const Color(0xFFFFB74D), const Color(0xFF10B2D0)][i % 3];
      canvas.drawCircle(Offset(x, y), size.width * 0.02, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Helper method to draw floating elements
void _drawFloatingElement(Canvas canvas, Offset center, Size size, double offsetX, double offsetY, IconData icon, Color color) {
  final paint = Paint();
  paint.color = color;
  paint.style = PaintingStyle.fill;
  
  final x = center.dx + (size.width * offsetX);
  final y = center.dy + (size.height * offsetY);
  
  // Simple circle for floating elements
  canvas.drawCircle(Offset(x, y), size.width * 0.05, paint);
}

/// Helper method to draw chat bubbles
void _drawChatBubble(Canvas canvas, Offset center, Size size, double offsetX, double offsetY, String text) {
  final paint = Paint();
  paint.color = const Color(0xFFE3F2FD);
  paint.style = PaintingStyle.fill;
  
  final x = center.dx + (size.width * offsetX);
  final y = center.dy + (size.height * offsetY);
  
  final bubbleRect = RRect.fromRectAndRadius(
    Rect.fromCenter(center: Offset(x, y), width: size.width * 0.3, height: size.height * 0.15),
    const Radius.circular(15),
  );
  canvas.drawRRect(bubbleRect, paint);
  
  // Text in bubble
  paint.color = const Color(0xFF10B2D0);
  final textPainter = TextPainter(
    text: TextSpan(
      text: text,
      style: TextStyle(
        fontSize: size.width * 0.04,
        color: const Color(0xFF10B2D0),
      ),
    ),
    textDirection: TextDirection.ltr,
  );
  textPainter.layout();
  textPainter.paint(canvas, Offset(x - textPainter.width / 2, y - textPainter.height / 2));
}

/// Helper method for cos function
double cos(double angle) {
  return math.cos(angle);
}

/// Helper method for sin function  
double sin(double angle) {
  return math.sin(angle);
}
