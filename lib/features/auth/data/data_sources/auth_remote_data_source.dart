import 'package:dio/dio.dart';

import '../models/auth_response_model.dart';
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
}
