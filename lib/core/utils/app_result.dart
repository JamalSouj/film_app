/// A lightweight, sealed result wrapper for repository calls.
///
/// Using a sealed class lets us exhaustively match on success / failure
/// in the ViewModel / provider layer without relying on exceptions for
/// control flow.
///
/// ```dart
/// final result = await repo.fetchMovies();
/// switch (result) {
///   case Success(:final data):
///     // use data
///   case Failure(:final message):
///     // show error
/// }
/// ```
sealed class AppResult<T> {
  const AppResult();
}

/// Represents a successful operation carrying [data].
final class Success<T> extends AppResult<T> {
  const Success(this.data);

  /// The payload returned from the operation.
  final T data;
}

/// Represents a failed operation carrying a human‑readable [message]
/// and an optional [exception] for debugging.
final class Failure<T> extends AppResult<T> {
  const Failure(this.message, [this.exception]);

  /// User‑facing error description.
  final String message;

  /// Original exception (if any) for crash‑reporting / logging.
  final Object? exception;
}
