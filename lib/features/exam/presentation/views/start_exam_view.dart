import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/widgets/app_button.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/di/di.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/routing/route_arguments.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../common/utils/app_snackbar.dart';
import '../cubits/start_exam/start_exam_cubit.dart';
import '../cubits/start_exam/start_exam_state.dart';

class StartExamView extends StatelessWidget {
  const StartExamView({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as StartExamArgs?;
    if (args == null) {
      return Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(leading: const BackButton()),
        body: const Center(child: Text('Exam not found')),
      );
    }

    return BlocProvider(
      create: (_) => getIt<StartExamCubit>(),
      child: _StartExamBody(args: args),
    );
  }
}

class _StartExamBody extends StatelessWidget {
  final StartExamArgs args;
  const _StartExamBody({required this.args});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        leading: const BackButton(),
        title: Text(args.subject.name),
      ),
      body: BlocConsumer<StartExamCubit, StartExamState>(
        listener: (context, state) {
          switch (state) {
            case StartExamLoaded(:final questions):
              Navigator.pushReplacementNamed(
                context,
                AppRoutes.examSession,
                arguments: ExamSessionArgs(
                  exam: args.exam,
                  subject: args.subject,
                  questions: questions,
                ),
              );
            case StartExamError(:final message):
              AppSnackbar.showError(context, message);
            default:
              break;
          }
        },
        builder: (context, state) {
          final isLoading = state is StartExamLoading;
          return Padding(
            padding: const EdgeInsets.all(AppDimensions.lg),
            child: Column(
              children: [
                const Spacer(),
                // ---- Illustration ----
                Image.asset(
                  AppAssets.illustrationExamClipboard,
                  height: 180,
                ),
                const SizedBox(height: AppDimensions.lg),
                // ---- Exam title ----
                Text(
                  args.exam.title,
                  style: AppTextStyles.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppDimensions.lg),
                // ---- Info row ----
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _InfoChip(
                      icon: Icons.help_outline,
                      label: '${args.exam.numberOfQuestions} Questions',
                    ),
                    const SizedBox(width: AppDimensions.lg),
                    _InfoChip(
                      icon: Icons.timer_outlined,
                      label: '${args.exam.duration} Minutes',
                    ),
                  ],
                ),
                const Spacer(),
                // ---- Start button ----
                AppButton(
                  label: 'Start Exam',
                  isLoading: isLoading,
                  onPressed: isLoading
                      ? null
                      : () => context
                            .read<StartExamCubit>()
                            .loadQuestions(args.exam.id),
                ),
                const SizedBox(height: AppDimensions.md),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(width: AppDimensions.xs),
        Text(
          label,
          style: AppTextStyles.labelMedium.copyWith(color: AppColors.primary),
        ),
      ],
    );
  }
}
