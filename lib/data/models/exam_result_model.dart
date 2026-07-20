/// Result returned by `POST /questions/check` after submitting exam answers.
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

  factory ExamResultModel.fromJson(Map<String, dynamic> json) {
    return ExamResultModel(
      correct: json['correct'] as int? ?? 0,
      wrong: json['wrong'] as int? ?? 0,
      total: json['total'] as int? ?? 0,
      wrongQuestions: (json['wrongQuestions'] as List<dynamic>?)
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
        'wrongQuestions': wrongQuestions.map((e) => e.toJson()).toList(),
      };
}

class WrongQuestionInfo {
  final String questionId;
  final String userAnswer;
  final String correctAnswer;

  const WrongQuestionInfo({
    required this.questionId,
    required this.userAnswer,
    required this.correctAnswer,
  });

  factory WrongQuestionInfo.fromJson(Map<String, dynamic> json) {
    return WrongQuestionInfo(
      questionId: json['questionId'] as String? ?? '',
      userAnswer: json['userAnswer'] as String? ?? '',
      correctAnswer: json['correctAnswer'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'questionId': questionId,
        'userAnswer': userAnswer,
        'correctAnswer': correctAnswer,
      };
}
