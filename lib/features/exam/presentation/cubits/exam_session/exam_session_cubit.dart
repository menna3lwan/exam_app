import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/network/api_results.dart';
import '../../../../../data/models/exam_model.dart';
import '../../../../../data/models/question_model.dart';
import '../../../../../data/models/subject_model.dart';
import '../../../domain/use_cases/submit_exam_use_case.dart';
import 'exam_session_state.dart';

/// Manages the full exam session lifecycle:
/// timer, answer tracking, navigation, submission.
///
/// All business logic lives here — the view is purely presentational.
class ExamSessionCubit extends Cubit<ExamSessionState> {
  final SubmitExamUseCase _submitExamUseCase;
  Timer? _timer;

  ExamSessionCubit(this._submitExamUseCase)
      : super(const ExamSessionInitial());

  void startExam({
    required ExamModel exam,
    required SubjectModel subject,
    required List<QuestionModel> questions,
  }) {
    if (questions.isEmpty) {
      emit(const ExamSessionError('No questions available'));
      return;
    }

    emit(ExamSessionActive(
      exam: exam,
      subject: subject,
      questions: questions,
      currentIndex: 0,
      answers: List<String?>.filled(questions.length, null),
      remainingSeconds: exam.duration * 60,
    ));

    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (isClosed) return;
      final current = state;
      if (current is! ExamSessionActive) return;

      if (current.remainingSeconds <= 1) {
        _timer?.cancel();
        _onTimeOut(current);
        return;
      }

      emit(current.copyWith(
        remainingSeconds: current.remainingSeconds - 1,
      ));
    });
  }

  void selectAnswer(String answerKey) {
    final current = state;
    if (current is! ExamSessionActive) return;

    final newAnswers = List<String?>.from(current.answers);
    newAnswers[current.currentIndex] = answerKey;
    emit(current.copyWith(answers: newAnswers));
  }

  void goToNext() {
    final current = state;
    if (current is! ExamSessionActive) return;

    if (current.isLastQuestion) {
      submitExam();
    } else {
      emit(current.copyWith(currentIndex: current.currentIndex + 1));
    }
  }

  void goToPrevious() {
    final current = state;
    if (current is! ExamSessionActive) return;

    if (current.currentIndex > 0) {
      emit(current.copyWith(currentIndex: current.currentIndex - 1));
    }
  }

  Future<void> submitExam() async {
    final current = state;
    if (current is! ExamSessionActive) return;

    _timer?.cancel();

    final totalTime = current.exam.duration * 60;
    final timeSpent = totalTime - current.remainingSeconds;

    final result = await _submitExamUseCase(
      examId: current.exam.id,
      answers: _buildAnswersMap(current),
      timeSpentSeconds: timeSpent,
    );

    if (isClosed) return;

    switch (result) {
      case Success(:final data):
        if (data != null) {
          emit(ExamSessionSubmitted(
            data,
            current.questions,
            List.unmodifiable(current.answers),
          ));
        } else {
          emit(const ExamSessionError('No result returned'));
        }
      case Failure(:final message):
        emit(ExamSessionError(message ?? 'Submission failed'));
    }
  }

  Future<void> _onTimeOut(ExamSessionActive current) async {
    final result = await _submitExamUseCase(
      examId: current.exam.id,
      answers: _buildAnswersMap(current),
      timeSpentSeconds: current.exam.duration * 60,
    );

    if (isClosed) return;

    switch (result) {
      case Success(:final data):
        if (data != null) {
          emit(ExamSessionTimedOut(
            data,
            current.questions,
            List.unmodifiable(current.answers),
          ));
        }
      case Failure(:final message):
        emit(ExamSessionError(message ?? 'Submission failed'));
    }
  }

  Map<String, String> _buildAnswersMap(ExamSessionActive current) {
    final map = <String, String>{};
    for (int i = 0; i < current.questions.length; i++) {
      final answer = current.answers[i];
      if (answer != null) {
        map[current.questions[i].id] = answer;
      }
    }
    return map;
  }

  void leaveExam() {
    _timer?.cancel();
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
