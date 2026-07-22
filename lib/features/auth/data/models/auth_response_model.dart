import 'user_model.dart';

/// Auth response model matching the exact Postman API response shape
/// for both POST /auth/signin and POST /auth/signup.
///
/// ```json
/// {
///   "message": "success",
///   "token": "eyJhbGciOi...",
///   "user": { ... }
/// }
/// ```
class AuthResponseModel {
  final String message;
  final String token;
  final UserModel user;

  const AuthResponseModel({
    required this.message,
    required this.token,
    required this.user,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      message: json['message'] as String? ?? '',
      token: json['token'] as String? ?? '',
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>? ?? {}),
    );
  }
}
