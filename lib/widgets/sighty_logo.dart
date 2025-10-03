import 'package:flutter/material.dart';

class SightyLogo extends StatelessWidget {
  final double size;
  final Color? primaryColor;
  final Color? backgroundColor;

  const SightyLogo({
    super.key,
    this.size = 40.0,
    this.primaryColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final primary = primaryColor ?? const Color(0xFF10B2D0);
    final background = backgroundColor ?? Colors.white;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(size * 0.2), // 20% rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: CustomPaint(
        painter: SightyLogoPainter(
          primaryColor: primary,
          size: size,
        ),
      ),
    );
  }
}

class SightyLogoPainter extends CustomPainter {
  final Color primaryColor;
  final double size;

  SightyLogoPainter({
    required this.primaryColor,
    required this.size,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill
      ..strokeWidth = 2.0;

    final strokePaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.15; // 15% of size for eye radius
    final frameThickness = size.width * 0.08; // 8% for frame thickness
    final frameGap = size.width * 0.12; // 12% gap in frame

    // Draw the outer frame (4 L-shaped corners)
    _drawFrame(canvas, size, strokePaint, frameThickness, frameGap);

    // Draw the central eye
    _drawEye(canvas, center, radius, paint, strokePaint);

    // Draw circuit/scan lines
    _drawCircuitLines(canvas, center, radius, paint);
  }

  void _drawFrame(Canvas canvas, Size size, Paint paint, double thickness, double gap) {
    final halfGap = gap / 2;
    final halfThickness = thickness / 2;

    // Top-left corner
    canvas.drawLine(
      Offset(halfGap, halfThickness),
      Offset(halfGap, thickness),
      paint,
    );
    canvas.drawLine(
      Offset(halfThickness, halfGap),
      Offset(thickness, halfGap),
      paint,
    );

    // Top-right corner
    canvas.drawLine(
      Offset(size.width - halfGap, halfThickness),
      Offset(size.width - halfGap, thickness),
      paint,
    );
    canvas.drawLine(
      Offset(size.width - halfThickness, halfGap),
      Offset(size.width - thickness, halfGap),
      paint,
    );

    // Bottom-left corner
    canvas.drawLine(
      Offset(halfGap, size.height - halfThickness),
      Offset(halfGap, size.height - thickness),
      paint,
    );
    canvas.drawLine(
      Offset(halfThickness, size.height - halfGap),
      Offset(thickness, size.height - halfGap),
      paint,
    );

    // Bottom-right corner
    canvas.drawLine(
      Offset(size.width - halfGap, size.height - halfThickness),
      Offset(size.width - halfGap, size.height - thickness),
      paint,
    );
    canvas.drawLine(
      Offset(size.width - halfThickness, size.height - halfGap),
      Offset(size.width - thickness, size.height - halfGap),
      paint,
    );
  }

  void _drawEye(Canvas canvas, Offset center, double radius, Paint fillPaint, Paint strokePaint) {
    // Draw pupil (black circle)
    final pupilPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius * 0.3, pupilPaint);

    // Draw iris/sclera (curved lines above and below pupil)
    final path = Path();
    final eyeWidth = radius * 1.2;
    final eyeHeight = radius * 0.6;

    // Upper curve
    path.moveTo(center.dx - eyeWidth / 2, center.dy - eyeHeight / 2);
    path.quadraticBezierTo(
      center.dx,
      center.dy - eyeHeight,
      center.dx + eyeWidth / 2,
      center.dy - eyeHeight / 2,
    );

    // Lower curve
    path.moveTo(center.dx - eyeWidth / 2, center.dy + eyeHeight / 2);
    path.quadraticBezierTo(
      center.dx,
      center.dy + eyeHeight,
      center.dx + eyeWidth / 2,
      center.dy + eyeHeight / 2,
    );

    canvas.drawPath(path, strokePaint);
  }

  void _drawCircuitLines(Canvas canvas, Offset center, double radius, Paint paint) {
    final lineLength = radius * 1.5;
    final dotRadius = radius * 0.15;

    // Left side circuit lines (from lower part of eye)
    final leftStart = Offset(center.dx - radius * 0.8, center.dy + radius * 0.3);
    final leftEnd1 = Offset(center.dx - lineLength, center.dy + radius * 0.8);
    final leftEnd2 = Offset(center.dx - lineLength, center.dy + radius * 1.2);

    canvas.drawLine(leftStart, leftEnd1, paint);
    canvas.drawLine(leftStart, leftEnd2, paint);

    // Draw dots at the end of left lines
    canvas.drawCircle(leftEnd1, dotRadius, paint);
    canvas.drawCircle(leftEnd2, dotRadius, paint);

    // Right side circuit lines (from upper part of eye, slightly lighter)
    final rightPaint = Paint()
      ..color = primaryColor.withValues(alpha: 0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final rightStart = Offset(center.dx + radius * 0.8, center.dy - radius * 0.3);
    final rightEnd1 = Offset(center.dx + lineLength, center.dy - radius * 0.8);
    final rightEnd2 = Offset(center.dx + lineLength, center.dy - radius * 1.2);

    canvas.drawLine(rightStart, rightEnd1, rightPaint);
    canvas.drawLine(rightStart, rightEnd2, rightPaint);

    // Draw dots at the end of right lines
    canvas.drawCircle(rightEnd1, dotRadius, rightPaint);
    canvas.drawCircle(rightEnd2, dotRadius, rightPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is SightyLogoPainter &&
        (oldDelegate.primaryColor != primaryColor || oldDelegate.size != size);
  }
}
