import 'package:flutter/material.dart';

import '../../../../core/routing/route_arguments.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../data/models/question_model.dart';

/// Answers review screen matching Figma "Answers" frame.
///
/// Displays all questions with color-coded answer indicators:
///   • Green = correct answer
///   • Red   = user's wrong pick
///   • Gray  = unselected / neutral
///
/// Purely presentational — receives [AnswersReviewArgs] via route.
class AnswersReviewView extends StatelessWidget {
  const AnswersReviewView({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as AnswersReviewArgs?;

    if (args == null) {
      return Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(leading: const BackButton()),
        body: const Center(child: Text('No answers to review')),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        surfaceTintColor: Colors.transparent,
        leading: const BackButton(),
        title: Text('Answers', style: AppTextStyles.titleMedium),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(AppDimensions.md),
        itemCount: args.questions.length,
        separatorBuilder: (_, __) =>
            const SizedBox(height: AppDimensions.md),
        itemBuilder: (context, index) {
          return _QuestionReviewCard(
            question: args.questions[index],
            userAnswer: args.userAnswers[index],
            questionNumber: index + 1,
          );
        },
      ),
    );
  }
}

/// Card showing one question with all 4 options color-coded.
class _QuestionReviewCard extends StatelessWidget {
  final QuestionModel question;
  final String? userAnswer;
  final int questionNumber;

  const _QuestionReviewCard({
    required this.question,
    required this.userAnswer,
    required this.questionNumber,
  });

  bool get _answeredCorrectly => userAnswer == question.correct;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.sm),
        border: Border.all(
          color: AppColors.black.withValues(alpha: 0.08),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question.question,
            style: AppTextStyles.titleSmall,
          ),
          const SizedBox(height: AppDimensions.sm),
          ...question.options.map(
            (option) => Padding(
              padding: const EdgeInsets.only(bottom: AppDimensions.xs),
              child: _AnswerReviewOption(
                text: option.value,
                answerKey: option.key,
                correctKey: question.correct,
                userAnswer: userAnswer,
                answeredCorrectly: _answeredCorrectly,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Single answer option in review mode with color-coded state.
class _AnswerReviewOption extends StatelessWidget {
  final String text;
  final String answerKey;
  final String correctKey;
  final String? userAnswer;
  final bool answeredCorrectly;

  const _AnswerReviewOption({
    required this.text,
    required this.answerKey,
    required this.correctKey,
    required this.userAnswer,
    required this.answeredCorrectly,
  });

  @override
  Widget build(BuildContext context) {
    final isCorrect = answerKey == correctKey;
    final isUserPick = answerKey == userAnswer;

    // Determine visual state
    final _OptionStyle style;
    if (answeredCorrectly) {
      // User got it right — green for the correct/selected, neutral for rest
      style = isCorrect
          ? _OptionStyle.correct
          : _OptionStyle.neutral;
    } else {
      // User got it wrong — green for correct, red for user's pick, neutral rest
      if (isCorrect) {
        style = _OptionStyle.correct;
      } else if (isUserPick) {
        style = _OptionStyle.wrong;
      } else {
        style = _OptionStyle.neutral;
      }
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.sm,
        vertical: AppDimensions.sm,
      ),
      decoration: BoxDecoration(
        color: style.backgroundColor,
        borderRadius: BorderRadius.circular(AppDimensions.sm),
        border: Border.all(
          color: style.borderColor,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          _buildIndicator(style, isUserPick || isCorrect),
          const SizedBox(width: AppDimensions.sm),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIndicator(_OptionStyle style, bool filled) {
    if (answeredCorrectly) {
      // Radio-button style for correctly answered questions
      return Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: style.indicatorColor, width: 2),
        ),
        child: filled
            ? Center(
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: style.indicatorColor,
                  ),
                ),
              )
            : null,
      );
    } else {
      // Checkbox style for incorrectly answered questions
      return Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: filled ? style.indicatorColor : Colors.transparent,
          border: Border.all(
            color: filled ? style.indicatorColor : AppColors.gray,
            width: 1.5,
          ),
        ),
        child: filled
            ? const Icon(Icons.check, size: 14, color: Colors.white)
            : null,
      );
    }
  }
}

/// Visual state configuration for answer options.
enum _OptionStyle {
  correct(
    backgroundColor: AppColors.lightGreen,
    borderColor: AppColors.lightGreen,
    indicatorColor: AppColors.success,
  ),
  wrong(
    backgroundColor: AppColors.lightRed,
    borderColor: AppColors.lightRed,
    indicatorColor: AppColors.error,
  ),
  neutral(
    backgroundColor: Colors.white,
    borderColor: Color(0xFFE0E0E0),
    indicatorColor: AppColors.gray,
  );

  final Color backgroundColor;
  final Color borderColor;
  final Color indicatorColor;

  const _OptionStyle({
    required this.backgroundColor,
    required this.borderColor,
    required this.indicatorColor,
  });
}
