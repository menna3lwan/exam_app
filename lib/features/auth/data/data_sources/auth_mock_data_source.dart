/// Mock data source for auth operations.
///
/// Simulates network delay and always returns success.
/// Will be replaced by a remote data source (Retrofit) in API phase.
class AuthMockDataSource {
  static const _mockDelay = Duration(milliseconds: 600);

  Future<void> login({
    required String email,
    required String password,
  }) async {
    await Future.delayed(_mockDelay);
    // Mock: always succeeds
  }

  Future<void> signUp({
    required String username,
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String confirmPassword,
    required String phone,
  }) async {
    await Future.delayed(_mockDelay);
  }

  Future<void> forgetPassword({required String email}) async {
    await Future.delayed(_mockDelay);
  }

  Future<void> verifyCode({
    required String email,
    required String code,
  }) async {
    await Future.delayed(_mockDelay);
  }

  Future<void> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    await Future.delayed(_mockDelay);
  }
}
