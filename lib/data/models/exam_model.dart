/// Exam entity matching the Postman `GET /exams` response shape.
///
/// ```json
/// {
///   "_id": "69d980117c82914570305dd5",
///   "title": "JS Basics",
///   "duration": 20,
///   "subject": "69d980107c82914570305dbd",
///   "numberOfQuestions": 10,
///   "active": true,
///   "createdAt": "2026-04-10T22:56:17.993Z"
/// }
/// ```
class ExamModel {
  final String id;
  final String title;
  final int duration; // minutes
  final String subject; // Subject._id
  final int numberOfQuestions;
  final bool active;
  final DateTime? createdAt;

  const ExamModel({
    required this.id,
    required this.title,
    required this.duration,
    required this.subject,
    required this.numberOfQuestions,
    this.active = true,
    this.createdAt,
  });

  factory ExamModel.fromJson(Map<String, dynamic> json) {
    return ExamModel(
      id: json['_id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      duration: json['duration'] as int? ?? 0,
      subject: json['subject'] as String? ?? '',
      numberOfQuestions: json['numberOfQuestions'] as int? ?? 0,
      active: json['active'] as bool? ?? true,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'title': title,
        'duration': duration,
        'subject': subject,
        'numberOfQuestions': numberOfQuestions,
        'active': active,
        if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      };
}
