import '../../../../core/network/api_results.dart';
import '../../../../core/network/safe_call.dart';
import '../../../../data/models/subject_model.dart';
import '../../domain/repos/home_repository.dart';
import '../data_sources/home_data_source.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeDataSource _dataSource;

  HomeRepositoryImpl(this._dataSource);

  @override
  Future<ApiResults<List<SubjectModel>>> getSubjects() {
    return safeCall(() async {
      final subjects = await _dataSource.getSubjects();
      return Success(subjects);
    });
  }
}
