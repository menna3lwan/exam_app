import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/exam_model.dart';

/// Exam card — flat list layout (no grouping, no From/To).
///
/// Layout:
///   [icon]  exam.title                       "30 Minutes" (blue)
///           "20 Questions"
class ExamCard extends StatelessWidget {
  final ExamModel exam;
  final String subjectIcon; // URL from API
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
              child: CachedNetworkImage(
                imageUrl: subjectIcon,
                width: 48,
                height: 48,
                fit: BoxFit.contain,
                placeholder: (_, __) => const SizedBox(
                  width: 48,
                  height: 48,
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                errorWidget: (_, __, ___) => Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.lightBlue,
                    borderRadius: AppRadius.smRadius,
                  ),
                  child: const Icon(
                    Icons.quiz_outlined,
                    color: AppColors.primary,
                    size: 24,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppDimensions.md),
            // ---- Exam info (middle) ----
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exam.title,
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${exam.numberOfQuestions} Questions',
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
