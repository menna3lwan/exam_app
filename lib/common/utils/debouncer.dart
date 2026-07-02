import 'dart:async';
import 'dart:ui';

/// Generic debouncer utility (e.g. for search fields). No feature or
/// business logic attached — pure cross-cutting infra.
class Debouncer {
  final Duration delay;
  Timer? _timer;

  Debouncer({this.delay = const Duration(milliseconds: 400)});

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }

  void dispose() {
    _timer?.cancel();
  }
}
