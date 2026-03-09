import 'package:moyasar/src/models/payment_type.dart';
import 'package:moyasar/src/models/sources/payment_response_source.dart';

/// The response source from Moyasar API for the Samsung Pay payment.
class SamsungPayPaymentResponseSource implements PaymentResponseSource {
  @override
  PaymentType type = PaymentType.samsungpay;

  /// The masked card number (e.g. "XXXX-XXXX-XXXX-1115").
  final String number;

  /// The gateway transaction ID.
  final String gatewayId;

  /// Optional reference number from the gateway.
  final String? referenceNumber;

  /// Optional token for saved card flows.
  final String? token;

  /// Optional message from the gateway.
  final String? message;

  SamsungPayPaymentResponseSource({
    required this.number,
    required this.gatewayId,
    this.referenceNumber,
    this.token,
    this.message,
  });

  SamsungPayPaymentResponseSource.fromJson(Map<String, dynamic> json)
      : number = json['number'] as String,
        gatewayId = json['gateway_id'] as String,
        referenceNumber = json['reference_number'] as String?,
        token = json['token'] as String?,
        message = json['message'] as String?;

  Map<String, dynamic> toJson() => {
        'type': type.name,
        'number': number,
        'gateway_id': gatewayId,
        'reference_number': referenceNumber,
        'token': token,
        'message': message,
      };
}
