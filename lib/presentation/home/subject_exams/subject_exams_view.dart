import 'package:flutter/material.dart';

import '../../../common/widgets/exam_card.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/mock/mock_data.dart';
import '../../../data/models/exam_model.dart';
import '../../../data/models/subject_model.dart';

/// Subject exams list matching the Figma "Explore > Languages" screen.
///
/// Receives a [SubjectModel] via route arguments.
/// Groups exams by title (e.g. "English", "Spanish") with section headers.
class SubjectExamsView extends StatelessWidget {
  const SubjectExamsView({super.key});

  @override
  Widget build(BuildContext context) {
    final subject =
        ModalRoute.of(context)?.settings.arguments as SubjectModel?;
    if (subject == null) {
      return Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(leading: const BackButton()),
        body: const Center(child: Text('Subject not found')),
      );
    }

    final grouped = MockData.examsGroupedByTitle(subject.id);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        leading: const BackButton(),
        title: Text(subject.name),
      ),
      body: grouped.isEmpty
          ? _buildEmptyState()
          : _buildExamList(context, grouped, subject),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.quiz_outlined, size: 64, color: AppColors.gray),
          const SizedBox(height: AppDimensions.md),
          Text(
            'No exams available yet',
            style: AppTextStyles.bodyLarge.copyWith(color: AppColors.gray),
          ),
        ],
      ),
    );
  }

  Widget _buildExamList(
    BuildContext context,
    Map<String, List<ExamModel>> grouped,
    SubjectModel subject,
  ) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.lg,
        vertical: AppDimensions.md,
      ),
      itemCount: grouped.length,
      itemBuilder: (context, sectionIndex) {
        final title = grouped.keys.elementAt(sectionIndex);
        final exams = grouped[title]!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (sectionIndex > 0) const SizedBox(height: AppDimensions.lg),
            // ---- Section header (e.g. "English") ----
            Text(
              title,
              style: AppTextStyles.titleMedium.copyWith(
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: AppDimensions.sm),
            // ---- Exam cards in this section ----
            ...exams.map(
              (exam) => Padding(
                padding: const EdgeInsets.only(bottom: AppDimensions.sm),
                child: ExamCard(
                  exam: exam,
                  subjectIcon: subject.icon,
                  onTap: () => Navigator.pushNamed(
                    context,
                    AppRoutes.startExam,
                    arguments: {
                      'exam': exam,
                      'subject': subject,
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
