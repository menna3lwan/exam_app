import 'package:dio/dio.dart';

import '../models/auth_response_model.dart';
import '../models/user_model.dart';
import 'auth_data_source.dart';

/// Remote data source for auth operations using Dio.
///
/// All endpoint paths, HTTP methods, and field names match the
/// Postman collection exactly (verified against live API 2026-07-22).
///
/// ## Postman API contracts (verified)
///
/// | Endpoint                 | Method | Body                                  | Success Response      |
/// |--------------------------|--------|---------------------------------------|-----------------------|
/// | `/auth/signin`           | POST   | `{email, password}`                   | `{message, token, user}` |
/// | `/auth/signup`           | POST   | `{username, firstName, lastName, email, password, rePassword, phone}` | `{message, token, user}` |
/// | `/auth/forgotPassword`   | POST   | `{email}`                             | `{message: "success"}` |
/// | `/auth/verifyResetCode`  | POST   | `{resetCode}`                         | `{message: "success"}` |
/// | `/auth/resetPassword`    | PUT    | `{email, newPassword}`                | `{message: "success"}` |
/// | `/auth/logout`           | GET    | (token in header)                     | `{message: "success"}` |
///
/// ## Password regex (from API validation error)
/// `^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,}$`
///
/// ## Error response shape
/// `{ "message": "...", "code": 401|400|404|500 }`
class AuthRemoteDataSource implements AuthDataSource {
  final Dio _dio;

  AuthRemoteDataSource(this._dio);

  @override
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _dio.post(
      '/auth/signin',
      data: {'email': email, 'password': password},
    );
    return AuthResponseModel.fromJson(response.data as Map<String, dynamic>);
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
    final response = await _dio.post(
      '/auth/signup',
      data: {
        'username': username,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'password': password,
        // Postman field mapping: confirmPassword → rePassword
        'rePassword': confirmPassword,
        'phone': phone,
      },
    );
    return AuthResponseModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<void> forgetPassword({required String email}) async {
    await _dio.post(
      '/auth/forgotPassword',
      data: {'email': email},
    );
  }

  @override
  Future<void> verifyCode({required String code}) async {
    await _dio.post(
      '/auth/verifyResetCode',
      // Postman field mapping: code → resetCode
      data: {'resetCode': code},
    );
  }

  @override
  Future<void> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    await _dio.put(
      '/auth/resetPassword',
      data: {'email': email, 'newPassword': newPassword},
    );
  }

  @override
  Future<void> logout() async {
    // Postman: GET /auth/logout with token header (attached by AuthInterceptor)
    await _dio.get('/auth/logout');
  }

  // ── Profile operations ──

  /// GET /auth/profileData — returns logged-in user info.
  @override
  Future<UserModel> getProfile() async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/auth/profileData',
    );
    final data = response.data;
    // Response expected: { "user": { ... } } or flat user object.
    final userJson = data?['user'] as Map<String, dynamic>? ?? data ?? {};
    return UserModel.fromJson(userJson);
  }

  /// PUT /auth/editProfile — partial update of profile fields.
  @override
  Future<UserModel> updateProfile({
    String? username,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
  }) async {
    final body = <String, dynamic>{};
    if (username != null) body['username'] = username;
    if (firstName != null) body['firstName'] = firstName;
    if (lastName != null) body['lastName'] = lastName;
    if (email != null) body['email'] = email;
    if (phone != null) body['phone'] = phone;

    final response = await _dio.put<Map<String, dynamic>>(
      '/auth/editProfile',
      data: body,
    );
    final data = response.data;
    final userJson = data?['user'] as Map<String, dynamic>? ?? data ?? {};
    return UserModel.fromJson(userJson);
  }

  /// PATCH /auth/changePassword
  @override
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    await _dio.patch(
      '/auth/changePassword',
      data: {
        'oldPassword': oldPassword,
        'password': newPassword,
        'rePassword': confirmPassword,
      },
    );
  }
}
