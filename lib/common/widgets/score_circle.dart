import 'dart:math';

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

/// Circular score indicator matching the Figma "Score" screen.
///
/// Draws a thick ring with two arcs:
///   • Primary (blue) arc for the correct-answer proportion.
///   • Error (red) arc for the incorrect-answer proportion.
///   • Remaining track (light gray) for unanswered questions (if any).
///
/// The percentage is displayed in the center of the ring.
class ScoreCircle extends StatelessWidget {
  /// Score percentage (0–100).
  final double percentage;

  /// Number of correct answers — drives the blue arc length.
  final int correct;

  /// Number of wrong answers — drives the red arc length.
  final int wrong;

  /// Total number of questions.
  final int total;

  /// Outer diameter of the widget. Defaults to 160.
  final double size;

  const ScoreCircle({
    super.key,
    required this.percentage,
    required this.correct,
    required this.wrong,
    required this.total,
    this.size = 160,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _ScoreCirclePainter(
          correctFraction: total > 0 ? correct / total : 0,
          wrongFraction: total > 0 ? wrong / total : 0,
        ),
        child: Center(
          child: Text(
            '${percentage.round()}%',
            style: AppTextStyles.headlineLarge.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class _ScoreCirclePainter extends CustomPainter {
  final double correctFraction;
  final double wrongFraction;

  _ScoreCirclePainter({
    required this.correctFraction,
    required this.wrongFraction,
  });

  static const double _strokeWidth = 12;
  static const double _startAngle = -pi / 2; // 12-o'clock

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (min(size.width, size.height) - _strokeWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final trackPaint = Paint()
      ..color = AppColors.lightBlue
      ..style = PaintingStyle.stroke
      ..strokeWidth = _strokeWidth
      ..strokeCap = StrokeCap.round;

    final correctPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = _strokeWidth
      ..strokeCap = StrokeCap.round;

    final wrongPaint = Paint()
      ..color = AppColors.error
      ..style = PaintingStyle.stroke
      ..strokeWidth = _strokeWidth
      ..strokeCap = StrokeCap.round;

    // 1. Draw full track
    canvas.drawCircle(center, radius, trackPaint);

    // 2. Draw correct (blue) arc — starts at 12-o'clock
    final correctSweep = correctFraction * 2 * pi;
    if (correctSweep > 0) {
      canvas.drawArc(rect, _startAngle, correctSweep, false, correctPaint);
    }

    // 3. Draw wrong (red) arc — starts where correct ends
    final wrongSweep = wrongFraction * 2 * pi;
    if (wrongSweep > 0) {
      canvas.drawArc(
        rect,
        _startAngle + correctSweep,
        wrongSweep,
        false,
        wrongPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_ScoreCirclePainter oldDelegate) {
    return oldDelegate.correctFraction != correctFraction ||
        oldDelegate.wrongFraction != wrongFraction;
  }
}
