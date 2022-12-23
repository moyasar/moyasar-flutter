import 'package:flutter/material.dart';

import 'package:pay/pay.dart';

import 'package:moyasar/moyasar.dart';
import 'package:moyasar/src/moyasar.dart';
import 'package:moyasar/src/models/payment_request.dart';
import 'package:moyasar/src/models/sources/apple_pay/apple_pay_request_source.dart';

/// The widget that shows the Apple Pay button.
class ApplePay extends StatelessWidget {
  const ApplePay(
      {super.key, required this.config, required this.onPaymentResult});

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

  @override
  Widget build(BuildContext context) {
    return ApplePayButton(
      paymentConfigurationAsset: 'default_payment_profile_apple_pay.json',
      paymentItems: [
        PaymentItem(
          label: '',
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
