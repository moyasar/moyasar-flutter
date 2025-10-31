import 'package:moyasar/src/models/payment_type.dart';
import 'package:moyasar/src/models/sources/payment_request_source.dart';

/// A payment source that uses a saved or newly generated token.
///
/// This source is typically used when the user has already provided
/// their card details and a token has been created, and you want to
/// initiate a payment using that token.
class CardTokenPaymentRequestSource implements PaymentRequestSource {
  /// Must always be `'token'`. Required.
  ///
  /// This tells the API the type of source being used.
  @override
  PaymentType type = PaymentType.token;

  /// The token representing a previously stored card.
  ///
  /// Must start with `'token_'`.
  final String token;

  /// The card security code. Optional.
  ///
  /// - CVV for Visa,
  /// - CVC for Mastercard,
  /// - CSC for other brands.
  ///
  /// Must be 3 to 4 digits long.
  /// AMEX cards require 4 digits.
  final String? cvc;

  /// Optional statement descriptor (<= 255 characters).
  ///
  /// Allows the merchant to add extra information to the cardholder’s
  /// transaction statement.
  final String? statementDescriptor;

  /// Controls whether 3D Secure (3DS) authentication is used. Optional.
  ///
  /// - If set to `null`, the default is chosen based on token status:
  ///   - For `active` tokens, 3DS is set to `false`
  ///   - For `save_only` tokens, 3DS is set to `true`
  final bool? threeDS;

  /// If `true`, the payment will only be authorized and not captured. Optional.
  ///
  /// - If the payment is successful, the status will be set to `authorized`.
  /// - You will need to capture it manually later.
  final bool? manual;

  /// Creates a token-based payment request source.
  ///
  /// The [type] must be `'token'`.
  /// The [token] must start with `'token_'`.
  /// Optionally provides [cvc], [statementDescriptor], [threeDS], and [manual].
  CardTokenPaymentRequestSource({
    required this.token,
    this.cvc,
    this.statementDescriptor,
    this.threeDS,
    this.manual,
  }) {
    // Validation
    assert(token.startsWith('token_'), 'token must start with "token_"');
    if (cvc != null) {
      assert(RegExp(r'^\d{3,4}$').hasMatch(cvc!), 'Invalid CVC');
    }
    if (statementDescriptor != null) {
      assert(statementDescriptor!.length <= 255,
          'statement_descriptor must be <= 255 characters');
    }
  }

  /// Converts this model to a JSON map.
  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'token': token,
      if (cvc != null) 'cvc': cvc,
      if (statementDescriptor != null)
        'statement_descriptor': statementDescriptor,
      if (threeDS != null) '3ds': threeDS,
      if (manual != null) 'manual': manual,
    };
  }
}
