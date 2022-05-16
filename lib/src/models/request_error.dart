///
/// Base type for an error that can occur when consuming the Discord API
///
abstract class RequestError {}

///
/// Mixin that marks an error as traceable, meaning one can get the reason
/// and stack trace for the error
///
mixin TraceableError {
  String get reason;

  StackTrace get stackTrace;

  @override
  String toString() {
    return '$runtimeType($reason)';
  }
}

///
/// Occurs when the connection between the client and the
/// Discord API Server fails
///
class NetworkError extends RequestError with TraceableError {
  final String _reason;

  final StackTrace _stackTrace;

  NetworkError({
    required String reason,
    required StackTrace stackTrace,
  })  : _reason = reason,
        _stackTrace = stackTrace;

  @override
  String get reason => _reason;

  @override
  StackTrace get stackTrace => _stackTrace;
}

///
/// Occurs when the response status code is 404; Not Found
/// indicating that the channel could not be determined
///
class ChannelNotFound extends RequestError {}

///
/// Occurs when the provided Bot Token is not accepted by Discord API
///
class InvalidBotToken extends RequestError {}

///
/// Occurs when the client can't understand Discord API
///
class UnknownError extends RequestError with TraceableError {
  final String _reason;

  final StackTrace _stackTrace;

  UnknownError({
    required String reason,
    required StackTrace stackTrace,
  })  : _reason = reason,
        _stackTrace = stackTrace;

  @override
  String get reason => _reason;

  @override
  StackTrace get stackTrace => _stackTrace;
}
