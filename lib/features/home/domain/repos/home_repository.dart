import '../../../../core/network/api_results.dart';
import '../../../../data/models/subject_model.dart';

/// Home repository contract — domain layer.
abstract class HomeRepository {
  Future<ApiResults<List<SubjectModel>>> getSubjects();
}
