import 'package:dio/dio.dart';

import '../../../../data/models/subject_model.dart';
import 'home_data_source.dart';

/// Remote data source for home/explore — calls the live API via Dio.
///
/// Endpoint: `GET /subjects`
/// Response: `{ "message": "success", "metadata": {...}, "subjects": [...] }`
class HomeRemoteDataSource implements HomeDataSource {
  final Dio _dio;

  HomeRemoteDataSource(this._dio);

  @override
  Future<List<SubjectModel>> getSubjects() async {
    final response = await _dio.get<Map<String, dynamic>>('/subjects');
    final data = response.data;
    if (data == null) return [];

    final subjects = data['subjects'] as List<dynamic>? ?? [];
    return subjects
        .map((e) => SubjectModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
