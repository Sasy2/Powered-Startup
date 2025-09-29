import 'package:flutter/material.dart';

class CustomProgressIndicator extends StatelessWidget {
  final double progress;
  final String label;
  final Color? color;
  final double height;

  const CustomProgressIndicator({
    super.key,
    required this.progress,
    required this.label,
    this.color,
    this.height = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF111718),
              ),
            ),
            Text(
              '${(progress * 100).round()}%',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color ?? const Color(0xFF10B2D0),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: const Color(0xFFE5E7EB),
          valueColor: AlwaysStoppedAnimation<Color>(
            color ?? const Color(0xFF10B2D0),
          ),
          minHeight: height,
        ),
      ],
    );
  }
}

class CustomCircularProgressIndicator extends StatelessWidget {
  final double progress;
  final String label;
  final Color? color;
  final double size;

  const CustomCircularProgressIndicator({
    super.key,
    required this.progress,
    required this.label,
    this.color,
    this.size = 80.0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: size,
          height: size,
          child: Stack(
            children: [
              Center(
                child: SizedBox(
                  width: size,
                  height: size,
                  child: CircularProgressIndicator(
                    value: progress,
                    backgroundColor: const Color(0xFFE5E7EB),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      color ?? const Color(0xFF10B2D0),
                    ),
                    strokeWidth: 6,
                  ),
                ),
              ),
              Center(
                child: Text(
                  '${(progress * 100).round()}%',
                  style: TextStyle(
                    fontSize: size * 0.2,
                    fontWeight: FontWeight.bold,
                    color: color ?? const Color(0xFF10B2D0),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF618389),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
