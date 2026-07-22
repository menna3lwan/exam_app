import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/network/api_results.dart';
import '../../../domain/use_cases/reset_password_use_case.dart';
import 'reset_password_state.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  final ResetPasswordUseCase _resetPasswordUseCase;

  ResetPasswordCubit(this._resetPasswordUseCase)
      : super(const ResetPasswordInitial());

  Future<void> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    emit(const ResetPasswordLoading());

    final result = await _resetPasswordUseCase(
      email: email,
      newPassword: newPassword,
    );

    if (isClosed) return;

    switch (result) {
      case Success():
        emit(const ResetPasswordSuccess());
      case Failure(:final message):
        emit(ResetPasswordError(message ?? 'Reset failed'));
    }
  }
}
