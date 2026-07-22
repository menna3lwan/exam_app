import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/network/api_results.dart';
import '../../../domain/use_cases/login_use_case.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase _loginUseCase;

  LoginCubit(this._loginUseCase) : super(const LoginInitial());

  Future<void> login({
    required String email,
    required String password,
    required bool rememberMe,
  }) async {
    emit(const LoginLoading());

    final result = await _loginUseCase(
      email: email,
      password: password,
      rememberMe: rememberMe,
    );

    if (isClosed) return;

    switch (result) {
      case Success():
        emit(const LoginSuccess());
      case Failure(:final message):
        emit(LoginError(message ?? 'Login failed'));
    }
  }
}
