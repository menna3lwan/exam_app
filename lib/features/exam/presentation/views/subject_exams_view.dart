import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/widgets/exam_card.dart';
import '../../../../core/di/di.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/routing/route_arguments.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../data/models/exam_model.dart';
import '../../../../data/models/subject_model.dart';
import '../cubits/subject_exams/subject_exams_cubit.dart';
import '../cubits/subject_exams/subject_exams_state.dart';

class SubjectExamsView extends StatelessWidget {
  const SubjectExamsView({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as SubjectExamsArgs?;
    if (args == null) {
      return Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(leading: const BackButton()),
        body: const Center(child: Text('Subject not found')),
      );
    }

    return BlocProvider(
      create: (_) =>
          getIt<SubjectExamsCubit>()..loadExams(args.subject),
      child: _SubjectExamsBody(subjectName: args.subject.name),
    );
  }
}

class _SubjectExamsBody extends StatelessWidget {
  final String subjectName;
  const _SubjectExamsBody({required this.subjectName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        leading: const BackButton(),
        title: Text(subjectName),
      ),
      body: BlocBuilder<SubjectExamsCubit, SubjectExamsState>(
        builder: (context, state) {
          return switch (state) {
            SubjectExamsInitial() ||
            SubjectExamsLoading() =>
              const Center(child: CircularProgressIndicator()),
            SubjectExamsError(:final message) =>
              Center(child: Text(message)),
            SubjectExamsLoaded(:final exams, :final subject) =>
              exams.isEmpty
                  ? _buildEmptyState()
                  : _buildExamList(context, exams, subject),
          };
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.quiz_outlined, size: 64, color: AppColors.gray),
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
    List<ExamModel> exams,
    SubjectModel subject,
  ) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.lg,
        vertical: AppDimensions.md,
      ),
      itemCount: exams.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppDimensions.sm),
      itemBuilder: (context, index) {
        final exam = exams[index];
        return ExamCard(
          exam: exam,
          subjectIcon: subject.icon,
          onTap: () => Navigator.pushNamed(
            context,
            AppRoutes.startExam,
            arguments: StartExamArgs(
              exam: exam,
              subject: subject,
            ),
          ),
        );
      },
    );
  }
}
