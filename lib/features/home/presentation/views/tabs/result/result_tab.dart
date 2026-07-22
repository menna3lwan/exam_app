import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../common/widgets/resource_state_builder.dart';
import '../../../../../../core/base/resources.dart';
import '../../../../../../core/constants/app_assets.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_dimensions.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../data/models/exam_history_model.dart';
import '../../../cubits/results/results_cubit.dart';

/// Results tab matching the Figma "Results" frame.
///
/// Shows exam history grouped by subject, each card with
/// illustration, title, question count, duration, and score summary.
class ResultTab extends StatelessWidget {
  const ResultTab({super.key});

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
              'Results',
              style: AppTextStyles.headlineSmall.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppDimensions.md),
            Expanded(
              child: BlocBuilder<ResultsCubit,
                  Resources<List<ExamHistoryModel>>>(
                builder: (context, resource) {
                  return ResourceStateBuilder<List<ExamHistoryModel>>(
                    resource: resource,
                    onSuccess: (context, items) {
                      if (items.isEmpty) return _buildEmptyState();
                      return _buildGroupedList(items);
                    },
                    onError: (context, _) => _buildErrorState(context),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.history_outlined, size: 64, color: AppColors.gray),
          const SizedBox(height: AppDimensions.md),
          Text(
            'No results yet',
            style: AppTextStyles.bodyLarge.copyWith(color: AppColors.gray),
          ),
          const SizedBox(height: AppDimensions.xs),
          Text(
            'Complete an exam to see your results here',
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.gray),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.cloud_off_outlined, size: 64, color: AppColors.gray),
          const SizedBox(height: AppDimensions.md),
          Text(
            'Could not load results',
            style: AppTextStyles.bodyLarge.copyWith(color: AppColors.gray),
          ),
          const SizedBox(height: AppDimensions.lg),
          SizedBox(
            width: 140,
            child: OutlinedButton(
              onPressed: () =>
                  context.read<ResultsCubit>().loadHistory(),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
              ),
              child: const Text('Retry'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupedList(List<ExamHistoryModel> items) {
    // Group by subject name
    final grouped = <String, List<ExamHistoryModel>>{};
    for (final item in items) {
      grouped.putIfAbsent(item.subjectName, () => []).add(item);
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: AppDimensions.md),
      itemCount: grouped.length,
      itemBuilder: (context, index) {
        final subject = grouped.keys.elementAt(index);
        final exams = grouped[subject]!;
        return _SubjectResultGroup(
          subjectName: subject,
          exams: exams,
        );
      },
    );
  }
}

class _SubjectResultGroup extends StatelessWidget {
  final String subjectName;
  final List<ExamHistoryModel> exams;

  const _SubjectResultGroup({
    required this.subjectName,
    required this.exams,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          subjectName,
          style: AppTextStyles.titleMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppDimensions.sm),
        ...exams.map(
          (exam) => Padding(
            padding: const EdgeInsets.only(bottom: AppDimensions.sm),
            child: _ResultCard(exam: exam),
          ),
        ),
        const SizedBox(height: AppDimensions.sm),
      ],
    );
  }
}

/// Single result card matching Figma layout:
/// illustration | title + question count | duration
///                score summary (blue)
class _ResultCard extends StatelessWidget {
  final ExamHistoryModel exam;

  const _ResultCard({required this.exam});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.sm),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.sm),
        border: Border.all(
          color: AppColors.black.withValues(alpha: 0.08),
        ),
      ),
      child: Row(
        children: [
          // Illustration
          ClipRRect(
            borderRadius: BorderRadius.circular(AppDimensions.xs),
            child: Image.asset(
              AppAssets.illustrationExamClipboard,
              width: 56,
              height: 56,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: AppDimensions.sm),

          // Title + question count + score
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      exam.examTitle,
                      style: AppTextStyles.titleSmall.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${exam.durationMinutes} Minutes',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.gray,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  '${exam.numberOfQuestions} Question',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.gray,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${exam.correctAnswers} corrected answers in ${exam.timeSpentMinutes} min.',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
