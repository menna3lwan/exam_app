import 'dart:async';

/// Lightweight event bus for session lifecycle events.
///
/// The [AuthInterceptor] pushes [SessionExpired] when a 401/403 is
/// received. A listener at the app root (MaterialApp level) subscribes
/// and navigates to the login screen + clears the stack.
///
/// This avoids coupling the Dio interceptor to Flutter navigation.
enum SessionEvent { expired }

class SessionEventBus {
  static final SessionEventBus _instance = SessionEventBus._();
  factory SessionEventBus() => _instance;
  SessionEventBus._();

  final _controller = StreamController<SessionEvent>.broadcast();

  Stream<SessionEvent> get stream => _controller.stream;

  void fire(SessionEvent event) {
    _controller.add(event);
  }

  void dispose() {
    _controller.close();
  }
}
