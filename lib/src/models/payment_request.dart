import 'package:moyasar/moyasar.dart';
import 'package:moyasar/src/models/sources/payment_request_source.dart';

class PaymentRequest {
  late int amount;
  late String currency;
  String? description;
  Map<String, String>? metadata;
  late PaymentRequestSource source;

  String callbackUrl = PaymentConfig.callbackUrl;

  PaymentRequest(
      PaymentConfig config, PaymentRequestSource paymentRequestSource) {
    amount = config.amount;
    currency = config.currency;
    description = config.description;
    metadata = config.metadata;
    source = paymentRequestSource;
  }

  Map<String, dynamic> toJson() => {
        'amount': amount,
        'source': source.toJson(),
        'currency': currency,
        'description': description,
        'metadata': metadata,
        'callback_url': callbackUrl,
      };
}
