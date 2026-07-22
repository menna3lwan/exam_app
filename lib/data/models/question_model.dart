/// Question entity matching the Postman `GET /questions?exam={id}` shape.
///
/// ```json
/// {
///   "_id": "69d980127c82914570305dd8",
///   "question": "What keyword is used to declare a variable?",
///   "answers": [
///     { "answer": "var", "key": "A1" },
///     { "answer": "let", "key": "A2" },
///     { "answer": "const", "key": "A3" },
///     { "answer": "All of the above", "key": "A4" }
///   ],
///   "type": "single_choice",
///   "correct": "A4",
///   "subject": { "_id": "...", "name": "JavaScript", ... },
///   "exam": { "_id": "...", "title": "JS Basics", ... },
///   "createdAt": "2026-04-10T22:56:18.167Z"
/// }
/// ```
class QuestionModel {
  final String id;
  final String question;
  final String a1;
  final String a2;
  final String a3;
  final String a4;
  final String correct; // "A1"–"A4"
  final String type; // "single_choice"
  final String subjectId;
  final String examId;

  const QuestionModel({
    required this.id,
    required this.question,
    required this.a1,
    required this.a2,
    required this.a3,
    required this.a4,
    required this.correct,
    this.type = 'single_choice',
    required this.subjectId,
    required this.examId,
  });

  /// Returns all 4 answer options as a list of (key, text) pairs.
  List<MapEntry<String, String>> get options => [
        MapEntry('A1', a1),
        MapEntry('A2', a2),
        MapEntry('A3', a3),
        MapEntry('A4', a4),
      ];

  /// Parses the live API format where:
  /// - `answers` is a `List<Map>` with `{ answer: "text", key: "A1" }`.
  /// - `subject` and `exam` are nested objects — we extract `_id` only.
  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    // Parse answers list → keyed map { "A1": "text", "A2": "text", ... }
    final answersMap = <String, String>{};
    final rawAnswers = json['answers'];
    if (rawAnswers is List) {
      for (final entry in rawAnswers) {
        if (entry is Map<String, dynamic>) {
          final key = entry['key'] as String? ?? '';
          final answer = entry['answer'] as String? ?? '';
          if (key.isNotEmpty) answersMap[key] = answer;
        }
      }
    }

    // Extract subject ID — can be nested object or plain string
    String subjectId = '';
    final rawSubject = json['subject'];
    if (rawSubject is Map<String, dynamic>) {
      subjectId = rawSubject['_id'] as String? ?? '';
    } else if (rawSubject is String) {
      subjectId = rawSubject;
    }

    // Extract exam ID — can be nested object or plain string
    String examId = '';
    final rawExam = json['exam'];
    if (rawExam is Map<String, dynamic>) {
      examId = rawExam['_id'] as String? ?? '';
    } else if (rawExam is String) {
      examId = rawExam;
    }

    return QuestionModel(
      id: json['_id'] as String? ?? '',
      question: json['question'] as String? ?? '',
      a1: answersMap['A1'] ?? '',
      a2: answersMap['A2'] ?? '',
      a3: answersMap['A3'] ?? '',
      a4: answersMap['A4'] ?? '',
      correct: json['correct'] as String? ?? '',
      type: json['type'] as String? ?? 'single_choice',
      subjectId: subjectId,
      examId: examId,
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'question': question,
        'answers': [
          {'answer': a1, 'key': 'A1'},
          {'answer': a2, 'key': 'A2'},
          {'answer': a3, 'key': 'A3'},
          {'answer': a4, 'key': 'A4'},
        ],
        'type': type,
        'correct': correct,
        'subject': subjectId,
        'exam': examId,
      };
}
