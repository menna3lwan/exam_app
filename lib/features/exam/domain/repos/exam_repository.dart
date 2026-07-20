import '../../../../core/network/api_results.dart';
import '../../../../data/models/exam_history_model.dart';
import '../../../../data/models/exam_model.dart';
import '../../../../data/models/exam_result_model.dart';
import '../../../../data/models/question_model.dart';

/// Exam repository contract — domain layer.
abstract class ExamRepository {
  Future<ApiResults<List<ExamModel>>> getExamsForSubject(String subjectId);

  Future<ApiResults<List<QuestionModel>>> getQuestionsForExam(String examId);

  Future<ApiResults<ExamResultModel>> submitExam({
    required String examId,
    required Map<String, String> answers, // questionId → selected key
    required int timeSpentSeconds,
  });

  Future<ApiResults<List<ExamHistoryModel>>> getExamHistory();
}
