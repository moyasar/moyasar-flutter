import 'package:moyasar/src/models/payment_type.dart';
import 'package:moyasar/src/models/sources/payment_response_source.dart';

/// The response source from Moyasar API for the Apple Pay payment.
class ApplePayPaymentResponseSource implements PaymentResponseSource {
  @override
  PaymentType type = PaymentType.applepay;

  /// The [number] is masked.
  /// For example, `"XXXX-XXXX-XXXX-1115"`
  final String number; // masked!

  final String gatewayId;
  String? referenceNumber;
  String? token;
  String? message;

  ApplePayPaymentResponseSource({
    required this.number,
    required this.gatewayId,
    this.referenceNumber,
    this.token,
    this.message,
  });

  ApplePayPaymentResponseSource.fromJson(Map<String, dynamic> json)
      : number = json['number'],
        gatewayId = json['gateway_id'],
        referenceNumber = json['reference_number'],
        token = json['token'],
        message = json['message'];

  Map<String, dynamic> toJson() {
    return {
      'type': type.toString().split('.').last,
      'number': number,
      'gateway_id': gatewayId,
      'reference_number': referenceNumber,
      'token': token,
      'message': message,
    };
  }
}
