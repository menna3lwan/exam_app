// Debouncer is generic cross-cutting infra (used for search-as-you-type
// style inputs). Its whole contract is "only the last call within the
// delay window actually runs" — verified here with fakeAsync so the
// test doesn't need to burn real wall-clock time.
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:exam_app/common/utils/debouncer.dart';

void main() {
  test('only the last call within the delay window executes', () {
    fakeAsync((async) {
      final debouncer = Debouncer(delay: const Duration(milliseconds: 300));
      var callCount = 0;
      var lastValue = 0;

      debouncer.run(() {
        callCount++;
        lastValue = 1;
      });
      async.elapse(const Duration(milliseconds: 100));

      debouncer.run(() {
        callCount++;
        lastValue = 2;
      });
      async.elapse(const Duration(milliseconds: 100));

      debouncer.run(() {
        callCount++;
        lastValue = 3;
      });
      async.elapse(const Duration(milliseconds: 300));

      expect(callCount, 1);
      expect(lastValue, 3);
    });
  });

  test('a call after the delay window has fully elapsed runs independently', () {
    fakeAsync((async) {
      final debouncer = Debouncer(delay: const Duration(milliseconds: 300));
      var callCount = 0;

      debouncer.run(() => callCount++);
      async.elapse(const Duration(milliseconds: 300));
      expect(callCount, 1);

      debouncer.run(() => callCount++);
      async.elapse(const Duration(milliseconds: 300));
      expect(callCount, 2);
    });
  });

  test('dispose cancels a pending call', () {
    fakeAsync((async) {
      final debouncer = Debouncer(delay: const Duration(milliseconds: 300));
      var callCount = 0;

      debouncer.run(() => callCount++);
      debouncer.dispose();
      async.elapse(const Duration(milliseconds: 300));

      expect(callCount, 0);
    });
  });
}
