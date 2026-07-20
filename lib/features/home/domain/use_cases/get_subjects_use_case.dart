import '../../../../core/network/api_results.dart';
import '../../../../data/models/subject_model.dart';
import '../repos/home_repository.dart';

class GetSubjectsUseCase {
  final HomeRepository _repository;

  GetSubjectsUseCase(this._repository);

  Future<ApiResults<List<SubjectModel>>> call() {
    return _repository.getSubjects();
  }
}
