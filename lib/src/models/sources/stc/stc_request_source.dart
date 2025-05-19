import 'package:moyasar/src/models/payment_type.dart';
import 'package:moyasar/src/models/sources/payment_request_source.dart';

class StcRequestSource implements PaymentRequestSource {
  @override
  PaymentType type = PaymentType.stcpay;

  late String mobile;
  String? cashier; // Add cashier as optional

  // Optional fields in the class (these are not part of the JSON but were in the original class)
  late String referenceNumber;
  late String transactionUrl;
  late String message;
  final String? branch;

  StcRequestSource({required this.mobile, this.cashier, this.branch});

  @override
  Map<String, dynamic> toJson() => {
    'type': type.name,
    'mobile': mobile,
    'cashier': cashier,
    'branch': branch,
  };
}
