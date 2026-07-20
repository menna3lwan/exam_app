/// Single exam result entry for the "Results" tab.
///
/// Combines exam metadata with result summary.
class ExamHistoryModel {
  final String id;
  final String examTitle;
  final String subjectName;
  final int numberOfQuestions;
  final int durationMinutes;
  final int correctAnswers;
  final int timeSpentMinutes;

  const ExamHistoryModel({
    required this.id,
    required this.examTitle,
    required this.subjectName,
    required this.numberOfQuestions,
    required this.durationMinutes,
    required this.correctAnswers,
    required this.timeSpentMinutes,
  });

  factory ExamHistoryModel.fromJson(Map<String, dynamic> json) {
    return ExamHistoryModel(
      id: json['_id'] as String? ?? '',
      examTitle: json['examTitle'] as String? ?? '',
      subjectName: json['subjectName'] as String? ?? '',
      numberOfQuestions: json['numberOfQuestions'] as int? ?? 0,
      durationMinutes: json['durationMinutes'] as int? ?? 0,
      correctAnswers: json['correctAnswers'] as int? ?? 0,
      timeSpentMinutes: json['timeSpentMinutes'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'examTitle': examTitle,
        'subjectName': subjectName,
        'numberOfQuestions': numberOfQuestions,
        'durationMinutes': durationMinutes,
        'correctAnswers': correctAnswers,
        'timeSpentMinutes': timeSpentMinutes,
      };
}
