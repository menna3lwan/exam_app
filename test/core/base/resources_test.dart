// Resources<T> is the UI-facing state wrapper used by every "fetch and
// display a list" screen (Explore, Results). Its named constructors are
// the entire contract ResourceStateBuilder relies on, so each one is
// verified to set the right Status and to leave the other fields at
// their expected defaults.
import 'package:flutter_test/flutter_test.dart';

import 'package:exam_app/core/base/resources.dart';

void main() {
  group('Resources.init', () {
    test('defaults to Status.init with no data/message/exception', () {
      const resource = Resources<int>.init();
      expect(resource.status, Status.init);
      expect(resource.data, isNull);
      expect(resource.message, isNull);
      expect(resource.exception, isNull);
    });
  });

  group('Resources.loading', () {
    test('sets Status.loading and carries no data', () {
      const resource = Resources<int>.loading();
      expect(resource.status, Status.loading);
      expect(resource.data, isNull);
    });
  });

  group('Resources.success', () {
    test('sets Status.success and stores the payload', () {
      const resource = Resources<List<int>>.success(data: [1, 2, 3]);
      expect(resource.status, Status.success);
      expect(resource.data, [1, 2, 3]);
      expect(resource.message, isNull);
    });

    test('supports an empty-but-successful payload (empty list ≠ error)', () {
      const resource = Resources<List<int>>.success(data: []);
      expect(resource.status, Status.success);
      expect(resource.data, isEmpty);
    });
  });

  group('Resources.error', () {
    test('sets Status.error and stores message/exception', () {
      final exception = Exception('network down');
      final resource = Resources<int>.error(
        message: 'network down',
        exception: exception,
      );
      expect(resource.status, Status.error);
      expect(resource.message, 'network down');
      expect(resource.exception, exception);
    });

    test('can retain stale data alongside the error (Results refresh case)', () {
      const resource = Resources<List<int>>.error(
        message: 'refresh failed',
        data: [1, 2],
      );
      expect(resource.status, Status.error);
      expect(resource.data, [1, 2]);
      expect(resource.message, 'refresh failed');
    });
  });
}
