/// A failure specific to Apple Pay token being unprocessable.
/// Usually happens when you test using a simulator.
/// Retry using a real physical device.
class UnprocessableToken {
  final message = 'The Apple Pay token is unprocessable.';

  UnprocessableToken();
}
