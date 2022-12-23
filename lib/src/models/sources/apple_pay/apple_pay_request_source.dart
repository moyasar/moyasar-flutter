import 'package:moyasar/src/models/payment_type.dart';
import 'package:moyasar/src/models/sources/payment_request_source.dart';

class ApplePayPaymentRequestSource implements PaymentRequestSource {
  @override
  PaymentType type = PaymentType.applepay;

  late String token;

  ApplePayPaymentRequestSource(this.token);

  @override
  Map<String, dynamic> toJson() => {
        'type': type.name,
        'token': token,
      };
}
