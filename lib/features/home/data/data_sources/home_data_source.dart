import '../../../../data/models/subject_model.dart';

/// Abstract contract for home data sources.
///
/// Both [HomeMockDataSource] and [HomeRemoteDataSource] implement this,
/// allowing the repository to swap implementations via DI.
abstract class HomeDataSource {
  /// GET /subjects — returns list of available subjects.
  Future<List<SubjectModel>> getSubjects();
}
