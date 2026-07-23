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
    // or fall back to flat field names (mock / local store shape).
    final exam = _asStringKeyedMap(json['exam']);
    final subject = _asStringKeyedMap(json['subject']);

    return ExamHistoryModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      examTitle: exam?['title']?.toString() ??
          json['examTitle']?.toString() ??
          '',
      subjectName: subject?['name']?.toString() ??
          json['subjectName']?.toString() ??
          '',
      numberOfQuestions: _readInt(
            exam?['numberOfQuestions'] ?? json['numberOfQuestions'],
          ) ??
          0,
      durationMinutes: _readInt(
            exam?['duration'] ??
                json['durationMinutes'] ??
                json['duration'],
          ) ??
          0,
      correctAnswers: _readInt(
            json['correctAnswers'] ?? json['correct'],
          ) ??
          0,
      timeSpentMinutes: _readInt(
            json['timeSpentMinutes'] ?? json['time'],
          ) ??
          0,
    );
  }

  /// Builds a Results card from a `GET /questions/history` answer record
  /// plus optional exam/subject metadata fetched separately.
  factory ExamHistoryModel.fromAnswerHistory({
    required Map<String, dynamic> record,
    String examTitle = '',
    String subjectName = '',
    int? numberOfQuestions,
    int? durationMinutes,
  }) {
    final qid = _asStringKeyedMap(record['QID']);
    final examId = qid?['exam']?.toString() ??
        record['exam']?.toString() ??
        record['_id']?.toString() ??
        '';
    final isCorrect =
        (record['checkAnswer']?.toString().toLowerCase() ?? '') == 'correct';

    return ExamHistoryModel(
      id: record['_id']?.toString() ?? examId,
      examTitle: examTitle,
      subjectName: subjectName,
      numberOfQuestions: numberOfQuestions ?? 1,
      durationMinutes: durationMinutes ?? 0,
      correctAnswers: isCorrect ? 1 : 0,
      // avgAnswerTime may be a non-finite string/number from the API —
      // never call .round()/.toInt() on Infinity/NaN.
      timeSpentMinutes: _readInt(record['avgAnswerTime']) ?? 0,
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

  static Map<String, dynamic>? _asStringKeyedMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) {
      return value.map((key, val) => MapEntry(key.toString(), val));
    }
    return null;
  }

  static int? _readInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) {
      final d = value.toDouble();
      if (!d.isFinite) return null;
      return d.round();
    }
    if (value is String) {
      final asInt = int.tryParse(value.trim());
      if (asInt != null) return asInt;
      final asDouble = double.tryParse(value.trim());
      if (asDouble == null || !asDouble.isFinite) return null;
      return asDouble.round();
    }
    return null;
  }
}
