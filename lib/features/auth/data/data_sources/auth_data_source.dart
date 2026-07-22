import '../models/auth_response_model.dart';

/// Abstract contract for auth data sources.
///
/// Both [AuthMockDataSource] and [AuthRemoteDataSource] implement this,
/// allowing the repository to swap implementations via DI without
/// changing any business logic.
abstract class AuthDataSource {
  /// POST /auth/signin — returns token + user on success.
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  });

  /// POST /auth/signup — returns token + user on success.
  /// [confirmPassword] maps to `rePassword` in the API body.
  Future<AuthResponseModel> signUp({
    required String username,
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String confirmPassword,
    required String phone,
  });

  /// POST /auth/forgotPassword
  Future<void> forgetPassword({required String email});

  /// POST /auth/verifyResetCode
  /// [code] maps to `resetCode` in the API body.
  Future<void> verifyCode({required String code});

  /// PUT /auth/resetPassword
  Future<void> resetPassword({
    required String email,
    required String newPassword,
  });

  /// GET /auth/logout — invalidates token server-side.
  Future<void> logout();
}
