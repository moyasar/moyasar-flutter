import 'package:moyasar/moyasar.dart';
import 'package:moyasar/src/models/payment_type.dart';

/// Moyasar API response for processing a payment.
class PaymentResponse {
  late String id;
  late PaymentStatus status;
  late int amount;
  late int fee;
  late String currency;
  late int refunded;
  String? refundedAt;
  late int captured;
  String? capturedAt;
  String? voidedAt;
  String? description;
  late String amountFormat;
  late String feeFormat;
  late String refundedFormat;
  late String capturedFormat;
  String? invoiceId;
  String? ip;
  String? callbackUrl;
  late String createdAt;
  late String updatedAt;
  Map<String, dynamic>? metadata;
  late dynamic source;

  PaymentResponse.fromJson(Map<String, dynamic> json, PaymentType paymentType) {
    id = json['id'];
    status = PaymentStatus.values.byName(json['status']);
    amount = json['amount'];
    fee = json['fee'];
    currency = json['currency'];
    refunded = json['refunded'];
    refundedAt = json['refunded_at'];
    captured = json['captured'];
    capturedAt = json['captured_at'];
    voidedAt = json['voided_at'];
    description = json['description'];
    amountFormat = json['amount_format'];
    feeFormat = json['fee_format'];
    refundedFormat = json['refunded_format'];
    capturedFormat = json['captured_format'];
    invoiceId = json['invoice_id'];
    ip = json['ip'];
    callbackUrl = json['callback_url'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];

    if (json['metadata'] != null) {
      metadata = Map<String, dynamic>.from(json['metadata']);
    }

    if (paymentType == PaymentType.creditcard) {
      source = CardPaymentResponseSource.fromJson(json['source']);
    } else if (paymentType == PaymentType.applepay) {
      source = ApplePayPaymentResponseSource.fromJson(json['source']);
    } else if (paymentType == PaymentType.stcpay) {
      source = StcResponseSource.fromJson(json['source']);
    } else {
      source = json['source'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['status'] = status.name;
    data['amount'] = amount;
    data['fee'] = fee;
    data['currency'] = currency;
    data['refunded'] = refunded;
    data['refunded_at'] = refundedAt;
    data['captured'] = captured;
    data['captured_at'] = capturedAt;
    data['voided_at'] = voidedAt;
    data['description'] = description;
    data['amount_format'] = amountFormat;
    data['fee_format'] = feeFormat;
    data['refunded_format'] = refundedFormat;
    data['captured_format'] = capturedFormat;
    data['invoice_id'] = invoiceId;
    data['ip'] = ip;
    data['callback_url'] = callbackUrl;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (metadata != null) {
      data['metadata'] = metadata;
    }
    if (source != null) {
      if (source is CardPaymentResponseSource) {
        data['source'] = (source as CardPaymentResponseSource).toJson();
      } else if (source is ApplePayPaymentResponseSource) {
        data['source'] = (source as ApplePayPaymentResponseSource).toJson();
      } else if (source is StcResponseSource) {
        data['source'] = (source as StcResponseSource).toJson();
      } else {
        data['source'] = source;
      }
    }
    return data;
  }
}

enum PaymentStatus { initiated, paid, failed, authorized, captured }
