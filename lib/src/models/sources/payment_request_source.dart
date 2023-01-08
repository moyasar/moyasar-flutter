import 'package:moyasar/src/models/payment_type.dart';

abstract class PaymentRequestSource {
  late PaymentType type;

  Map<String, dynamic> toJson();
}
