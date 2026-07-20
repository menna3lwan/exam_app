import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../common/utils/app_snackbar.dart';
import '../../../common/widgets/answer_option_card.dart';
import '../../../common/widgets/app_button.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/exam_model.dart';
import '../../../data/models/question_model.dart';
import '../../../data/models/subject_model.dart';

/// Exam session screen matching the Figma "Exam 1–6" frames.
///
/// Features:
///   - Countdown timer (mm.ss format, blue, alarm clock icon)
///   - Progress bar + "Question X of Y"
///   - Question text + 4 answer option cards (radio for now)
///   - Back (outlined) + Next (filled) navigation buttons
///   - Answer tracking per question (preserved when navigating back/forward)
///   - Auto-submit placeholder when timer expires or last question answered
///
/// Receives `{'exam': ExamModel, 'subject': SubjectModel,
///   'questions': List<QuestionModel>}` via route args.
class ExamSessionView extends StatefulWidget {
  const ExamSessionView({super.key});

  @override
  State<ExamSessionView> createState() => _ExamSessionViewState();
}

class _ExamSessionViewState extends State<ExamSessionView> {
  ExamModel? _exam;
  SubjectModel? _subject;
  List<QuestionModel> _questions = [];

  int _currentIndex = 0;
  Timer? _timer;
  int _remainingSeconds = 0;
  bool _initialized = false;

  /// Stores the user's selected answer key per question index.
  /// null = unanswered, String = "A1"–"A4".
  List<String?> _answers = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;

    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    _exam = args?['exam'] as ExamModel?;
    _subject = args?['subject'] as SubjectModel?;
    _questions = args?['questions'] as List<QuestionModel>? ?? [];

    if (_exam != null) {
      _remainingSeconds = _exam!.duration * 60;
    }
    _answers = List<String?>.filled(_questions.length, null);

    if (_questions.isNotEmpty) {
      _startTimer();
    }
    _initialized = true;
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds <= 0) {
        timer.cancel();
        _onTimeOut();
        return;
      }
      setState(() => _remainingSeconds--);
    });
  }

  void _onTimeOut() {
    // Step 6 will implement the TimeOut Dialog here.
    // For now, submit and go back.
    _submitExam();
  }

  void _submitExam() {
    _timer?.cancel();
    if (!mounted) return;

    // Step 6 will navigate to Score screen.
    // For now, show success and pop to home.
    AppSnackBar.showSuccess(context, 'Exam submitted!');
    Navigator.popUntil(context, (route) => route.settings.name == '/home');
  }

  void _onNext() {
    if (_currentIndex < _questions.length - 1) {
      setState(() => _currentIndex++);
    } else {
      // Last question — submit
      _submitExam();
    }
  }

  void _onBack() {
    if (_currentIndex > 0) {
      setState(() => _currentIndex--);
    }
  }

  void _onSelectAnswer(String answerKey) {
    setState(() => _answers[_currentIndex] = answerKey);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // ── Formatting helpers ──

  String get _timerText {
    final minutes = _remainingSeconds ~/ 60;
    final seconds = _remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}.${seconds.toString().padLeft(2, '0')}';
  }

  double get _progress =>
      _questions.isEmpty ? 0 : (_currentIndex + 1) / _questions.length;

  // ── Build ──

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(leading: const BackButton(), title: const Text('Exam')),
        body: const Center(child: Text('No questions available')),
      );
    }

    final question = _questions[_currentIndex];
    final selectedAnswer = _answers[_currentIndex];

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            // ---- Progress section ----
            _buildProgressSection(),
            // ---- Question + Options ----
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.lg,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppDimensions.lg),
                    // ---- Question text ----
                    Text(
                      question.question,
                      style: AppTextStyles.titleMedium.copyWith(
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.lg),
                    // ---- Answer options ----
                    ...question.options.map(
                      (entry) => Padding(
                        padding:
                            const EdgeInsets.only(bottom: AppDimensions.sm),
                        child: AnswerOptionCard(
                          text: entry.value,
                          isSelected: selectedAnswer == entry.key,
                          onTap: () => _onSelectAnswer(entry.key),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppDimensions.md),
                  ],
                ),
              ),
            ),
            // ---- Navigation buttons ----
            _buildNavigationButtons(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      leading: BackButton(
        onPressed: () {
          // Confirm before leaving the exam
          showDialog<bool>(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Leave exam?'),
              content: const Text(
                'Your progress will be lost if you leave now.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(ctx, true),
                  child: const Text('Leave'),
                ),
              ],
            ),
          ).then((confirmed) {
            if (confirmed == true && mounted) {
              _timer?.cancel();
              Navigator.pop(context);
            }
          });
        },
      ),
      title: const Text('Exam'),
      actions: [
        // ---- Timer ----
        Padding(
          padding: const EdgeInsets.only(right: AppDimensions.md),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                AppAssets.iconAlarmClock,
                width: 20,
                height: 20,
                colorFilter: const ColorFilter.mode(
                  AppColors.primary,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                _timerText,
                style: AppTextStyles.labelLarge.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProgressSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.lg),
      child: Column(
        children: [
          const SizedBox(height: AppDimensions.sm),
          // ---- Progress bar ----
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: _progress,
              minHeight: 6,
              backgroundColor: AppColors.lightBlue,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
          const SizedBox(height: AppDimensions.sm),
          // ---- Question counter ----
          Text(
            'Question ${_currentIndex + 1} of ${_questions.length}',
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.gray),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.lg,
        vertical: AppDimensions.md,
      ),
      child: Row(
        children: [
          // ---- Back button ----
          Expanded(
            child: AppButton(
              label: 'Back',
              isOutlined: true,
              onPressed: _currentIndex > 0 ? _onBack : null,
            ),
          ),
          const SizedBox(width: AppDimensions.md),
          // ---- Next / Submit button ----
          Expanded(
            child: AppButton(
              label: _currentIndex < _questions.length - 1
                  ? 'Next'
                  : 'Submit',
              onPressed: _onNext,
            ),
          ),
        ],
      ),
    );
  }
}
