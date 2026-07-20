/// Question entity matching the Postman `GET /questions?exam={id}` shape.
///
/// Fixed 4-option MCQ: A1–A4 are the choices, `correct` holds which key
/// ("A1"–"A4") is the right answer.
class QuestionModel {
  final String id;
  final String question;
  final String a1;
  final String a2;
  final String a3;
  final String a4;
  final String correct; // "A1"–"A4"
  final String subject;
  final String exam;

  const QuestionModel({
    required this.id,
    required this.question,
    required this.a1,
    required this.a2,
    required this.a3,
    required this.a4,
    required this.correct,
    required this.subject,
    required this.exam,
  });

  /// Returns all 4 answer options as a list of (key, text) pairs.
  List<MapEntry<String, String>> get options => [
        MapEntry('A1', a1),
        MapEntry('A2', a2),
        MapEntry('A3', a3),
        MapEntry('A4', a4),
      ];

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['_id'] as String? ?? '',
      question: json['question'] as String? ?? '',
      a1: json['A1'] as String? ?? '',
      a2: json['A2'] as String? ?? '',
      a3: json['A3'] as String? ?? '',
      a4: json['A4'] as String? ?? '',
      correct: json['correct'] as String? ?? '',
      subject: json['subject'] as String? ?? '',
      exam: json['exam'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'question': question,
        'A1': a1,
        'A2': a2,
        'A3': a3,
        'A4': a4,
        'correct': correct,
        'subject': subject,
        'exam': exam,
      };
}
