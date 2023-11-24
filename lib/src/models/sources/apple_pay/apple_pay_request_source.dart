import 'package:moyasar/src/models/payment_type.dart';
import 'package:moyasar/src/models/sources/payment_request_source.dart';

/// Required data to setup an Apple Pay payment.
///
/// Use only when you need to customize the UI.
class ApplePayPaymentRequestSource implements PaymentRequestSource {
  @override
  PaymentType type = PaymentType.applepay;

  late String token;

  late String manual;

  ApplePayPaymentRequestSource(this.token, bool manualPayment) {
    manual = manualPayment ? 'true' : 'false';
  }
  @override
  Map<String, dynamic> toJson() =>
      {'type': type.name, 'token': token, 'manual': manual};
}
