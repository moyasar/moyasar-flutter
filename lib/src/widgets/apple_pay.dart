import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pay/pay.dart';
import 'package:moyasar/moyasar.dart';
import 'dart:convert';

/// The widget that shows the Apple Pay button.
class ApplePay extends StatefulWidget {
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
  final MethodChannel channel =
      const MethodChannel('flutter.moyasar.com/apple_pay');

  @override
  State<ApplePay> createState() => _ApplePayState();
}

class _ApplePayState extends State<ApplePay> {
  bool isApplePayAvailable = true;

  @override
  void initState() {
    widget.channel.invokeMethod<bool>("isApplePayAvailable", {
      "supportedNetworks": widget.config.supportedNetworks
    }).then((isApplePayAvailableCheckFlag) {
      // We will only display the 'Setup Apple Pay' button when we are sure the user can't use Apple Pay.
      if (isApplePayAvailableCheckFlag != null &&
          !isApplePayAvailableCheckFlag) {
        // Done like this to not cause a useless rebuild.
        setState(() {
          isApplePayAvailable = isApplePayAvailableCheckFlag;
        });
      }
    }).catchError(
      (error) {
        debugPrint("Apple Pay availability check failed: $error");
      },
    );

    super.initState();
  }

  void onApplePayError(error) {
    widget.onPaymentResult(PaymentCanceledError());
  }

  void onApplePayResult(paymentResult) async {
    final token = paymentResult['token'];

    if (((token ?? '') == '')) {
      widget.onPaymentResult(UnprocessableTokenError());
      return;
    }

    final source =
        ApplePayPaymentRequestSource(token, widget.config.applePay!.manual);
    final paymentRequest = PaymentRequest(widget.config, source);

    final result = await Moyasar.pay(
        apiKey: widget.config.publishableApiKey,
        paymentRequest: paymentRequest);

    widget.onPaymentResult(result);
  }

  String createConfigString() {
    return '''{
        "provider": "apple_pay",
        "data": {
          "merchantIdentifier": "${widget.config.applePay?.merchantId}",
          "displayName": "${widget.config.applePay?.label}",
          "merchantCapabilities": ${jsonEncode(widget.config.applePay?.merchantCapabilities)},
          "supportedNetworks": ${jsonEncode(widget.config.supportedNetworks)},
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
          label: widget.config.applePay?.label,
          amount: (widget.config.amount / 100).toStringAsFixed(2),
        )
      ],
      type: isApplePayAvailable ? widget.buttonType : ApplePayButtonType.setUp,
      style: widget.buttonStyle,
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
