import 'package:flutter/material.dart';
import 'package:pay/pay.dart';
import 'package:moyasar/moyasar.dart';
import 'dart:convert';

/// The widget that shows the Apple Pay button.
class ApplePay extends StatelessWidget {
  ApplePay(
      {super.key,
      required this.config,
      required this.onPaymentResult,
      this.buttonType = ApplePayButtonType.inStore,
      this.buttonStyle = ApplePayButtonStyle.black})
      : assert(config.applePay != null,
            "Please add applePayConfig when instantiating the paymentConfig.");

  final PaymentConfig config;
  final Function onPaymentResult;
  final ApplePayButtonType buttonType;
  final ApplePayButtonStyle buttonStyle;

  void onApplePayError(error) {
    onPaymentResult(PaymentCanceledError());
  }

  void onApplePayResult(paymentResult) async {
    final token = paymentResult['token'];

    if (((token ?? '') == '')) {
      onPaymentResult(UnprocessableTokenError());
      return;
    }

    final source = ApplePayPaymentRequestSource(token, config.applePay!.manual);
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
          "merchantCapabilities": ${jsonEncode(config.applePay?.merchantCapabilities)},
          "supportedNetworks": ${jsonEncode(config.applePay?.supportedNetworks)},
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
      type: buttonType,
      style: buttonStyle,
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
