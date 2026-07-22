import '../../../../core/network/api_results.dart';
import '../../../../data/models/exam_history_model.dart';
import '../repos/exam_repository.dart';

class GetExamHistoryUseCase {
  final ExamRepository _repository;

  GetExamHistoryUseCase(this._repository);

  Future<ApiResults<List<ExamHistoryModel>>> call() {
    return _repository.getExamHistory();
  }
}
