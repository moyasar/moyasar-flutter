import 'package:moyasar/src/models/payment_type.dart';
import 'package:moyasar/src/models/sources/payment_response_source.dart';


class StcResponseSource implements PaymentResponseSource {
  @override
  PaymentType type = PaymentType.creditcard;
  final String? mobile;
  final String? referenceNumber;
  final String? transactionUrl;
  final String? message;

  StcResponseSource({
    required this.type,
    required this.mobile,
    required this.referenceNumber,
    required this.transactionUrl,
    this.message,
  });

  factory StcResponseSource.fromJson(Map<String, dynamic> json) {
    return StcResponseSource(
      type: PaymentType.values.byName(json['type']),
      mobile: json['mobile'],
      referenceNumber: json['referenceNumber'],
      transactionUrl: json['transaction_url'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'mobile': mobile,
      'referenceNumber': referenceNumber,
      'transaction_url': transactionUrl,
      'message': message,
    };
  }
}
