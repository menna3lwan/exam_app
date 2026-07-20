import '../../../../core/network/api_results.dart';

/// Auth repository contract — domain layer.
///
/// Defines what auth operations are available without specifying
/// how they're implemented (mock, remote API, etc.).
abstract class AuthRepository {
  Future<ApiResults<void>> login({
    required String email,
    required String password,
  });

  Future<ApiResults<void>> signUp({
    required String username,
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String confirmPassword,
    required String phone,
  });

  Future<ApiResults<void>> forgetPassword({required String email});

  Future<ApiResults<void>> verifyCode({
    required String email,
    required String code,
  });

  Future<ApiResults<void>> resetPassword({
    required String email,
    required String newPassword,
  });
}
