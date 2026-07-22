/// Sealed states for the login flow.
///
/// [LoginSuccess] and [LoginError] are one-time events consumed
/// by [BlocListener] for navigation and snackbar respectively.
sealed class LoginState {
  const LoginState();
}

class LoginInitial extends LoginState {
  const LoginInitial();
}

class LoginLoading extends LoginState {
  const LoginLoading();
}

class LoginSuccess extends LoginState {
  const LoginSuccess();
}

class LoginError extends LoginState {
  final String message;
  const LoginError(this.message);
}
