/// Exam entity matching the Postman `GET /exams` response shape.
class ExamModel {
  final String id;
  final String title;
  final int duration; // minutes
  final String subject; // Subject._id
  final int numberOfQuestions;

  const ExamModel({
    required this.id,
    required this.title,
    required this.duration,
    required this.subject,
    required this.numberOfQuestions,
  });

  factory ExamModel.fromJson(Map<String, dynamic> json) {
    return ExamModel(
      id: json['_id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      duration: json['duration'] as int? ?? 0,
      subject: json['subject'] as String? ?? '',
      numberOfQuestions: json['numberOfQuestions'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'title': title,
        'duration': duration,
        'subject': subject,
        'numberOfQuestions': numberOfQuestions,
      };
}
