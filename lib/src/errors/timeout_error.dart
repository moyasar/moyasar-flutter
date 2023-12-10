/// A request timeout error.
class TimeoutError {
  static const String type = 'timeout_error';

  final message = 'Request timed out.';

  TimeoutError();
}
