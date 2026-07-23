import '../../../../core/network/api_results.dart';
import '../../../../core/network/safe_call.dart';
import '../../../../core/services/exam_history_store.dart';
import '../../../../data/models/exam_history_model.dart';
import '../../../../data/models/exam_model.dart';
import '../../../../data/models/exam_result_model.dart';
import '../../../../data/models/question_model.dart';
import '../../domain/repos/exam_repository.dart';
import '../data_sources/exam_data_source.dart';

class ExamRepositoryImpl implements ExamRepository {
  final ExamDataSource _dataSource;
  final ExamHistoryStore _historyStore;

  ExamRepositoryImpl(this._dataSource, this._historyStore);

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
      final local = await _historyStore.getAll();

      // Remote parsing must never wipe local Results. If the API shape is
      // unexpected, fall back to local (or empty) instead of a hard error.
      List<ExamHistoryModel> remote = const [];
      Object? remoteError;
      try {
        remote = await _dataSource.getExamHistory();
      } catch (e) {
        remoteError = e;
        if (local.isEmpty) rethrow;
      }

      if (local.isNotEmpty) {
        return Success(_mergePreferLocal(local: local, remote: remote));
      }
      if (remoteError != null) {
        // Should be unreachable because we rethrow when local is empty,
        // but keeps the intent explicit for readers.
        throw remoteError;
      }
      return Success(remote);
    });
  }

  /// Keeps local exam summaries first, then appends remote entries whose ids
  /// are not already represented locally.
  List<ExamHistoryModel> _mergePreferLocal({
    required List<ExamHistoryModel> local,
    required List<ExamHistoryModel> remote,
  }) {
    final localIds = local.map((e) => e.id).toSet();
    final extras = remote.where((e) => !localIds.contains(e.id));
    return [...local, ...extras];
  }
}
