sealed class ForgetPasswordState {
  const ForgetPasswordState();
}

class ForgetPasswordInitial extends ForgetPasswordState {
  const ForgetPasswordInitial();
}

class ForgetPasswordLoading extends ForgetPasswordState {
  const ForgetPasswordLoading();
}

/// One-time event: navigate to verification code screen.
class ForgetPasswordSuccess extends ForgetPasswordState {
  const ForgetPasswordSuccess();
}

class ForgetPasswordError extends ForgetPasswordState {
  final String message;
  const ForgetPasswordError(this.message);
}
