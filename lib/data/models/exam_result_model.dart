/// Result returned by `POST /questions/check` after submitting exam answers.
///
/// ```json
/// {
///   "message": "success",
///   "correct": 1,
///   "wrong": 0,
///   "total": "100%",
///   "WrongQuestions": [
///     { "QID": "...", "Question": "...", "correctAnswer": "A2", "answers": {} }
///   ],
///   "correctQuestions": [
///     { "QID": "...", "Question": "...", "correctAnswer": "A4", "answers": {} }
///   ]
/// }
/// ```
class ExamResultModel {
  final int correct;
  final int wrong;
  final int total; // computed: correct + wrong
  final List<WrongQuestionInfo> wrongQuestions;

  const ExamResultModel({
    required this.correct,
    required this.wrong,
    required this.total,
    this.wrongQuestions = const [],
  });

  double get percentage => total > 0 ? (correct / total) * 100 : 0;

  factory ExamResultModel.fromJson(Map<String, dynamic> json) {
    final correctCount = json['correct'] as int? ?? 0;
    final wrongCount = json['wrong'] as int? ?? 0;

    return ExamResultModel(
      correct: correctCount,
      wrong: wrongCount,
      // API returns `total` as "100%" string — compute from counts instead
      total: correctCount + wrongCount,
      // API uses capital "WrongQuestions"
      wrongQuestions: (json['WrongQuestions'] as List<dynamic>?)
              ?.map((e) =>
                  WrongQuestionInfo.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        'correct': correct,
        'wrong': wrong,
        'total': total,
        'WrongQuestions': wrongQuestions.map((e) => e.toJson()).toList(),
      };
}

/// Info about a wrong answer from the API check response.
///
/// API shape: `{ "QID": "...", "Question": "...", "correctAnswer": "A2", "answers": {} }`
class WrongQuestionInfo {
  final String questionId;
  final String questionText;
  final String correctAnswer;

  const WrongQuestionInfo({
    required this.questionId,
    this.questionText = '',
    required this.correctAnswer,
  });

  factory WrongQuestionInfo.fromJson(Map<String, dynamic> json) {
    return WrongQuestionInfo(
      questionId: json['QID'] as String? ?? '',
      questionText: json['Question'] as String? ?? '',
      correctAnswer: json['correctAnswer'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'QID': questionId,
        'Question': questionText,
        'correctAnswer': correctAnswer,
      };
}
