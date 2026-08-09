// safeCall is the single error-handling boundary between every
// RepositoryImpl and the Cubit layer — this is arguably the most
// important test file in `core/`, because if it silently mis-maps an
// exception type, every feature's error path breaks at once.
import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:exam_app/core/network/api_results.dart';
import 'package:exam_app/core/network/safe_call.dart';

void main() {
  group('safeCall — success path', () {
    test('passes through a Success result untouched', () async {
      final result = await safeCall<int>(() async => const Success(42));

      expect(result, isA<Success<int>>());
      expect((result as Success<int>).data, 42);
    });

    test('passes through a Failure returned by the call itself', () async {
      // A repository can legitimately return Failure without throwing
      // (e.g. it inspected a 200 response with an error payload).
      final result = await safeCall<int>(() async => const Failure('bad'));

      expect(result, isA<Failure<int>>());
      expect((result as Failure<int>).message, 'bad');
    });
  });

  group('safeCall — TimeoutException', () {
    test('maps to Failure using the exception message', () async {
      final result = await safeCall<int>(
        () async => throw TimeoutException('took too long'),
      );

      expect(result, isA<Failure<int>>());
      expect((result as Failure<int>).message, 'took too long');
    });

    test('falls back to a default message when none is provided', () async {
      final result = await safeCall<int>(
        () async => throw TimeoutException(null),
      );

      expect((result as Failure<int>).message, 'Request timed out');
    });
  });

  group('safeCall — DioException', () {
    test('extracts the server "message" field from the response body', () async {
      final dioError = DioException(
        requestOptions: RequestOptions(path: '/auth/signin'),
        response: Response(
          requestOptions: RequestOptions(path: '/auth/signin'),
          statusCode: 400,
          data: {'message': 'Email already exists'},
        ),
      );

      final result = await safeCall<int>(() async => throw dioError);

      expect((result as Failure<int>).message, 'Email already exists');
      expect(result.exception, dioError);
    });

    test('falls back to DioException.message when response has no message field', () async {
      final dioError = DioException(
        requestOptions: RequestOptions(path: '/exams'),
        response: Response(
          requestOptions: RequestOptions(path: '/exams'),
          statusCode: 500,
          data: <String, dynamic>{},
        ),
        message: 'Internal Server Error',
      );

      final result = await safeCall<int>(() async => throw dioError);

      expect((result as Failure<int>).message, 'Internal Server Error');
    });

    test('falls back to a generic "Network error" with no response at all', () async {
      final dioError = DioException(
        requestOptions: RequestOptions(path: '/exams'),
        type: DioExceptionType.connectionError,
      );

      final result = await safeCall<int>(() async => throw dioError);

      expect((result as Failure<int>).message, 'Network error');
    });
  });

  group('safeCall — other exception types', () {
    test('IOException-style errors are wrapped with a "Connection error" prefix', () async {
      final result = await safeCall<int>(
        () async => throw const HttpException('socket closed'),
      );

      expect((result as Failure<int>).message, contains('Connection error'));
      expect(result.message, contains('socket closed'));
    });

    test('a plain Exception is converted to its string form', () async {
      final result = await safeCall<int>(
        () async => throw Exception('unexpected state'),
      );

      expect((result as Failure<int>).message, contains('unexpected state'));
    });

    test('a non-Exception Error (e.g. type error) is still caught, never rethrown', () async {
      // This is the catch-all branch: `catch (e)` with no `on` clause.
      // Regression guard for the original bug class this app hit — a
      // malformed API response causing a cast Error must not crash the UI.
      final result = await safeCall<int>(
        () async => throw ArgumentError('bad cast'),
      );

      expect(result, isA<Failure<int>>());
      expect((result as Failure<int>).message, contains('bad cast'));
      // The catch-all branch does not attach the original error object.
      expect(result.exception, isNull);
    });
  });
}
