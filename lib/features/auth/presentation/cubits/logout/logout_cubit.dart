import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/network/api_results.dart';
import '../../../domain/use_cases/logout_use_case.dart';
import 'logout_state.dart';

class LogoutCubit extends Cubit<LogoutState> {
  final LogoutUseCase _logoutUseCase;

  LogoutCubit(this._logoutUseCase) : super(const LogoutInitial());

  Future<void> logout() async {
    emit(const LogoutLoading());

    final result = await _logoutUseCase();

    if (isClosed) return;

    switch (result) {
      case Success():
        emit(const LogoutSuccess());
      case Failure(:final message):
        // Even on failure, we still want to clear the local session
        // and navigate to login — the server might be unreachable.
        emit(const LogoutSuccess());
    }
  }
}
