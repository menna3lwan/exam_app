/// Result returned by `POST /questions/check` after submitting exam answers.
///
/// Response shape inferred from the request body (which sends answers +
/// time) and common exam-grading patterns. The server likely returns
/// correct/wrong counts and details on wrong answers. Verify against a
/// real response when API integration begins.
class ExamResultModel {
  final int correct;
  final int wrong;
  final int total;
  final List<WrongQuestionInfo> wrongQuestions;

  const ExamResultModel({
    required this.correct,
    required this.wrong,
    required this.total,
    this.wrongQuestions = const [],
  });

  double get percentage => total > 0 ? (correct / total) * 100 : 0;
}

/// Minimal info about a question the user got wrong.
class WrongQuestionInfo {
  final String questionId;
  final String userAnswer; // the key the user chose (e.g. "A2")
  final String correctAnswer; // the actual correct key (e.g. "A3")

  const WrongQuestionInfo({
    required this.questionId,
    required this.userAnswer,
    required this.correctAnswer,
  });
}
