import 'package:cached_network_image/cached_network_image.dart';
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
              child: CachedNetworkImage(
                imageUrl: subject.icon,
                width: 56,
                height: 56,
                fit: BoxFit.contain,
                placeholder: (_, __) => const SizedBox(
                  width: 56,
                  height: 56,
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                errorWidget: (_, __, ___) => Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.lightBlue,
                    borderRadius: AppRadius.smRadius,
                  ),
                  child: const Icon(
                    Icons.school_outlined,
                    color: AppColors.primary,
                    size: 28,
                  ),
                ),
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
