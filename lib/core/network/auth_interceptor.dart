import 'dart:async';

import 'package:dio/dio.dart';

import '../services/token_service.dart';
import 'api_constants.dart';

/// Dio interceptor that:
/// 1. Attaches the stored token as the `token` header on every request.
/// 2. Catches 401/403 responses and triggers a forced logout via
///    [onSessionExpired] callback.
///
/// The `token` header (not `Authorization: Bearer`) matches the Postman
/// collection's observed format:
/// ```
/// --header 'token: eyJhbGciOi...'
/// ```
class AuthInterceptor extends Interceptor {
  final TokenService _tokenService;

  /// Called when a 401 or 403 is received — the app should clear the
  /// session and navigate to the login screen.
  final void Function()? onSessionExpired;

  AuthInterceptor({
    required TokenService tokenService,
    this.onSessionExpired,
  }) : _tokenService = tokenService;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Skip attaching token for auth endpoints that don't need it.
    final isAuthEndpoint = options.path.contains('/auth/signin') ||
        options.path.contains('/auth/signup') ||
        options.path.contains('/auth/forgotPassword') ||
        options.path.contains('/auth/verifyResetCode') ||
        options.path.contains('/auth/resetPassword');

    if (!isAuthEndpoint) {
      final token = await _tokenService.getToken();
      if (token != null && token.isNotEmpty) {
        options.headers[authTokenHeaderKey] = token;
      }
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final statusCode = err.response?.statusCode;

    if (statusCode == 401 || statusCode == 403) {
      // Clear session and notify the app.
      _tokenService.clearSession().then((_) {
        onSessionExpired?.call();
      });
    }

    handler.next(err);
  }
}
