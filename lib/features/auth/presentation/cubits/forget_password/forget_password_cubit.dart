import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/network/api_results.dart';
import '../../../domain/use_cases/forget_password_use_case.dart';
import 'forget_password_state.dart';

class ForgetPasswordCubit extends Cubit<ForgetPasswordState> {
  final ForgetPasswordUseCase _forgetPasswordUseCase;

  ForgetPasswordCubit(this._forgetPasswordUseCase)
      : super(const ForgetPasswordInitial());

  Future<void> sendCode({required String email}) async {
    emit(const ForgetPasswordLoading());

    final result = await _forgetPasswordUseCase(email: email);

    if (isClosed) return;

    switch (result) {
      case Success():
        emit(const ForgetPasswordSuccess());
      case Failure(:final message):
        emit(ForgetPasswordError(message ?? 'Failed to send code'));
    }
  }
}
