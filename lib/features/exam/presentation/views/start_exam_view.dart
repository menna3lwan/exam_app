import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

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

/// Start-exam screen matching the Figma "Start exam" frame:
///
/// - Back chevron (no AppBar title)
/// - Subject icon + subject name + duration
/// - "High level | 20 Question"
/// - Divider
/// - "Instructions" section with bullet points
/// - "Start" button
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
              AppSnackBar.showError(context, message);
            default:
              break;
          }
        },
        builder: (context, state) {
          final isLoading = state is StartExamLoading;
          return SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ---- Back button ----
                Padding(
                  padding: const EdgeInsets.only(
                    left: AppDimensions.xs,
                    top: AppDimensions.sm,
                  ),
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: SvgPicture.asset(
                      AppAssets.iconArrowBackIos,
                      width: 24,
                      height: 24,
                      colorFilter: const ColorFilter.mode(
                        AppColors.black,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),

                // ---- Subject info row ----
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.lg,
                  ),
                  child: Row(
                    children: [
                      // Subject icon
                      Image.asset(
                        _subjectIcon(args.subject.name),
                        width: 40,
                        height: 40,
                      ),
                      const SizedBox(width: AppDimensions.sm),
                      // Subject name
                      Expanded(
                        child: Text(
                          args.subject.name,
                          style: AppTextStyles.headlineSmall.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      // Duration
                      Text(
                        '${args.exam.duration} Minutes',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppDimensions.sm),

                // ---- Level + question count ----
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.lg,
                  ),
                  child: Row(
                    children: [
                      Text(
                        args.exam.title,
                        style: AppTextStyles.titleMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.sm,
                        ),
                        child: Text(
                          '|',
                          style: AppTextStyles.titleMedium.copyWith(
                            color: AppColors.gray,
                          ),
                        ),
                      ),
                      Text(
                        '${args.exam.numberOfQuestions} Question',
                        style: AppTextStyles.titleMedium.copyWith(
                          color: AppColors.gray,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppDimensions.md),

                // ---- Divider ----
                const Divider(height: 1, thickness: 1),

                const SizedBox(height: AppDimensions.lg),

                // ---- Instructions section ----
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.lg,
                  ),
                  child: Text(
                    'Instructions',
                    style: AppTextStyles.titleLarge.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: AppDimensions.md),

                // ---- Bullet points ----
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.lg,
                    ),
                    child: ListView(
                      children: const [
                        _BulletPoint(
                          'Lorem ipsum dolor sit amet consectetur.',
                        ),
                        _BulletPoint(
                          'Lorem ipsum dolor sit amet consectetur.',
                        ),
                        _BulletPoint(
                          'Lorem ipsum dolor sit amet consectetur.',
                        ),
                        _BulletPoint(
                          'Lorem ipsum dolor sit amet consectetur.',
                        ),
                      ],
                    ),
                  ),
                ),

                // ---- Start button ----
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppDimensions.lg,
                    AppDimensions.md,
                    AppDimensions.lg,
                    AppDimensions.lg,
                  ),
                  child: AppButton(
                    label: 'Start',
                    isLoading: isLoading,
                    onPressed: isLoading
                        ? null
                        : () => context
                              .read<StartExamCubit>()
                              .loadQuestions(args.exam.id),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Map subject name to its illustration asset.
  String _subjectIcon(String subjectName) {
    final lower = subjectName.toLowerCase();
    if (lower.contains('lang')) return AppAssets.illustrationLanguageTranslator;
    if (lower.contains('math')) return AppAssets.illustrationDraftingTools;
    if (lower.contains('art')) return AppAssets.illustrationColorPalette;
    if (lower.contains('sci') || lower.contains('bio') || lower.contains('chem')) {
      return AppAssets.illustrationMicroscope;
    }
    return AppAssets.illustrationExamClipboard;
  }
}

class _BulletPoint extends StatelessWidget {
  final String text;
  const _BulletPoint(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: AppColors.black,
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
    );
  }
}
