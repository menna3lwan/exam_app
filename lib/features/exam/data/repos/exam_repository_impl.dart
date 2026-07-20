import '../../../../core/network/api_results.dart';
import '../../../../core/network/safe_call.dart';
import '../../../../data/models/exam_history_model.dart';
import '../../../../data/models/exam_model.dart';
import '../../../../data/models/exam_result_model.dart';
import '../../../../data/models/question_model.dart';
import '../../domain/repos/exam_repository.dart';
import '../data_sources/exam_mock_data_source.dart';

class ExamRepositoryImpl implements ExamRepository {
  final ExamMockDataSource _dataSource;

  ExamRepositoryImpl(this._dataSource);

  @override
  Future<ApiResults<List<ExamModel>>> getExamsForSubject(String subjectId) {
    return safeCall(() async {
      final exams = await _dataSource.getExamsForSubject(subjectId);
      return Success(exams);
    });
  }

  @override
  Future<ApiResults<List<QuestionModel>>> getQuestionsForExam(String examId) {
    return safeCall(() async {
      final questions = await _dataSource.getQuestionsForExam(examId);
      return Success(questions);
    });
  }

  @override
  Future<ApiResults<ExamResultModel>> submitExam({
    required String examId,
    required Map<String, String> answers,
    required int timeSpentSeconds,
  }) {
    return safeCall(() async {
      final result = await _dataSource.submitExam(
        examId: examId,
        answers: answers,
        timeSpentSeconds: timeSpentSeconds,
      );
      return Success(result);
    });
  }

  @override
  Future<ApiResults<List<ExamHistoryModel>>> getExamHistory() {
    return safeCall(() async {
      final history = await _dataSource.getExamHistory();
      return Success(history);
    });
  }
}
