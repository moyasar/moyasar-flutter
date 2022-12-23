import 'package:moyasar/src/models/payment_type.dart';
import 'package:moyasar/src/models/sources/card/card_company.dart';
import 'package:moyasar/src/models/sources/payment_response_source.dart';

/// The response source from Moyasar API for the Credit Card payment.
class CardPaymentResponseSource implements PaymentResponseSource {
  @override
  PaymentType type = PaymentType.creditcard;

  final CardCompany company;
  final String name;

  /// The [number] is masked.
  /// For example, `"XXXX-XXXX-XXXX-1115"`
  final String number; // masked!

  final String gatewayId;
  String? referenceNumber;
  String? token;
  String? message;

  /// Used to complete the 3DS step.
  String transactionUrl;

  CardPaymentResponseSource({
    required this.company,
    required this.name,
    required this.number,
    required this.gatewayId,
    this.referenceNumber,
    this.token,
    this.message,
    required this.transactionUrl,
  });

  CardPaymentResponseSource.fromJson(Map<String, dynamic> json)
      : company = CardCompany.values.byName(json['company']),
        name = json['name'],
        number = json['number'],
        gatewayId = json['gateway_id'],
        referenceNumber = json['reference_number'],
        token = json['token'],
        message = json['message'],
        transactionUrl = json['transaction_url'];
}
