import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../common/widgets/subject_card.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../data/mock/mock_data.dart';

/// Explore tab — main subjects screen matching the Figma "Explore" frame.
///
/// Layout (top to bottom):
///   "Survey" title (blue)
///   Search bar (decorative — no filtering logic in Phase 1)
///   "Browse by subject" section header
///   Vertical list of subject cards
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
            // ---- Search bar (decorative) ----
            _buildSearchBar(),
            const SizedBox(height: AppDimensions.lg),
            // ---- Section header ----
            Text(
              'Browse by subject',
              style: AppTextStyles.titleMedium.copyWith(
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: AppDimensions.md),
            // ---- Subject cards ----
            Expanded(
              child: ListView.separated(
                itemCount: MockData.subjects.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: AppDimensions.md),
                padding: const EdgeInsets.only(bottom: AppDimensions.md),
                itemBuilder: (context, index) {
                  final subject = MockData.subjects[index];
                  return SubjectCard(
                    subject: subject,
                    onTap: () => Navigator.pushNamed(
                      context,
                      AppRoutes.subjectExams,
                      arguments: subject,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Decorative search bar matching Figma — magnifying glass + "Search".
  Widget _buildSearchBar() {
    return Container(
      height: AppDimensions.inputHeight,
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.pillRadius,
        border: Border.all(color: AppColors.lightBlue, width: 1),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            AppAssets.iconSearch,
            width: 20,
            height: 20,
            colorFilter: const ColorFilter.mode(
              AppColors.gray,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(width: AppDimensions.sm),
          Text(
            'Search',
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.placeholder,
            ),
          ),
        ],
      ),
    );
  }
}
