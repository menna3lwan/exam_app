import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/exam_model.dart';

/// Exam card matching the Figma "Explore > Languages" screen.
///
/// Layout:
///   [icon]  "High level"                    "30 Minutes" (blue)
///           "20 Question"
///           "From: 1.00 To: 6.00"
class ExamCard extends StatelessWidget {
  final ExamModel exam;
  final String subjectIcon; // illustration asset path
  final VoidCallback? onTap;

  const ExamCard({
    super.key,
    required this.exam,
    required this.subjectIcon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.md),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: AppRadius.mdRadius,
          border: Border.all(color: AppColors.lightBlue, width: 1),
          boxShadow: AppShadows.subtle,
        ),
        child: Row(
          children: [
            // ---- Subject illustration ----
            ClipRRect(
              borderRadius: AppRadius.smRadius,
              child: Image.asset(
                subjectIcon,
                width: 48,
                height: 48,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(width: AppDimensions.md),
            // ---- Exam info (middle) ----
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'High level',
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${exam.numberOfQuestions} Question',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.gray,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'From: 1.00 To: 6.00',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.gray,
                    ),
                  ),
                ],
              ),
            ),
            // ---- Duration (right, blue) ----
            Text(
              '${exam.duration} Minutes',
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
