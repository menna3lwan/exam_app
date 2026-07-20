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

  Future<void> loadHistory() async {
    emit(Resources.loading());

    final result = await _getExamHistoryUseCase();

    if (isClosed) return;

    switch (result) {
      case Success(:final data):
        emit(Resources.success(data: data ?? []));
      case Failure(:final message):
        emit(Resources.error(message: message ?? 'Failed to load results'));
    }
  }
}
