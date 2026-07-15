import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Explore tab — placeholder for Step 2 implementation.
///
/// Shows the "Survey" title and "Browse by subject" header structure
/// that will be populated with subject cards.
class ExploreTab extends StatelessWidget {
  const ExploreTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppDimensions.lg),
            // ---- Title ----
            Text(
              'Survey',
              style: AppTextStyles.headlineSmall.copyWith(
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: AppDimensions.md),
            // ---- Placeholder ----
            Expanded(
              child: Center(
                child: Text(
                  'Subjects will appear here',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.gray,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
