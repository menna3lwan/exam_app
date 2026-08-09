// SessionEventBus decouples "the token expired" (known deep inside a Dio
// interceptor) from "navigate to the login screen" (known only at the
// MaterialApp root). It is a true process-wide singleton — the factory
// constructor always returns the same instance — which is worth locking
// in explicitly, since a regression here (e.g. someone changing it to a
// plain constructor) would silently break session-expiry navigation.
import 'dart:async';

import 'package:flutter_test/flutter_test.dart';

import 'package:exam_app/core/services/session_event_bus.dart';

void main() {
  group('SessionEventBus singleton', () {
    test('the factory constructor always returns the same instance', () {
      expect(identical(SessionEventBus(), SessionEventBus()), isTrue);
    });
  });

  group('SessionEventBus event delivery', () {
    test('a listener subscribed before fire() receives the event', () async {
      final bus = SessionEventBus();
      final events = <SessionEvent>[];
      final sub = bus.stream.listen(events.add);

      bus.fire(SessionEvent.expired);
      await Future<void>.delayed(Duration.zero);

      expect(events, [SessionEvent.expired]);
      await sub.cancel();
    });

    test('multiple listeners all receive the same event (broadcast stream)', () async {
      final bus = SessionEventBus();
      final first = <SessionEvent>[];
      final second = <SessionEvent>[];
      final subA = bus.stream.listen(first.add);
      final subB = bus.stream.listen(second.add);

      bus.fire(SessionEvent.expired);
      await Future<void>.delayed(Duration.zero);

      expect(first, [SessionEvent.expired]);
      expect(second, [SessionEvent.expired]);

      await subA.cancel();
      await subB.cancel();
    });

    test('a listener subscribed after fire() does not receive past events', () async {
      final bus = SessionEventBus();
      bus.fire(SessionEvent.expired);
      await Future<void>.delayed(Duration.zero);

      final events = <SessionEvent>[];
      final sub = bus.stream.listen(events.add);
      await Future<void>.delayed(Duration.zero);

      expect(events, isEmpty);
      await sub.cancel();
    });
  });
}
