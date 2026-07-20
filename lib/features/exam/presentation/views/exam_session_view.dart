import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/utils/app_snackbar.dart';
import '../../../../common/widgets/answer_option_card.dart';
import '../../../../common/widgets/app_button.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/di/di.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/routing/route_arguments.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../cubits/exam_session/exam_session_cubit.dart';
import '../cubits/exam_session/exam_session_state.dart';

class ExamSessionView extends StatelessWidget {
  const ExamSessionView({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as ExamSessionArgs?;
    if (args == null) {
      return Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(leading: const BackButton()),
        body: const Center(child: Text('Exam session not found')),
      );
    }

    return BlocProvider(
      create: (_) => getIt<ExamSessionCubit>()
        ..startExam(
          exam: args.exam,
          subject: args.subject,
          questions: args.questions,
        ),
      child: const _ExamSessionBody(),
    );
  }
}

class _ExamSessionBody extends StatelessWidget {
  const _ExamSessionBody();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ExamSessionCubit, ExamSessionState>(
      listener: _handleOneTimeEvents,
      buildWhen: (prev, curr) => curr is ExamSessionActive,
      builder: (context, state) {
        if (state is! ExamSessionActive) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return _buildActiveSession(context, state);
      },
    );
  }

  void _handleOneTimeEvents(BuildContext context, ExamSessionState state) {
    switch (state) {
      case ExamSessionSubmitted(
        :final result,
        :final questions,
        :final userAnswers,
      ):
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.examResult,
          arguments: ExamResultArgs(
            result: result,
            questions: questions,
            userAnswers: userAnswers,
          ),
        );
      case ExamSessionTimedOut(
        :final result,
        :final questions,
        :final userAnswers,
      ):
        _showTimeOutDialog(context).then((_) {
          if (context.mounted) {
            Navigator.pushReplacementNamed(
              context,
              AppRoutes.examResult,
              arguments: ExamResultArgs(
                result: result,
                questions: questions,
                userAnswers: userAnswers,
              ),
            );
          }
        });
      case ExamSessionError(:final message):
        AppSnackBar.showError(context, message);
      default:
        break;
    }
  }

  /// Figma "Time out" dialog: sand clock illustration + red title + blue button.
  Future<void> _showTimeOutDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.md),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    AppAssets.illustrationSandClock,
                    width: 64,
                    height: 64,
                  ),
                  const SizedBox(width: AppDimensions.sm),
                  Text(
                    'Time out !!',
                    style: AppTextStyles.titleLarge.copyWith(
                      color: AppColors.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.lg),
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  label: 'View score',
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActiveSession(BuildContext context, ExamSessionActive state) {
    final cubit = context.read<ExamSessionCubit>();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _showLeaveDialog(context, cubit);
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          leading: BackButton(onPressed: () => _showLeaveDialog(context, cubit)),
          title: Text('Question ${state.currentIndex + 1}'),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: AppDimensions.md),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.sm,
                    vertical: AppDimensions.xs,
                  ),
                  decoration: BoxDecoration(
                    color: state.remainingSeconds <= 60
                        ? AppColors.lightRed
                        : AppColors.lightBlue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.timer_outlined,
                        size: 18,
                        color: state.remainingSeconds <= 60
                            ? AppColors.error
                            : AppColors.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        state.timerText,
                        style: AppTextStyles.labelMedium.copyWith(
                          color: state.remainingSeconds <= 60
                              ? AppColors.error
                              : AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            // ---- Progress bar ----
            LinearProgressIndicator(
              value: state.progress,
              backgroundColor: AppColors.lightBlue,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppColors.primary),
              minHeight: 4,
            ),
            // ---- Question content ----
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppDimensions.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state.currentQuestion.question,
                      style: AppTextStyles.titleMedium,
                    ),
                    const SizedBox(height: AppDimensions.lg),
                    ...state.currentQuestion.options.map(
                      (option) => Padding(
                        padding:
                            const EdgeInsets.only(bottom: AppDimensions.sm),
                        child: AnswerOptionCard(
                          text: option.value,
                          isSelected: state.selectedAnswer == option.key,
                          onTap: () => cubit.selectAnswer(option.key),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // ---- Navigation buttons ----
            Padding(
              padding: const EdgeInsets.all(AppDimensions.lg),
              child: Row(
                children: [
                  if (!state.isFirstQuestion)
                    Expanded(
                      child: AppButton(
                        label: 'Previous',
                        isOutlined: true,
                        onPressed: cubit.goToPrevious,
                      ),
                    ),
                  if (!state.isFirstQuestion)
                    const SizedBox(width: AppDimensions.md),
                  Expanded(
                    child: AppButton(
                      label: state.isLastQuestion ? 'Submit' : 'Next',
                      onPressed: cubit.goToNext,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLeaveDialog(BuildContext context, ExamSessionCubit cubit) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Leave Exam?'),
        content: const Text(
          'Your progress will be lost if you leave now.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Stay'),
          ),
          TextButton(
            onPressed: () {
              cubit.leaveExam();
              Navigator.pop(context); // close dialog
              Navigator.pop(context); // leave exam
            },
            child: Text(
              'Leave',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
