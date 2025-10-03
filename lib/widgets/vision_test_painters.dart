import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Custom painter for fan chart astigmatism test
class FanChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 20;

    // Draw 24 radial lines (15 degrees apart) with varying thickness
    for (int i = 0; i < 24; i++) {
      final paint = Paint()
        ..color = Colors.black
        ..strokeWidth = i % 3 == 0 ? 3.0 : 1.5 // Make every 3rd line thicker
        ..style = PaintingStyle.stroke;
      
      final angle = (i * 15) * math.pi / 180;
      final endX = center.dx + radius * math.cos(angle);
      final endY = center.dy + radius * math.sin(angle);
      
      canvas.drawLine(center, Offset(endX, endY), paint);
    }

    // Draw center circle
    final centerPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 8, centerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Custom painter for clock dial astigmatism test
class ClockDialPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 20;

    // Draw clock face circle
    final circlePaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, radius, circlePaint);

    // Draw 12 hour lines with varying thickness
    for (int i = 0; i < 12; i++) {
      final paint = Paint()
        ..color = Colors.black
        ..strokeWidth = i % 3 == 0 ? 3.0 : 2.0 // Make every 3rd line thicker
        ..style = PaintingStyle.stroke;
      
      final angle = (i * 30) * math.pi / 180;
      final innerRadius = radius - 25;
      final outerRadius = radius - 8;
      
      final startX = center.dx + innerRadius * math.cos(angle);
      final startY = center.dy + innerRadius * math.sin(angle);
      final endX = center.dx + outerRadius * math.cos(angle);
      final endY = center.dy + outerRadius * math.sin(angle);
      
      canvas.drawLine(Offset(startX, startY), Offset(endX, endY), paint);
    }

    // Draw hour numbers
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    for (int i = 0; i < 12; i++) {
      final angle = (i * 30) * math.pi / 180;
      final numberRadius = radius - 35;
      final x = center.dx + numberRadius * math.cos(angle) - 10;
      final y = center.dy + numberRadius * math.sin(angle) - 10;
      
      textPainter.text = TextSpan(
        text: '${i == 0 ? 12 : i}',
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(x, y));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Custom painter for parallel lines astigmatism test
class ParallelLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final centerY = size.height / 2;
    final lineSpacing = 15.0;
    final lineLength = size.width - 40;

    // Draw top set of parallel lines
    for (int i = 0; i < 5; i++) {
      final y = centerY - 30 + (i * lineSpacing);
      canvas.drawLine(
        Offset(20, y),
        Offset(20 + lineLength, y),
        paint,
      );
    }

    // Draw bottom set of parallel lines (slightly different spacing)
    for (int i = 0; i < 5; i++) {
      final y = centerY + 30 + (i * lineSpacing);
      canvas.drawLine(
        Offset(20, y),
        Offset(20 + lineLength, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Custom painter for Ishihara color vision test plates
class IshiharaPlatePainter extends CustomPainter {
  final int plateNumber;

  IshiharaPlatePainter({required this.plateNumber});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;

    // Create a gradient background
    final gradient = RadialGradient(
      colors: _getPlateColors(plateNumber),
      stops: const [0.0, 0.5, 1.0],
    );

    final paint = Paint()
      ..shader = gradient.createShader(Rect.fromCircle(center: center, radius: radius));

    // Draw the circular plate
    canvas.drawCircle(center, radius, paint);

    // Draw the number pattern (simplified)
    _drawNumberPattern(canvas, center, plateNumber);
  }

  List<Color> _getPlateColors(int plateNumber) {
    switch (plateNumber) {
      case 1: // Number 12
        return [const Color(0xFFE57373), const Color(0xFFF48FB1), const Color(0xFFBA68C8)];
      case 2: // Number 8
        return [const Color(0xFF81C784), const Color(0xFF4DB6AC), const Color(0xFF26A69A)];
      case 3: // Number 6
        return [const Color(0xFFFFB74D), const Color(0xFFFF8A65), const Color(0xFFFF7043)];
      case 4: // Number 3
        return [const Color(0xFF64B5F6), const Color(0xFF42A5F5), const Color(0xFF2196F3)];
      case 5: // Number 5
        return [const Color(0xFFA5D6A7), const Color(0xFF81C784), const Color(0xFF66BB6A)];
      default:
        return [const Color(0xFFE0E0E0), const Color(0xFFBDBDBD), const Color(0xFF9E9E9E)];
    }
  }

  void _drawNumberPattern(Canvas canvas, Offset center, int plateNumber) {
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    String numberText;
    Color textColor;
    
    switch (plateNumber) {
      case 1:
        numberText = '12';
        textColor = const Color(0xFF2E7D32);
        break;
      case 2:
        numberText = '8';
        textColor = const Color(0xFFD32F2F);
        break;
      case 3:
        numberText = '6';
        textColor = const Color(0xFF1976D2);
        break;
      case 4:
        numberText = '3';
        textColor = const Color(0xFFFF8F00);
        break;
      case 5:
        numberText = '5';
        textColor = const Color(0xFF7B1FA2);
        break;
      default:
        numberText = '?';
        textColor = Colors.black;
    }

    textPainter.text = TextSpan(
      text: numberText,
      style: TextStyle(
        color: textColor,
        fontSize: 80,
        fontWeight: FontWeight.bold,
      ),
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        center.dx - textPainter.width / 2,
        center.dy - textPainter.height / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
