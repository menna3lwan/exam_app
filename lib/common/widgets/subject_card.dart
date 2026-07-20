import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/subject_model.dart';

/// Subject card matching the Figma "Explore" screen:
/// Rounded rectangle with subject illustration on the left + name on the right.
class SubjectCard extends StatelessWidget {
  final SubjectModel subject;
  final VoidCallback? onTap;

  const SubjectCard({
    super.key,
    required this.subject,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.md,
          vertical: AppDimensions.md,
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: AppRadius.mdRadius,
          border: Border.all(
            color: AppColors.lightBlue,
            width: 1,
          ),
          boxShadow: AppShadows.subtle,
        ),
        child: Row(
          children: [
            // ---- Subject illustration ----
            ClipRRect(
              borderRadius: AppRadius.smRadius,
              child: Image.asset(
                subject.icon,
                width: 56,
                height: 56,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(width: AppDimensions.md),
            // ---- Subject name ----
            Expanded(
              child: Text(
                subject.name,
                style: AppTextStyles.titleMedium.copyWith(
                  color: AppColors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
