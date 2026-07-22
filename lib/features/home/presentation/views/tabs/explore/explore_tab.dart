import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../../common/widgets/resource_state_builder.dart';
import '../../../../../../common/widgets/subject_card.dart';
import '../../../../../../core/constants/app_assets.dart';
import '../../../../../../core/routing/app_routes.dart';
import '../../../../../../core/routing/route_arguments.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_dimensions.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../data/models/subject_model.dart';
import '../../../cubits/explore/explore_cubit.dart';
import '../../../../../../core/base/resources.dart';

/// Explore tab — subjects list with decorative search bar.
///
/// Uses [ResourceStateBuilder] for centralized state rendering.
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
            Text(
              'Survey',
              style: AppTextStyles.headlineSmall.copyWith(
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: AppDimensions.md),
            _buildSearchBar(),
            const SizedBox(height: AppDimensions.lg),
            Text(
              'Browse by subject',
              style: AppTextStyles.titleMedium.copyWith(
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: AppDimensions.md),
            Expanded(
              child: BlocBuilder<ExploreCubit, Resources<List<SubjectModel>>>(
                builder: (context, resource) {
                  return ResourceStateBuilder<List<SubjectModel>>(
                    resource: resource,
                    onSuccess: (context, subjects) {
                      return ListView.separated(
                        itemCount: subjects.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: AppDimensions.md),
                        padding:
                            const EdgeInsets.only(bottom: AppDimensions.md),
                        itemBuilder: (context, index) {
                          final subject = subjects[index];
                          return SubjectCard(
                            subject: subject,
                            onTap: () => Navigator.pushNamed(
                              context,
                              AppRoutes.subjectExams,
                              arguments:
                                  SubjectExamsArgs(subject: subject),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

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
