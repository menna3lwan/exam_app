import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/network/api_results.dart';
import '../../../../../data/models/exam_model.dart';
import '../../../../../data/models/subject_model.dart';
import '../../../domain/use_cases/get_exams_use_case.dart';
import 'subject_exams_state.dart';

class SubjectExamsCubit extends Cubit<SubjectExamsState> {
  final GetExamsUseCase _getExamsUseCase;

  SubjectExamsCubit(this._getExamsUseCase)
      : super(const SubjectExamsInitial());

  Future<void> loadExams(SubjectModel subject) async {
    emit(const SubjectExamsLoading());

    final result = await _getExamsUseCase(subject.id);

    if (isClosed) return;

    switch (result) {
      case Success(:final data):
        final exams = data ?? [];
        final grouped = _groupByTitle(exams);
        emit(SubjectExamsLoaded(subject: subject, groupedExams: grouped));
      case Failure(:final message):
        emit(SubjectExamsError(message ?? 'Failed to load exams'));
    }
  }

  Map<String, List<ExamModel>> _groupByTitle(List<ExamModel> exams) {
    final grouped = <String, List<ExamModel>>{};
    for (final exam in exams) {
      grouped.putIfAbsent(exam.title, () => []).add(exam);
    }
    return grouped;
  }
}
