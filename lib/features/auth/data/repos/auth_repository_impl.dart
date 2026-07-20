import '../../../../core/network/api_results.dart';
import '../../../../core/network/safe_call.dart';
import '../../domain/repos/auth_repository.dart';
import '../data_sources/auth_mock_data_source.dart';

/// Auth repository implementation — data layer.
///
/// Delegates to [AuthMockDataSource] and wraps every call with [safeCall]
/// to guarantee a [Failure] on any exception.
class AuthRepositoryImpl implements AuthRepository {
  final AuthMockDataSource _dataSource;

  AuthRepositoryImpl(this._dataSource);

  @override
  Future<ApiResults<void>> login({
    required String email,
    required String password,
  }) {
    return safeCall(() async {
      await _dataSource.login(email: email, password: password);
      return const Success(null);
    });
  }

  @override
  Future<ApiResults<void>> signUp({
    required String username,
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String confirmPassword,
    required String phone,
  }) {
    return safeCall(() async {
      await _dataSource.signUp(
        username: username,
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
        confirmPassword: confirmPassword,
        phone: phone,
      );
      return const Success(null);
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
  Future<ApiResults<void>> verifyCode({
    required String email,
    required String code,
  }) {
    return safeCall(() async {
      await _dataSource.verifyCode(email: email, code: code);
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
}
