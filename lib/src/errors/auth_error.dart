/// A failure in authing the request.
/// Double check your `publishableApiKey` in the `PaymentConfig`.
class AuthError {
  final String message;

  AuthError(this.message);
}
