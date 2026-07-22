import '../../../../data/models/exam_history_model.dart';
import '../../../../data/models/exam_model.dart';
import '../../../../data/models/exam_result_model.dart';
import '../../../../data/models/question_model.dart';

/// Abstract contract for exam data sources.
///
/// Both [ExamMockDataSource] and [ExamRemoteDataSource] implement this,
/// allowing the repository to swap implementations via DI.
abstract class ExamDataSource {
  /// GET /exams?subject={subjectId} — returns exams for a subject.
  Future<List<ExamModel>> getExamsForSubject(String subjectId);

  /// GET /questions?exam={examId} — returns questions for an exam.
  Future<List<QuestionModel>> getQuestionsForExam(String examId);

  /// POST /questions/check — submit answers for grading.
  ///
  /// [answers] maps `questionId → selected answer key` (e.g. `"A2"`).
  Future<ExamResultModel> submitExam({
    required String examId,
    required Map<String, String> answers,
    required int timeSpentSeconds,
  });

  /// GET /exams/history — returns user's past exam results.
  Future<List<ExamHistoryModel>> getExamHistory();
}
