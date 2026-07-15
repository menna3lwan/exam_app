/// Exam entity matching the Postman `GET /exams` response shape.
///
/// Fields confirmed from `POST /exams` (admin): title, duration, subject
/// (a Subject _id), numberOfQuestions.
class ExamModel {
  final String id;
  final String title;
  final int duration; // minutes (unit not confirmed — assumed from UI "30 Minutes")
  final String subject; // Subject._id
  final int numberOfQuestions;

  const ExamModel({
    required this.id,
    required this.title,
    required this.duration,
    required this.subject,
    required this.numberOfQuestions,
  });
}
