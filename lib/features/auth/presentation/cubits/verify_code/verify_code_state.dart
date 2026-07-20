sealed class VerifyCodeState {
  const VerifyCodeState();
}

class VerifyCodeInitial extends VerifyCodeState {
  const VerifyCodeInitial();
}

class VerifyCodeLoading extends VerifyCodeState {
  const VerifyCodeLoading();
}

/// One-time event: navigate to reset password screen.
class VerifyCodeSuccess extends VerifyCodeState {
  const VerifyCodeSuccess();
}

class VerifyCodeError extends VerifyCodeState {
  final String message;
  const VerifyCodeError(this.message);
}

/// One-time event: resend code confirmation.
class VerifyCodeResent extends VerifyCodeState {
  const VerifyCodeResent();
}
