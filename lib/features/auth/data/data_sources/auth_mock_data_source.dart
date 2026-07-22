import '../models/auth_response_model.dart';
import '../models/user_model.dart';
import 'auth_data_source.dart';

/// Mock data source for auth operations.
///
/// Simulates network delay and always returns success with fake data.
/// Implements [AuthDataSource] so the repository can swap between
/// mock and remote via DI.
class AuthMockDataSource implements AuthDataSource {
  static const _mockDelay = Duration(milliseconds: 600);

  static const _mockToken = 'mock_jwt_token_for_testing';

  static final _mockUser = UserModel(
    id: 'mock_user_id',
    username: 'mockuser',
    firstName: 'Mock',
    lastName: 'User',
    email: 'mock@test.com',
    phone: '01012345678',
    role: 'user',
    isVerified: false,
    createdAt: DateTime.now(),
  );

  @override
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    await Future.delayed(_mockDelay);
    return AuthResponseModel(
      message: 'success',
      token: _mockToken,
      user: _mockUser,
    );
  }

  @override
  Future<AuthResponseModel> signUp({
    required String username,
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String confirmPassword,
    required String phone,
  }) async {
    await Future.delayed(_mockDelay);
    return AuthResponseModel(
      message: 'success',
      token: _mockToken,
      user: _mockUser,
    );
  }

  @override
  Future<void> forgetPassword({required String email}) async {
    await Future.delayed(_mockDelay);
  }

  @override
  Future<void> verifyCode({required String code}) async {
    await Future.delayed(_mockDelay);
  }

  @override
  Future<void> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    await Future.delayed(_mockDelay);
  }

  @override
  Future<void> logout() async {
    await Future.delayed(_mockDelay);
  }

  // ── Profile ──

  @override
  Future<UserModel> getProfile() async {
    await Future.delayed(_mockDelay);
    return _mockUser;
  }

  @override
  Future<UserModel> updateProfile({
    String? username,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
  }) async {
    await Future.delayed(_mockDelay);
    return _mockUser;
  }

  @override
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    await Future.delayed(_mockDelay);
  }
}
