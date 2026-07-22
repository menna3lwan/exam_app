import 'dart:async';

import 'package:dio/dio.dart';

import '../services/token_service.dart';
import 'api_constants.dart';

/// Dio interceptor that:
/// 1. Attaches the stored token as the `token` header on every request.
/// 2. Catches 401/403 responses and triggers a forced logout via
///    [onSessionExpired] callback — but only for genuine auth failures,
///    not for server-side errors that happen to use a 401/403 status code.
///
/// The `token` header (not `Authorization: Bearer`) matches the Postman
/// collection's observed format:
/// ```
/// --header 'token: eyJhbGciOi...'
/// ```
class AuthInterceptor extends Interceptor {
  final TokenService _tokenService;

  /// Called when a 401 or 403 is received that represents a genuine
  /// authentication failure — the app should clear the session and
  /// navigate to the login screen.
  final void Function()? onSessionExpired;

  /// Re-entrancy guard: prevents cascading session-expiry events when
  /// multiple concurrent API calls all return 401/403 simultaneously.
  /// Once session expiry is triggered, subsequent 401/403 errors from
  /// in-flight requests are ignored (the session is already being cleared).
  bool _isHandlingExpiry = false;

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
    final isAuthEndpoint = _isAuthPath(options.path);

    if (!isAuthEndpoint) {
      final token = await _tokenService.getToken();
      if (token != null && token.isNotEmpty) {
        options.headers[authTokenHeaderKey] = token;
      }
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // After a successful login/signup, reset the expiry guard so the
    // interceptor can detect genuine token expiry in the new session.
    final path = response.requestOptions.path;
    if (path.contains('/auth/signin') || path.contains('/auth/signup')) {
      _isHandlingExpiry = false;
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final statusCode = err.response?.statusCode;

    if ((statusCode == 401 || statusCode == 403) && !_isHandlingExpiry) {
      // Only treat as session expiry if the response looks like a genuine
      // auth failure. Server-side errors (e.g. validation) sometimes
      // incorrectly use 401 status code — those should NOT trigger logout.
      if (_isAuthError(err)) {
        _isHandlingExpiry = true;
        _tokenService.clearSession().then((_) {
          onSessionExpired?.call();
        });
      }
    }

    handler.next(err);
  }

  /// Determines if a 401/403 response represents a genuine authentication
  /// failure vs a server-side error that happens to use 401/403 status.
  ///
  /// Heuristic: server validation errors include field-specific messages
  /// (e.g. "id must only contain hexadecimal characters"). Genuine auth
  /// errors mention token, auth, session, or return no message body.
  bool _isAuthError(DioException err) {
    final responseData = err.response?.data;

    // No response body — treat as auth error (server rejected outright).
    if (responseData == null) return true;

    if (responseData is Map<String, dynamic>) {
      final message =
          (responseData['message']?.toString().toLowerCase() ?? '').trim();

      // Empty message — likely a raw 401 from an auth middleware.
      if (message.isEmpty) return true;

      // Explicit auth-related keywords → genuine auth failure.
      if (message.contains('token') ||
          message.contains('not authenticated') ||
          message.contains('unauthorized') ||
          message.contains('not allowed') ||
          message.contains('expire') ||
          message.contains('invalid') && message.contains('login') ||
          message.contains('session')) {
        return true;
      }

      // Message doesn't match any auth keyword — likely a server
      // validation error that used 401 incorrectly. Do NOT treat
      // as session expiry; let the error propagate normally.
      return false;
    }

    // Non-map response — treat as auth error to be safe.
    return true;
  }

  bool _isAuthPath(String path) {
    return path.contains('/auth/signin') ||
        path.contains('/auth/signup') ||
        path.contains('/auth/forgotPassword') ||
        path.contains('/auth/verifyResetCode') ||
        path.contains('/auth/resetPassword');
  }
}
