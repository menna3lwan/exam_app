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

  /// GET /questions/history
  ///
  /// Confirmed live response shapes:
  /// - Empty: `{ "message": "success", "history": null }`
  /// - With data: `{ "message": "success", "history": { ...answer record... } }`
  ///
  /// `history` is a **single object** (or null), not a list of exam summaries.
  /// Casting it to `List` was the Results tab crash root cause.
  @override
  Future<List<ExamHistoryModel>> getExamHistory() async {
    final response =
        await _dio.get<Map<String, dynamic>>('/questions/history');
    final data = response.data;
    if (data == null) return [];

    final records = _normalizeHistoryRecords(
      data['history'] ??
          data['exams'] ??
          data['questions'] ??
          data['data'],
    );
    if (records.isEmpty) return [];

    final results = <ExamHistoryModel>[];
    for (final record in records) {
      results.add(await _mapAnswerRecord(record));
    }
    return results;
  }

  /// Accepts null, a single Map, or a List of Maps without throwing.
  List<Map<String, dynamic>> _normalizeHistoryRecords(dynamic raw) {
    if (raw == null) return [];
    if (raw is List) {
      return raw
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    }
    if (raw is Map) {
      return [Map<String, dynamic>.from(raw)];
    }
    return [];
  }

  Future<ExamHistoryModel> _mapAnswerRecord(Map<String, dynamic> record) async {
    final qid = record['QID'];
    final qidMap = qid is Map ? Map<String, dynamic>.from(qid) : null;
    var examId = qidMap?['exam']?.toString() ?? '';
    var subjectId = qidMap?['subject']?.toString() ?? '';

    String examTitle = '';
    String subjectName = '';
    int? numberOfQuestions;
    int? durationMinutes;

    if (examId.isNotEmpty) {
      try {
        final examResponse =
            await _dio.get<Map<String, dynamic>>('/exams/$examId');
        final exam = examResponse.data?['exam'];
        if (exam is Map) {
          final examMap = Map<String, dynamic>.from(exam);
          examTitle = examMap['title']?.toString() ?? '';
          numberOfQuestions = _readInt(examMap['numberOfQuestions']);
          durationMinutes = _readInt(examMap['duration']);
          if (subjectId.isEmpty) {
            subjectId = examMap['subject']?.toString() ?? '';
          }
        }
      } catch (_) {
        // Enrichment is best-effort — never fail Results over metadata.
      }
    }

    if (subjectId.isNotEmpty) {
      try {
        final subjectResponse =
            await _dio.get<Map<String, dynamic>>('/subjects/$subjectId');
        final category = subjectResponse.data?['category'] ??
            subjectResponse.data?['subject'];
        if (category is Map) {
          subjectName = category['name']?.toString() ?? '';
        }
      } catch (_) {
        // Best-effort.
      }
    }

    return ExamHistoryModel.fromAnswerHistory(
      record: record,
      examTitle: examTitle,
      subjectName: subjectName,
      numberOfQuestions: numberOfQuestions,
      durationMinutes: durationMinutes,
    );
  }

  static int? _readInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.round();
    if (value is String) {
      return int.tryParse(value) ?? double.tryParse(value)?.round();
    }
    return null;
  }
}
