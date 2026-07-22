import '../../../../core/network/api_results.dart';
import '../../data/models/auth_response_model.dart';

/// Auth repository contract — domain layer.
///
/// Defines what auth operations are available without specifying
/// how they're implemented (mock, remote API, etc.).
abstract class AuthRepository {
  /// Returns [AuthResponseModel] containing token + user data.
  /// The repository implementation saves the token internally.
  Future<ApiResults<AuthResponseModel>> login({
    required String email,
    required String password,
    required bool rememberMe,
  });

  /// Returns [AuthResponseModel] containing token + user data.
  Future<ApiResults<AuthResponseModel>> signUp({
    required String username,
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String confirmPassword,
    required String phone,
  });

  Future<ApiResults<void>> forgetPassword({required String email});

  /// [code] is the OTP code entered by the user.
  /// The repository maps it to `resetCode` for the API.
  Future<ApiResults<void>> verifyCode({required String code});

  Future<ApiResults<void>> resetPassword({
    required String email,
    required String newPassword,
  });

  /// Invalidates token server-side and clears local session.
  Future<ApiResults<void>> logout();
}
