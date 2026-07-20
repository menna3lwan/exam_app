import '../../../../../data/models/exam_model.dart';
import '../../../../../data/models/exam_result_model.dart';
import '../../../../../data/models/question_model.dart';
import '../../../../../data/models/subject_model.dart';

sealed class ExamSessionState {
  const ExamSessionState();
}

class ExamSessionInitial extends ExamSessionState {
  const ExamSessionInitial();
}

/// Active exam state — holds all session data.
class ExamSessionActive extends ExamSessionState {
  final ExamModel exam;
  final SubjectModel subject;
  final List<QuestionModel> questions;
  final int currentIndex;
  final List<String?> answers;
  final int remainingSeconds;

  const ExamSessionActive({
    required this.exam,
    required this.subject,
    required this.questions,
    required this.currentIndex,
    required this.answers,
    required this.remainingSeconds,
  });

  bool get isFirstQuestion => currentIndex == 0;
  bool get isLastQuestion => currentIndex == questions.length - 1;
  QuestionModel get currentQuestion => questions[currentIndex];
  String? get selectedAnswer => answers[currentIndex];
  double get progress =>
      questions.isEmpty ? 0 : (currentIndex + 1) / questions.length;

  String get timerText {
    final minutes = remainingSeconds ~/ 60;
    final seconds = remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}.${seconds.toString().padLeft(2, '0')}';
  }

  ExamSessionActive copyWith({
    int? currentIndex,
    List<String?>? answers,
    int? remainingSeconds,
  }) {
    return ExamSessionActive(
      exam: exam,
      subject: subject,
      questions: questions,
      currentIndex: currentIndex ?? this.currentIndex,
      answers: answers ?? this.answers,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
    );
  }
}

/// One-time event: exam submitted successfully.
class ExamSessionSubmitted extends ExamSessionState {
  final ExamResultModel result;
  const ExamSessionSubmitted(this.result);
}

/// One-time event: timer expired.
class ExamSessionTimedOut extends ExamSessionState {
  final ExamResultModel result;
  const ExamSessionTimedOut(this.result);
}

class ExamSessionError extends ExamSessionState {
  final String message;
  const ExamSessionError(this.message);
}
