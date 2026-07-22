import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/network/api_results.dart';
import '../../../domain/use_cases/forget_password_use_case.dart';
import '../../../domain/use_cases/verify_code_use_case.dart';
import 'verify_code_state.dart';

class VerifyCodeCubit extends Cubit<VerifyCodeState> {
  final VerifyCodeUseCase _verifyCodeUseCase;
  final ForgetPasswordUseCase _forgetPasswordUseCase;

  VerifyCodeCubit(this._verifyCodeUseCase, this._forgetPasswordUseCase)
      : super(const VerifyCodeInitial());

  Future<void> verify({required String code}) async {
    emit(const VerifyCodeLoading());

    final result = await _verifyCodeUseCase(code: code);

    if (isClosed) return;

    switch (result) {
      case Success():
        emit(const VerifyCodeSuccess());
      case Failure(:final message):
        emit(VerifyCodeError(message ?? 'Invalid code'));
    }
  }

  Future<void> resendCode({required String email}) async {
    final result = await _forgetPasswordUseCase(email: email);

    if (isClosed) return;

    switch (result) {
      case Success():
        emit(const VerifyCodeResent());
      case Failure(:final message):
        emit(VerifyCodeError(message ?? 'Failed to resend code'));
    }
  }
}
