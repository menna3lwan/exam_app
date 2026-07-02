/// UI-facing result wrapper.
///
/// Carried over from the reference architecture (Clean-Arch-C6-Elevate)
/// unchanged. Every independent piece of screen state (e.g. "categories",
/// "banners" in the reference Home screen) is represented as its own
/// [Resources] instance, so unrelated parts of a screen can be
/// loading/success/error independently.
library;

enum Status { success, loading, error, init }

class Resources<T> {
  String? message;
  Exception? exception;
  T? data;
  Status status;

  Resources._() : status = Status.init;

  Resources.init() : status = Status.init;

  Resources.loading() : status = Status.loading;

  Resources.error({this.message, this.data, this.exception})
    : status = Status.error;

  Resources.success({this.data}) : status = Status.success;
}
