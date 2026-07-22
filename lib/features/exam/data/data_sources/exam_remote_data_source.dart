import 'package:dio/dio.dart';

import '../../../../data/models/exam_history_model.dart';
import '../../../../data/models/exam_model.dart';
import '../../../../data/models/exam_result_model.dart';
import '../../../../data/models/question_model.dart';
import 'exam_data_source.dart';

/// Remote data source for exam operations — calls the live API via Dio.
class ExamRemoteDataSource implements ExamDataSource {
  final Dio _dio;

  ExamRemoteDataSource(this._dio);

  /// GET /exams?subject={subjectId}
  /// Response: `{ "message": "success", "metadata": {...}, "exams": [...] }`
  @override
  Future<List<ExamModel>> getExamsForSubject(String subjectId) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/exams',
      queryParameters: {'subject': subjectId},
    );
    final data = response.data;
    if (data == null) return [];

    final exams = data['exams'] as List<dynamic>? ?? [];
    return exams
        .map((e) => ExamModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// GET /questions?exam={examId}
  /// Response: `{ "questions": [...] }`
  @override
  Future<List<QuestionModel>> getQuestionsForExam(String examId) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/questions',
      queryParameters: {'exam': examId},
    );
    final data = response.data;
    if (data == null) return [];

    final questions = data['questions'] as List<dynamic>? ?? [];
    return questions
        .map((e) => QuestionModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// POST /questions/check
  ///
  /// Request body: `{ "answers": [{ "questionId": "...", "correct": "A2" }, ...] }`
  /// Response: `{ "correct": 1, "wrong": 0, "total": "100%", "WrongQuestions": [...] }`
  @override
  Future<ExamResultModel> submitExam({
    required String examId,
    required Map<String, String> answers,
    required int timeSpentSeconds,
  }) async {
    // Transform Map<questionId, answerKey> → API's list format
    final answersList = answers.entries
        .map((e) => {'questionId': e.key, 'correct': e.value})
        .toList();

    final response = await _dio.post<Map<String, dynamic>>(
      '/questions/check',
      data: {'answers': answersList},
    );
    final data = response.data;
    if (data == null) {
      return const ExamResultModel(correct: 0, wrong: 0, total: 0);
    }

    return ExamResultModel.fromJson(data);
  }

  /// GET /exams/history
  /// Response shape not yet verified — falls back to empty list on error.
  @override
  Future<List<ExamHistoryModel>> getExamHistory() async {
    final response =
        await _dio.get<Map<String, dynamic>>('/exams/history');
    final data = response.data;
    if (data == null) return [];

    final exams = data['exams'] as List<dynamic>? ?? [];
    return exams
        .map((e) => ExamHistoryModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
