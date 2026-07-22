import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/base/resources.dart';
import '../../../../../core/network/api_results.dart';
import '../../../../../data/models/subject_model.dart';
import '../../../domain/use_cases/get_subjects_use_case.dart';

/// Explore tab cubit — emits [Resources] for ResourceStateBuilder.
class ExploreCubit extends Cubit<Resources<List<SubjectModel>>> {
  final GetSubjectsUseCase _getSubjectsUseCase;

  ExploreCubit(this._getSubjectsUseCase) : super(const Resources.init());

  Future<void> loadSubjects() async {
    emit(const Resources.loading());

    final result = await _getSubjectsUseCase();

    if (isClosed) return;

    switch (result) {
      case Success(:final data):
        emit(Resources.success(data: data ?? []));
      case Failure(:final message):
        emit(Resources.error(message: message));
    }
  }
}
