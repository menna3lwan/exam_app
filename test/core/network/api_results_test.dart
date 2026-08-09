// ApiResults is the sealed contract every Repository returns. The only
// "behavior" it has is exhaustive pattern matching — this test locks in
// that Success/Failure carry their payload correctly and that a switch
// over ApiResults<T> is exhaustive (this file fails to *compile* if a
// third subtype is ever added without updating call sites, which is the
// entire point of using a sealed class here).
import 'package:flutter_test/flutter_test.dart';

import 'package:exam_app/core/network/api_results.dart';

/// Mirrors how every Cubit in the app consumes ApiResults —
/// via an exhaustive switch expression.
String describe(ApiResults<String> result) {
  return switch (result) {
    Success(:final data) => 'success:${data ?? 'null'}',
    Failure(:final message) => 'failure:${message ?? 'null'}',
  };
}

void main() {
  group('Success', () {
    test('carries the given data', () {
      const result = Success<String>('hello');
      expect(result.data, 'hello');
    });

    test('allows null data (e.g. void operations)', () {
      const result = Success<String>(null);
      expect(result.data, isNull);
    });

    test('is matched by the success branch of a switch', () {
      expect(describe(const Success('ok')), 'success:ok');
    });
  });

  group('Failure', () {
    test('carries message and exception', () {
      final exception = Exception('boom');
      final result = Failure<String>('boom', exception);
      expect(result.message, 'boom');
      expect(result.exception, exception);
    });

    test('exception is optional', () {
      const result = Failure<String>('boom');
      expect(result.exception, isNull);
    });

    test('is matched by the failure branch of a switch', () {
      expect(describe(const Failure('bad')), 'failure:bad');
    });
  });
}
