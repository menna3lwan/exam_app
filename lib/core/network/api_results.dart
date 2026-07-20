/// Repo-facing result wrapper (sealed, immutable).
///
/// Repository implementations return [ApiResults], which the presentation
/// layer (Cubit) pattern-matches into UI state.
sealed class ApiResults<T> {
  const ApiResults();
}

class Success<T> extends ApiResults<T> {
  final T? data;
  const Success(this.data);
}

class Failure<T> extends ApiResults<T> {
  final String? message;
  final Exception? exception;
  const Failure(this.message, [this.exception]);
}
