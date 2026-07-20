import '../../../../core/network/api_results.dart';
import '../../../../data/models/exam_result_model.dart';
import '../repos/exam_repository.dart';

class SubmitExamUseCase {
  final ExamRepository _repository;

  SubmitExamUseCase(this._repository);

  Future<ApiResults<ExamResultModel>> call({
    required String examId,
    required Map<String, String> answers,
    required int timeSpentSeconds,
  }) {
    return _repository.submitExam(
      examId: examId,
      answers: answers,
      timeSpentSeconds: timeSpentSeconds,
    );
  }
}
