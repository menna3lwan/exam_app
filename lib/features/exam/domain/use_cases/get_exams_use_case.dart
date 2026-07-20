import '../../../../core/network/api_results.dart';
import '../../../../data/models/exam_model.dart';
import '../repos/exam_repository.dart';

class GetExamsUseCase {
  final ExamRepository _repository;

  GetExamsUseCase(this._repository);

  Future<ApiResults<List<ExamModel>>> call(String subjectId) {
    return _repository.getExamsForSubject(subjectId);
  }
}
