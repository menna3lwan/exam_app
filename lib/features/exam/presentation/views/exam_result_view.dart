import 'package:flutter/material.dart';

import '../../../../common/widgets/app_button.dart';
import '../../../../common/widgets/score_circle.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/routing/route_arguments.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Exam score screen matching the Figma "Score" frame.
///
/// Purely presentational — receives [ExamResultArgs] via route and
/// displays the score breakdown. No cubit needed.
class ExamResultView extends StatelessWidget {
  const ExamResultView({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as ExamResultArgs?;

    if (args == null) {
      return Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(leading: const BackButton()),
        body: const Center(child: Text('Result not found')),
      );
    }

    return _ExamResultBody(args: args);
  }
}

class _ExamResultBody extends StatelessWidget {
  final ExamResultArgs args;
  const _ExamResultBody({required this.args});

  @override
  Widget build(BuildContext context) {
    final result = args.result;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        surfaceTintColor: Colors.transparent,
        leading: BackButton(
          onPressed: () => Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.home,
            (route) => false,
          ),
        ),
        title: Text(
          'Exam score',
          style: AppTextStyles.titleMedium,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.lg),
        child: Column(
          children: [
            const SizedBox(height: AppDimensions.xl),

            // ── "Your score" header ──
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Your score',
                style: AppTextStyles.titleLarge.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            const SizedBox(height: AppDimensions.xl),

            // ── Score circle + legend row ──
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Circular progress
                ScoreCircle(
                  percentage: result.percentage,
                  correct: result.correct,
                  wrong: result.wrong,
                  total: result.total,
                ),

                const SizedBox(width: AppDimensions.lg),

                // Legend column
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _LegendItem(
                      label: 'Correct',
                      count: result.correct,
                      color: AppColors.primary,
                    ),
                    const SizedBox(height: AppDimensions.md),
                    _LegendItem(
                      label: 'Incorrect',
                      count: result.wrong,
                      color: AppColors.error,
                    ),
                  ],
                ),
              ],
            ),

            const Spacer(),

            // ── Action buttons ──
            AppButton(
              label: 'Show results',
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.answersReview,
                  arguments: AnswersReviewArgs(
                    questions: args.questions,
                    userAnswers: args.userAnswers,
                  ),
                );
              },
            ),

            const SizedBox(height: AppDimensions.sm),

            AppButton(
              label: 'Start again',
              isOutlined: true,
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.home,
                  (route) => false,
                );
              },
            ),

            const SizedBox(height: AppDimensions.xl),
          ],
        ),
      ),
    );
  }
}

/// Single legend row: colored label + circular count badge.
class _LegendItem extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const _LegendItem({
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(color: color),
        ),
        const SizedBox(width: AppDimensions.sm),
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 1.5),
          ),
          alignment: Alignment.center,
          child: Text(
            '$count',
            style: AppTextStyles.labelSmall.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
