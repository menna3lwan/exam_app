import '../../../../core/network/api_results.dart';
import '../../../../data/models/question_model.dart';
import '../repos/exam_repository.dart';

class GetQuestionsUseCase {
  final ExamRepository _repository;

  GetQuestionsUseCase(this._repository);

  Future<ApiResults<List<QuestionModel>>> call(String examId) {
    return _repository.getQuestionsForExam(examId);
  }
}
