/// UI-facing state wrapper.
///
/// Used as the Cubit state type for data-fetching screens.
/// Each independent piece of screen state is a [Resources] instance,
/// so unrelated parts of a screen can be loading/success/error independently.
///
/// Immutable by design — create new instances via named constructors.
enum Status { success, loading, error, init }

class Resources<T> {
  final String? message;
  final Exception? exception;
  final T? data;
  final Status status;

  const Resources._({
    this.status = Status.init,
    this.data,
    this.message,
    this.exception,
  });

  const Resources.init() : this._();

  const Resources.loading() : this._(status: Status.loading);

  const Resources.error({String? message, T? data, Exception? exception})
      : this._(
          status: Status.error,
          message: message,
          data: data,
          exception: exception,
        );

  const Resources.success({T? data})
      : this._(status: Status.success, data: data);
}
