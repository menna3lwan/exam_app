import 'package:flutter/material.dart';

import '../../../common/widgets/app_button.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/mock/mock_data.dart';
import '../../../data/models/exam_model.dart';
import '../../../data/models/subject_model.dart';

/// Start exam screen matching the Figma "Start exam" frame.
///
/// Layout:
///   Subject icon + name + duration (blue)
///   "High level | 20 Question"
///   Divider
///   "Instructions" + bullet list
///   Start button (pill, full width, bottom)
///
/// Receives `{'exam': ExamModel, 'subject': SubjectModel}` via route args.
class StartExamView extends StatelessWidget {
  const StartExamView({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final exam = args?['exam'] as ExamModel?;
    final subject = args?['subject'] as SubjectModel?;

    if (exam == null || subject == null) {
      return Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(leading: const BackButton()),
        body: const Center(child: Text('Exam not found')),
      );
    }

    final questions = MockData.questionsForExam(exam.id);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        leading: const BackButton(),
        backgroundColor: AppColors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppDimensions.sm),
              // ---- Subject info header ----
              _buildSubjectHeader(subject, exam),
              const SizedBox(height: AppDimensions.sm),
              // ---- Difficulty + question count ----
              Text(
                'High level | ${exam.numberOfQuestions} Question',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.gray,
                ),
              ),
              const SizedBox(height: AppDimensions.lg),
              // ---- Divider ----
              const Divider(color: AppColors.lightBlue, height: 1),
              const SizedBox(height: AppDimensions.lg),
              // ---- Instructions ----
              Text(
                'Instructions',
                style: AppTextStyles.titleMedium.copyWith(
                  color: AppColors.black,
                ),
              ),
              const SizedBox(height: AppDimensions.md),
              _buildInstructionsList(exam),
              const Spacer(),
              // ---- Start button ----
              AppButton(
                label: 'Start',
                onPressed: () => Navigator.pushNamed(
                  context,
                  AppRoutes.examSession,
                  arguments: {
                    'exam': exam,
                    'subject': subject,
                    'questions': questions,
                  },
                ),
              ),
              const SizedBox(height: AppDimensions.lg),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubjectHeader(SubjectModel subject, ExamModel exam) {
    return Row(
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
        // ---- Name + duration ----
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                subject.name,
                style: AppTextStyles.titleLarge.copyWith(
                  color: AppColors.black,
                ),
              ),
            ],
          ),
        ),
        Text(
          '${exam.duration} Minutes',
          style: AppTextStyles.labelMedium.copyWith(
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildInstructionsList(ExamModel exam) {
    // Figma shows lorem-ipsum bullet points; these are realistic instructions.
    final instructions = [
      'Read each question carefully before answering.',
      'You have ${exam.duration} minutes to complete the exam.',
      'You can navigate between questions using Back and Next.',
      'Once the timer runs out, your answers will be submitted automatically.',
    ];

    return Column(
      children: instructions
          .map(
            (text) => Padding(
              padding: const EdgeInsets.only(bottom: AppDimensions.sm),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppDimensions.sm),
                  Expanded(
                    child: Text(
                      text,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.gray,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
