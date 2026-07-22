import '../../../../../data/models/question_model.dart';

sealed class StartExamState {
  const StartExamState();
}

class StartExamInitial extends StartExamState {
  const StartExamInitial();
}

class StartExamLoading extends StartExamState {
  const StartExamLoading();
}

/// Questions loaded — view should navigate to exam session.
class StartExamLoaded extends StartExamState {
  final List<QuestionModel> questions;
  const StartExamLoaded(this.questions);
}

class StartExamError extends StartExamState {
  final String message;
  const StartExamError(this.message);
}
