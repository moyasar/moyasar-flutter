import 'package:moyasar/moyasar.dart';
import 'package:moyasar/src/models/sources/payment_request_source.dart';

/// Required data to setup a payment.
///
/// Use only when you need to customize the UI.
class PaymentRequest {
  late int amount;
  late String currency;
  String? description;
  Map<String, dynamic>? metadata;
  late PaymentRequestSource source;
  String? givenID;
  String callbackUrl = PaymentConfig.callbackUrl;
  List<PaymentSplit>? splits;
  String? baseUrl;

  PaymentRequest(
    PaymentConfig config,
    PaymentRequestSource paymentRequestSource, {
    Map<String, dynamic>? additionalMetadata,
  }) {
    amount = config.amount;
    currency = config.currency;
    description = config.description;
    metadata = {
      ...?config.metadata,
      ...?additionalMetadata,
    };
    if (metadata!.isEmpty) metadata = null;
    source = paymentRequestSource;
    givenID = config.givenID;
    splits = config.splits;
    baseUrl = config.baseUrl;
  }

  Map<String, dynamic> toJson() => {
        'amount': amount,
        'source': source.toJson(),
        'currency': currency,
        'description': description,
        'metadata': metadata,
        'callback_url': callbackUrl,
        if (givenID != null) 'given_id': givenID,
        if (splits != null && splits!.isNotEmpty)
          'splits': splits!.map((split) => split.toJson()).toList(),
      };
}
