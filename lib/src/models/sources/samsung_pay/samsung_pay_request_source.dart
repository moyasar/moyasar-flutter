import 'package:moyasar/src/models/payment_type.dart';
import 'package:moyasar/src/models/sources/payment_request_source.dart';

/// Required data to setup a Samsung Pay payment.
///
/// Matches the React Native SDK - sends token and manual to Moyasar API.
class SamsungPayPaymentRequestSource implements PaymentRequestSource {
  @override
  PaymentType type = PaymentType.samsungpay;

  /// The Samsung Pay token returned by the Samsung Pay SDK.
  final String samsungPayToken;

  /// Whether to use manual capture (authorize only) or auto capture.
  final String manualPayment;

  /// Creates a Samsung Pay payment request source.
  SamsungPayPaymentRequestSource({
    required this.samsungPayToken,
    bool manualPayment = false,
  }) : manualPayment = manualPayment ? 'true' : 'false';

  @override
  Map<String, dynamic> toJson() => {
        'type': type.name,
        'token': samsungPayToken,
        'manual': manualPayment,
      };
}
