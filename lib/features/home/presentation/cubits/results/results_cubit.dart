import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/base/resources.dart';
import '../../../../../core/network/api_results.dart';
import '../../../../../data/models/exam_history_model.dart';
import '../../../../exam/domain/use_cases/get_exam_history_use_case.dart';

/// Loads exam history for the Results tab.
///
/// Uses [Resources<List<ExamHistoryModel>>] for centralized state rendering.
class ResultsCubit extends Cubit<Resources<List<ExamHistoryModel>>> {
  final GetExamHistoryUseCase _getExamHistoryUseCase;

  ResultsCubit(this._getExamHistoryUseCase) : super(Resources.init());

  /// Loads exam history from the API.
  ///
  /// When [isRefresh] is true (pull-to-refresh), the current data stays
  /// visible instead of showing a loading spinner. On refresh failure the
  /// existing data is preserved — only initial load failures show the
  /// error state.
  Future<void> loadHistory({bool isRefresh = false}) async {
    if (!isRefresh) {
      emit(Resources.loading());
    }

    final result = await _getExamHistoryUseCase();

    if (isClosed) return;

    switch (result) {
      case Success(:final data):
        emit(Resources.success(data: data ?? []));
      case Failure(:final message):
        // During a refresh, keep the old data visible rather than
        // replacing the entire UI with an error state.
        if (!isRefresh) {
          emit(Resources.error(message: message ?? 'Failed to load results'));
        }
    }
  }
}
