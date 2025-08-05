import 'package:moyasar/src/models/payment_type.dart';
import 'package:moyasar/src/models/sources/card/card_company.dart';
import 'package:moyasar/src/models/sources/payment_response_source.dart';

/// Used for token-based payments. Same as [CardPaymentResponseSource] but
/// without 3D Secure flow.
class CardTokenPaymentResponseSource implements PaymentResponseSource {
  @override
  PaymentType type = PaymentType.token;

  /// The card company (mada, visa, master, amex)
  final CardCompany company;

  /// Cardholder name.
  final String name;

  /// Masked card number showing first six and last four digits.
  final String number;

  /// ID used for the backing acquirer gateway.
  final String gatewayId;

  /// The retrieval reference number (RRN).
  String? referenceNumber;

  /// Token that is created using this payment.
  String? token;

  /// Human-readable string representing the transaction result.
  String? message;

  CardTokenPaymentResponseSource({
    required this.company,
    required this.name,
    required this.number,
    required this.gatewayId,
    this.referenceNumber,
    this.token,
    this.message,
  });

  factory CardTokenPaymentResponseSource.fromJson(Map<String, dynamic> json) {
    return CardTokenPaymentResponseSource(
      company: CardCompany.values.byName(json['company']),
      name: json['name'],
      number: json['number'],
      gatewayId: json['gateway_id'],
      referenceNumber: json['reference_number'],
      token: json['token'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'company': company.name,
      'name': name,
      'number': number,
      'gateway_id': gatewayId,
      'reference_number': referenceNumber,
      'token': token,
      'message': message,
    };
  }
}
