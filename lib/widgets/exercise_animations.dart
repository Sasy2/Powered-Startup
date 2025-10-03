import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../models/exercise_models.dart';

/// Animated dot widget for eye tracking exercises
class AnimatedDot extends StatefulWidget {
  final ExerciseAnimationConfig config;
  final VoidCallback? onComplete;
  final bool isActive;

  const AnimatedDot({
    super.key,
    required this.config,
    this.onComplete,
    this.isActive = true,
  });

  @override
  State<AnimatedDot> createState() => _AnimatedDotState();
}

class _AnimatedDotState extends State<AnimatedDot>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _positionAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _controller = AnimationController(
      duration: Duration(milliseconds: widget.config.durationMs),
      vsync: this,
    );

    // Scale animation for zooming effect
    _scaleAnimation = Tween<double>(
      begin: widget.config.parameters['minSize'] ?? 10.0,
      end: widget.config.parameters['maxSize'] ?? 30.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    // Position animation for movement
    if (widget.config.parameters['path'] == 'circular') {
      _positionAnimation = Tween<Offset>(
        begin: const Offset(0, 0),
        end: const Offset(0, 0),
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.linear,
      ));
    } else {
      _positionAnimation = Tween<Offset>(
        begin: const Offset(-150, 0),
        end: const Offset(150, 0),
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ));
    }

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));

    if (widget.isActive) {
      _controller.repeat();
    }

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && widget.onComplete != null) {
        widget.onComplete!();
      }
    });
  }

  @override
  void didUpdateWidget(AnimatedDot oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive) {
        _controller.repeat();
      } else {
        _controller.stop();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: DotPainter(
            animation: _animation.value,
            scale: _scaleAnimation.value,
            position: _positionAnimation.value,
            config: widget.config,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

/// Custom painter for drawing animated dots
class DotPainter extends CustomPainter {
  final double animation;
  final double scale;
  final Offset position;
  final ExerciseAnimationConfig config;

  DotPainter({
    required this.animation,
    required this.scale,
    required this.position,
    required this.config,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = Color(config.parameters['color'] ?? 0xFF10B2D0)
      ..style = PaintingStyle.fill;

    if (config.parameters['path'] == 'circular') {
      _drawCircularPath(canvas, center, paint);
    } else {
      _drawLinearPath(canvas, center, paint);
    }
  }

  void _drawCircularPath(Canvas canvas, Offset center, Paint paint) {
    final radius = config.parameters['radius'] ?? 100.0;
    final angle = animation * 2 * math.pi;
    final x = center.dx + radius * math.cos(angle);
    final y = center.dy + radius * math.sin(angle);
    
    canvas.drawCircle(Offset(x, y), scale / 2, paint);
  }

  void _drawLinearPath(Canvas canvas, Offset center, Paint paint) {
    final x = center.dx + position.dx;
    final y = center.dy + position.dy;
    
    canvas.drawCircle(Offset(x, y), scale / 2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Animated figure-8 widget
class AnimatedFigure8 extends StatefulWidget {
  final ExerciseAnimationConfig config;
  final VoidCallback? onComplete;
  final bool isActive;

  const AnimatedFigure8({
    super.key,
    required this.config,
    this.onComplete,
    this.isActive = true,
  });

  @override
  State<AnimatedFigure8> createState() => _AnimatedFigure8State();
}

class _AnimatedFigure8State extends State<AnimatedFigure8>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _controller = AnimationController(
      duration: Duration(milliseconds: widget.config.durationMs),
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));

    if (widget.isActive) {
      _controller.repeat();
    }

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && widget.onComplete != null) {
        widget.onComplete!();
      }
    });
  }

  @override
  void didUpdateWidget(AnimatedFigure8 oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive) {
        _controller.repeat();
      } else {
        _controller.stop();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: Figure8Painter(
            animation: _animation.value,
            config: widget.config,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

/// Custom painter for figure-8 pattern
class Figure8Painter extends CustomPainter {
  final double animation;
  final ExerciseAnimationConfig config;

  Figure8Painter({
    required this.animation,
    required this.config,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = Color(config.parameters['color'] ?? 0xFF10B2D0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    final width = config.parameters['width'] ?? 200.0;
    final height = config.parameters['height'] ?? 100.0;

    _drawFigure8(canvas, center, paint, width, height);
  }

  void _drawFigure8(Canvas canvas, Offset center, Paint paint, double width, double height) {
    final path = Path();
    final t = animation * 2 * math.pi;
    
    // Figure-8 parametric equations
    final x = center.dx + (width / 2) * math.sin(t);
    final y = center.dy + (height / 2) * math.sin(2 * t);
    
    // Draw the path
    for (double i = 0; i <= 1; i += 0.01) {
      final t = i * 2 * math.pi;
      final x = center.dx + (width / 2) * math.sin(t);
      final y = center.dy + (height / 2) * math.sin(2 * t);
      
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    
    canvas.drawPath(path, paint);
    
    // Draw the moving dot
    final dotPaint = Paint()
      ..color = Color(config.parameters['color'] ?? 0xFF10B2D0)
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(Offset(x, y), 8, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Animated radial lines widget
class AnimatedRadialLines extends StatefulWidget {
  final ExerciseAnimationConfig config;
  final VoidCallback? onComplete;
  final bool isActive;

  const AnimatedRadialLines({
    super.key,
    required this.config,
    this.onComplete,
    this.isActive = true,
  });

  @override
  State<AnimatedRadialLines> createState() => _AnimatedRadialLinesState();
}

class _AnimatedRadialLinesState extends State<AnimatedRadialLines>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  late Animation<double> _darkeningAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _controller = AnimationController(
      duration: Duration(milliseconds: widget.config.durationMs),
      vsync: this,
    );

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));

    _darkeningAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    if (widget.isActive) {
      _controller.repeat();
    }

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && widget.onComplete != null) {
        widget.onComplete!();
      }
    });
  }

  @override
  void didUpdateWidget(AnimatedRadialLines oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive) {
        _controller.repeat();
      } else {
        _controller.stop();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: RadialLinesPainter(
            rotation: _rotationAnimation.value,
            darkening: _darkeningAnimation.value,
            config: widget.config,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

/// Custom painter for radial lines
class RadialLinesPainter extends CustomPainter {
  final double rotation;
  final double darkening;
  final ExerciseAnimationConfig config;

  RadialLinesPainter({
    required this.rotation,
    required this.darkening,
    required this.config,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final lineCount = config.parameters['lineCount'] ?? 12;
    final radius = config.parameters['radius'] ?? 120.0;

    for (int i = 0; i < lineCount; i++) {
      final angle = (i * 2 * math.pi / lineCount) + rotation;
      final opacity = 0.3 + (darkening * 0.7);
      
      final paint = Paint()
        ..color = Color(config.parameters['color'] ?? 0xFF10B2D0)
            .withValues(alpha: opacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;

      final endX = center.dx + radius * math.cos(angle);
      final endY = center.dy + radius * math.sin(angle);
      
      canvas.drawLine(center, Offset(endX, endY), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Animated text widget for focus exercises
class AnimatedText extends StatefulWidget {
  final ExerciseAnimationConfig config;
  final VoidCallback? onComplete;
  final bool isActive;

  const AnimatedText({
    super.key,
    required this.config,
    this.onComplete,
    this.isActive = true,
  });

  @override
  State<AnimatedText> createState() => _AnimatedTextState();
}

class _AnimatedTextState extends State<AnimatedText>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _controller = AnimationController(
      duration: Duration(milliseconds: widget.config.durationMs),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: widget.config.parameters['minSize'] ?? 20.0,
      end: widget.config.parameters['maxSize'] ?? 80.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _opacityAnimation = Tween<double>(
      begin: 0.7,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    if (widget.isActive) {
      _controller.repeat(reverse: true);
    }

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && widget.onComplete != null) {
        widget.onComplete!();
      }
    });
  }

  @override
  void didUpdateWidget(AnimatedText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive) {
        _controller.repeat(reverse: true);
      } else {
        _controller.stop();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Center(
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: Text(
              widget.config.parameters['text'] ?? 'A',
              style: TextStyle(
                fontSize: _scaleAnimation.value,
                color: Color(widget.config.parameters['color'] ?? 0xFF10B2D0),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Flashing dots widget for saccades exercise
class FlashingDots extends StatefulWidget {
  final ExerciseAnimationConfig config;
  final VoidCallback? onComplete;
  final bool isActive;

  const FlashingDots({
    super.key,
    required this.config,
    this.onComplete,
    this.isActive = true,
  });

  @override
  State<FlashingDots> createState() => _FlashingDotsState();
}

class _FlashingDotsState extends State<FlashingDots>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _flashAnimation;
  // int _currentDotIndex = 0;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _controller = AnimationController(
      duration: Duration(milliseconds: widget.config.durationMs),
      vsync: this,
    );

    _flashAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    if (widget.isActive) {
      _controller.repeat();
    }

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && widget.onComplete != null) {
        widget.onComplete!();
      }
    });
  }

  @override
  void didUpdateWidget(FlashingDots oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive) {
        _controller.repeat();
      } else {
        _controller.stop();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: FlashingDotsPainter(
            animation: _flashAnimation.value,
            config: widget.config,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

/// Custom painter for flashing dots
class FlashingDotsPainter extends CustomPainter {
  final double animation;
  final ExerciseAnimationConfig config;

  FlashingDotsPainter({
    required this.animation,
    required this.config,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final positions = config.parameters['positions'] as List<dynamic>? ?? [];
    final flashDuration = config.parameters['flashDuration'] ?? 2000.0;
    final pauseDuration = config.parameters['pauseDuration'] ?? 1000.0;
    final totalCycle = flashDuration + pauseDuration;
    
    final cycleProgress = (animation * totalCycle) % totalCycle;
    final isFlashing = cycleProgress < flashDuration;
    final dotIndex = ((animation * totalCycle) / totalCycle * positions.length).floor() % positions.length;
    
    if (isFlashing && positions.isNotEmpty) {
      final position = positions[dotIndex] as Map<String, dynamic>;
      final x = center.dx + (position['x'] ?? 0.0);
      final y = center.dy + (position['y'] ?? 0.0);
      
      final paint = Paint()
        ..color = Color(config.parameters['color'] ?? 0xFF10B2D0)
        ..style = PaintingStyle.fill;
      
      canvas.drawCircle(Offset(x, y), 12, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
