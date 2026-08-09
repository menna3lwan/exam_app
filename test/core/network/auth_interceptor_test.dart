// AuthInterceptor is the piece that turns a raw 401/403 into a session
// wipe + forced-logout event — but only when it's a *genuine* auth
// failure. Getting this wrong either logs users out on unrelated
// validation errors, or leaves a dead session hanging around. Both
// branches are asserted here directly against the interceptor, with no
// real network involved.
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:exam_app/core/network/api_constants.dart';
import 'package:exam_app/core/network/auth_interceptor.dart';

import '../../helpers/mocks.dart';

void main() {
  late MockTokenService tokenService;
  late int sessionExpiredCalls;
  late AuthInterceptor interceptor;

  setUp(() {
    tokenService = MockTokenService();
    sessionExpiredCalls = 0;
    when(() => tokenService.clearSession()).thenAnswer((_) async {});
    interceptor = AuthInterceptor(
      tokenService: tokenService,
      onSessionExpired: () => sessionExpiredCalls++,
    );
  });

  RequestOptions optionsFor(String path) => RequestOptions(path: path);

  DioException errorFor({
    required String path,
    required int statusCode,
    dynamic data,
  }) {
    return DioException(
      requestOptions: optionsFor(path),
      response: Response(
        requestOptions: optionsFor(path),
        statusCode: statusCode,
        data: data,
      ),
    );
  }

  group('onRequest — token header attachment', () {
    test('attaches the token header for a normal endpoint', () async {
      when(() => tokenService.getToken()).thenAnswer((_) async => 'jwt-123');
      final options = optionsFor('/exams');

      interceptor.onRequest(options, RequestInterceptorHandler());
      await Future<void>.delayed(Duration.zero);

      expect(options.headers[authTokenHeaderKey], 'jwt-123');
    });

    test('does not attach a header when there is no stored token', () async {
      when(() => tokenService.getToken()).thenAnswer((_) async => null);
      final options = optionsFor('/exams');

      interceptor.onRequest(options, RequestInterceptorHandler());
      await Future<void>.delayed(Duration.zero);

      expect(options.headers.containsKey(authTokenHeaderKey), isFalse);
    });

    for (final path in [
      '/auth/signin',
      '/auth/signup',
      '/auth/forgotPassword',
      '/auth/verifyResetCode',
      '/auth/resetPassword',
    ]) {
      test('skips token attachment entirely for auth endpoint $path', () async {
        final options = optionsFor(path);

        interceptor.onRequest(options, RequestInterceptorHandler());
        await Future<void>.delayed(Duration.zero);

        expect(options.headers.containsKey(authTokenHeaderKey), isFalse);
        verifyNever(() => tokenService.getToken());
      });
    }
  });

  group('onError — genuine auth failures trigger session expiry', () {
    test('401 with a token-related message clears the session and fires the callback', () async {
      final err = errorFor(
        path: '/exams',
        statusCode: 401,
        data: {'message': 'Token expired'},
      );

      interceptor.onError(err, ErrorInterceptorHandler());
      await Future<void>.delayed(Duration.zero);

      verify(() => tokenService.clearSession()).called(1);
      expect(sessionExpiredCalls, 1);
    });

    test('403 with an empty message body is treated as a genuine auth failure', () async {
      final err = errorFor(path: '/exams', statusCode: 403, data: <String, dynamic>{});

      interceptor.onError(err, ErrorInterceptorHandler());
      await Future<void>.delayed(Duration.zero);

      expect(sessionExpiredCalls, 1);
    });

    test('401 with no response body at all is treated as a genuine auth failure', () async {
      final err = DioException(requestOptions: optionsFor('/exams'), response: null);

      interceptor.onError(err, ErrorInterceptorHandler());
      await Future<void>.delayed(Duration.zero);

      expect(sessionExpiredCalls, 1);
    });

    test('401 with a non-Map response body is treated as a genuine auth failure', () async {
      final err = errorFor(path: '/exams', statusCode: 401, data: 'Unauthorized');

      interceptor.onError(err, ErrorInterceptorHandler());
      await Future<void>.delayed(Duration.zero);

      expect(sessionExpiredCalls, 1);
    });
  });

  group('onError — server validation errors must NOT trigger a logout', () {
    test('401 whose message is an unrelated validation error is ignored', () async {
      final err = errorFor(
        path: '/exams',
        statusCode: 401,
        data: {'message': 'id must only contain hexadecimal characters'},
      );

      interceptor.onError(err, ErrorInterceptorHandler());
      await Future<void>.delayed(Duration.zero);

      verifyNever(() => tokenService.clearSession());
      expect(sessionExpiredCalls, 0);
    });

    test('non-401/403 status codes never trigger session expiry', () async {
      final err = errorFor(path: '/exams', statusCode: 500, data: {'message': 'Server error'});

      interceptor.onError(err, ErrorInterceptorHandler());
      await Future<void>.delayed(Duration.zero);

      expect(sessionExpiredCalls, 0);
    });
  });

  group('onError — re-entrancy guard', () {
    test('a second concurrent 401 does not fire the callback twice', () async {
      final err = errorFor(path: '/exams', statusCode: 401, data: {'message': 'unauthorized'});

      interceptor.onError(err, ErrorInterceptorHandler());
      interceptor.onError(err, ErrorInterceptorHandler());
      await Future<void>.delayed(Duration.zero);

      expect(sessionExpiredCalls, 1);
      verify(() => tokenService.clearSession()).called(1);
    });

    test('after a fresh sign-in response, a later 401 can trigger expiry again', () async {
      final firstError = errorFor(path: '/exams', statusCode: 401, data: {'message': 'unauthorized'});
      interceptor.onError(firstError, ErrorInterceptorHandler());
      await Future<void>.delayed(Duration.zero);
      expect(sessionExpiredCalls, 1);

      // Successful re-login resets the guard.
      final signInResponse = Response(
        requestOptions: optionsFor('/auth/signin'),
        statusCode: 200,
        data: {'message': 'success'},
      );
      interceptor.onResponse(signInResponse, ResponseInterceptorHandler());

      final secondError = errorFor(path: '/exams', statusCode: 401, data: {'message': 'unauthorized'});
      interceptor.onError(secondError, ErrorInterceptorHandler());
      await Future<void>.delayed(Duration.zero);

      expect(sessionExpiredCalls, 2);
    });
  });
}
