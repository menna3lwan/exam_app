import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/network/api_results.dart';
import '../../../domain/use_cases/get_questions_use_case.dart';
import 'start_exam_state.dart';

class StartExamCubit extends Cubit<StartExamState> {
  final GetQuestionsUseCase _getQuestionsUseCase;

  StartExamCubit(this._getQuestionsUseCase)
      : super(const StartExamInitial());

  Future<void> loadQuestions(String examId) async {
    emit(const StartExamLoading());

    final result = await _getQuestionsUseCase(examId);

    if (isClosed) return;

    switch (result) {
      case Success(:final data):
        final questions = data ?? [];
        if (questions.isEmpty) {
          emit(const StartExamError('No questions available for this exam'));
        } else {
          emit(StartExamLoaded(questions));
        }
      case Failure(:final message):
        emit(StartExamError(message ?? 'Failed to load questions'));
    }
  }
}
