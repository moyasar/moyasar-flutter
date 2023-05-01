import 'package:flutter/material.dart';

import 'package:pay/pay.dart';

import 'package:moyasar/moyasar.dart';
import 'package:moyasar/src/moyasar.dart';
import 'package:moyasar/src/models/payment_request.dart';
import 'package:moyasar/src/models/sources/apple_pay/apple_pay_request_source.dart';

/// The widget that shows the Apple Pay button.
class ApplePay extends StatelessWidget {
  ApplePay({super.key, required this.config, required this.onPaymentResult})
      : assert(config.applePay != null,
            "Please add applePayConfig when instantiating the paymentConfig.");

  final PaymentConfig config;
  final Function onPaymentResult;

  void onApplePayError(error) {
    onPaymentResult(PaymentCanceledError());
  }

  void onApplePayResult(paymentResult) async {
    final token = paymentResult['token'];
    final source = ApplePayPaymentRequestSource(token);
    final paymentRequest = PaymentRequest(config, source);

    final result = await Moyasar.pay(
        apiKey: config.publishableApiKey, paymentRequest: paymentRequest);

    onPaymentResult(result);
  }

  String createConfigString() {
    return '''{
        "provider": "apple_pay",
        "data": {
          "merchantIdentifier": "${config.applePay?.merchantId}",
          "displayName": "${config.applePay?.label}",
          "merchantCapabilities": ["3DS", "debit", "credit"],
          "supportedNetworks": ["amex", "visa", "mada", "masterCard"],
          "countryCode": "SA",
          "currencyCode": "SAR"
        }
    }''';
  }

  @override
  Widget build(BuildContext context) {
    return ApplePayButton(
      paymentConfiguration:
          PaymentConfiguration.fromJsonString(createConfigString()),
      paymentItems: [
        PaymentItem(
          label: config.applePay?.label,
          amount: (config.amount / 100).toStringAsFixed(2),
        )
      ],
      type: ApplePayButtonType.inStore,
      onPaymentResult: onApplePayResult,
      width: MediaQuery.of(context).size.width,
      height: 40,
      onError: onApplePayError,
      loadingIndicator: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
