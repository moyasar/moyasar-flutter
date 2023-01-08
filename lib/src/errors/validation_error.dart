/// A validation error in any of the params.
class ValidationError {
  late String message;
  Map<String, dynamic>? errors;

  ValidationError(this.message, this.errors);
  ValidationError.messageOnly(this.message);
}
