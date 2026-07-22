import '../../../../core/network/api_results.dart';
import '../../../../core/network/safe_call.dart';
import '../../../../core/services/token_service.dart';
import '../../domain/repos/auth_repository.dart';
import '../data_sources/auth_data_source.dart';
import '../models/auth_response_model.dart';
import '../models/user_model.dart';

/// Auth repository implementation — data layer.
///
/// Delegates to [AuthDataSource] (remote or mock) and wraps every call
/// with [safeCall] to guarantee a [Failure] on any exception.
///
/// Token persistence is handled here — the cubit/view layer never
/// touches the token directly.
class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource _dataSource;
  final TokenService _tokenService;

  AuthRepositoryImpl(this._dataSource, this._tokenService);

  @override
  Future<ApiResults<AuthResponseModel>> login({
    required String email,
    required String password,
    required bool rememberMe,
  }) {
    return safeCall(() async {
      final response = await _dataSource.login(
        email: email,
        password: password,
      );
      // Persist token + Remember Me preference.
      await _tokenService.saveToken(response.token);
      await _tokenService.setRememberMe(rememberMe);
      return Success(response);
    });
  }

  @override
  Future<ApiResults<AuthResponseModel>> signUp({
    required String username,
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String confirmPassword,
    required String phone,
  }) {
    return safeCall(() async {
      final response = await _dataSource.signUp(
        username: username,
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
        confirmPassword: confirmPassword,
        phone: phone,
      );
      // SignUp also returns a token — save it so the user can proceed.
      await _tokenService.saveToken(response.token);
      return Success(response);
    });
  }

  @override
  Future<ApiResults<void>> forgetPassword({required String email}) {
    return safeCall(() async {
      await _dataSource.forgetPassword(email: email);
      return const Success(null);
    });
  }

  @override
  Future<ApiResults<void>> verifyCode({required String code}) {
    return safeCall(() async {
      await _dataSource.verifyCode(code: code);
      return const Success(null);
    });
  }

  @override
  Future<ApiResults<void>> resetPassword({
    required String email,
    required String newPassword,
  }) {
    return safeCall(() async {
      await _dataSource.resetPassword(email: email, newPassword: newPassword);
      return const Success(null);
    });
  }

  @override
  Future<ApiResults<void>> logout() {
    return safeCall(() async {
      await _dataSource.logout();
      await _tokenService.clearSession();
      return const Success(null);
    });
  }

  // ── Profile ──

  @override
  Future<ApiResults<UserModel>> getProfile() {
    return safeCall(() async {
      final user = await _dataSource.getProfile();
      return Success(user);
    });
  }

  @override
  Future<ApiResults<UserModel>> updateProfile({
    String? username,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
  }) {
    return safeCall(() async {
      final user = await _dataSource.updateProfile(
        username: username,
        firstName: firstName,
        lastName: lastName,
        email: email,
        phone: phone,
      );
      return Success(user);
    });
  }

  @override
  Future<ApiResults<void>> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) {
    return safeCall(() async {
      await _dataSource.changePassword(
        oldPassword: oldPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );
      return const Success(null);
    });
  }
}
