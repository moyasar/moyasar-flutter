import 'package:moyasar/src/models/payment_type.dart';
import 'package:moyasar/src/models/sources/card/card_company.dart';
import 'package:moyasar/src/models/sources/payment_response_source.dart';

/// The response source from Moyasar API for the Credit Card payment.
class CardPaymentResponseSource implements PaymentResponseSource {
  @override
  PaymentType type = PaymentType.creditcard;

  final CardCompany? company;
  final String name;

  /// The [number] is masked.
  /// For example, `"XXXX-XXXX-XXXX-1115"`
  final String number; // masked!

  final String? gatewayId;
  String? referenceNumber;
  String? token;
  String? message;

  /// Used to complete the 3DS step.
  String? transactionUrl;

  CardPaymentResponseSource({
    this.company,
    required this.name,
    required this.number,
    this.gatewayId,
    this.referenceNumber,
    this.token,
    this.message,
    this.transactionUrl,
  });

  static CardCompany? _parseCompany(String? value) {
    if (value == null) return null;
    if (value == 'unionPay') return CardCompany.unionPay;
    try {
      return CardCompany.values.byName(value);
    } catch (_) {
      return null;
    }
  }

  CardPaymentResponseSource.fromJson(Map<String, dynamic> json)
      : company = _parseCompany(json['company']),
        name = json['name'] ?? '',
        number = json['number'] ?? '',
        gatewayId = json['gateway_id'],
        referenceNumber = json['reference_number'],
        token = json['token'],
        message = json['message'],
        transactionUrl = json['transaction_url'];

  Map<String, dynamic> toJson() {
    return {
      'company': company?.name,
      'name': name,
      'number': number,
      'gateway_id': gatewayId,
      'reference_number': referenceNumber,
      'token': token,
      'message': message,
      'transaction_url': transactionUrl,
    };
  }
}