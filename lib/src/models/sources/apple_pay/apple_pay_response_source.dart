import 'package:moyasar/src/models/payment_type.dart';
import 'package:moyasar/src/models/sources/card/card_company.dart';
import 'package:moyasar/src/models/sources/payment_response_source.dart';

/// The response source from Moyasar API for the Apple Pay payment.
class ApplePayPaymentResponseSource implements PaymentResponseSource {
  @override
  PaymentType type = PaymentType.applepay;

  final CardCompany company;
  final String name;

  /// The [number] is masked.
  /// For example, `"XXXX-XXXX-XXXX-1115"`
  final String number; // masked!

  final String gatewayId;
  String? referenceNumber;
  String? message;

  ApplePayPaymentResponseSource({
    required this.company,
    required this.name,
    required this.number,
    required this.gatewayId,
    this.referenceNumber,
    this.message,
  });

  ApplePayPaymentResponseSource.fromJson(Map<String, dynamic> json)
      : company = CardCompany.values.byName(json['company']),
        name = json['name'],
        number = json['number'],
        gatewayId = json['gateway_id'],
        referenceNumber = json['reference_number'],
        message = json['message'];
}
