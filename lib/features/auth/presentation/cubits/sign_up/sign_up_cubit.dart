import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/network/api_results.dart';
import '../../../domain/use_cases/sign_up_use_case.dart';
import 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  final SignUpUseCase _signUpUseCase;

  SignUpCubit(this._signUpUseCase) : super(const SignUpInitial());

  Future<void> signUp({
    required String username,
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String confirmPassword,
    required String phone,
  }) async {
    emit(const SignUpLoading());

    final result = await _signUpUseCase(
      username: username,
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
      phone: phone,
    );

    if (isClosed) return;

    switch (result) {
      case Success():
        emit(const SignUpSuccess());
      case Failure(:final message):
        emit(SignUpError(message ?? 'Sign up failed'));
    }
  }
}
