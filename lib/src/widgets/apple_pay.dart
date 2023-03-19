import 'package:flutter/material.dart';
import 'package:moyasar/src/utils/apple_pay_utils.dart';

import 'package:pay/pay.dart';

import 'package:moyasar/moyasar.dart';
import 'package:moyasar/src/moyasar.dart';
import 'package:moyasar/src/models/payment_request.dart';
import 'package:moyasar/src/models/sources/apple_pay/apple_pay_request_source.dart';

/// The widget that shows the Apple Pay button.
class ApplePay extends StatefulWidget {
  const ApplePay(
      {super.key, required this.config, required this.onPaymentResult});

  final PaymentConfig config;
  final Function onPaymentResult;

  @override
  State<ApplePay> createState() => _ApplePayState();
}

class _ApplePayState extends State<ApplePay> {
  String _merchantName = "";

  @override
  initState() {
    super.initState();
    setMerchantName();
  }

  void setMerchantName() async {
    String merchantName = await ApplePayUtils.getMerchantName();
    setState(() {
      _merchantName = merchantName;
    });
  }

  void onApplePayError(error) {
    widget.onPaymentResult(PaymentCanceledError());
  }

  void onApplePayResult(paymentResult) async {
    final token = paymentResult['token'];
    final source = ApplePayPaymentRequestSource(token);
    final paymentRequest = PaymentRequest(widget.config, source);

    final result = await Moyasar.pay(
        apiKey: widget.config.publishableApiKey,
        paymentRequest: paymentRequest);

    widget.onPaymentResult(result);
  }

  @override
  Widget build(BuildContext context) {
    return ApplePayButton(
      paymentConfigurationAsset: 'default_payment_profile_apple_pay.json',
      paymentItems: [
        PaymentItem(
          label: _merchantName,
          amount: (widget.config.amount / 100).toStringAsFixed(2),
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
