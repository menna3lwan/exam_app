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
    // Extract exam/subject info from nested objects if present,
    // or fall back to flat field names (mock data shape).
    final exam = json['exam'] as Map<String, dynamic>?;
    final subject = json['subject'] as Map<String, dynamic>?;

    return ExamHistoryModel(
      id: json['_id'] as String? ?? '',
      examTitle: exam?['title'] as String? ??
          json['examTitle'] as String? ??
          '',
      subjectName: subject?['name'] as String? ??
          json['subjectName'] as String? ??
          '',
      numberOfQuestions: exam?['numberOfQuestions'] as int? ??
          json['numberOfQuestions'] as int? ??
          0,
      durationMinutes: exam?['duration'] as int? ??
          json['durationMinutes'] as int? ??
          json['duration'] as int? ??
          0,
      correctAnswers: json['correctAnswers'] as int? ??
          json['correct'] as int? ??
          0,
      timeSpentMinutes: json['timeSpentMinutes'] as int? ??
          json['time'] as int? ??
          0,
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
