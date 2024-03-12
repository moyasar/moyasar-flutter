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
  final String applePayButtonViewNativeId =
      "flutter.moyasar.com/apple_pay/button";

  @override
  void initState() {
    widget.channel.invokeMethod<bool>("isApplePayAvailable", {
      "supportedNetworks": widget.config.supportedNetworks
    }).then((isApplePayAvailableCheckFlag) {
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

  void onApplePayError() {
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

  String createCustomNativeConfig() {
    return jsonEncode({
      "merchantIdentifier": "${widget.config.applePay?.merchantId}",
      "paymentLabel": "${widget.config.applePay?.label}",
      "merchantCapabilities": widget.config.applePay?.merchantCapabilities,
      "supportedNetworks": widget.config.supportedNetworks,
      "countryCode": "SA",
      "currencyCode": "SAR",
      "paymentAmount": (widget.config.amount / 100).toStringAsFixed(2)
    });
  }

  @override
  Widget build(BuildContext context) {
    // For now, We will only use the native Apple Pay button when we are sure the user can't use Apple Pay.
    // TODO: Should only use the native widget later on when it's more stable.
    return isApplePayAvailable
        ? ApplePayButton(
            paymentConfiguration:
                PaymentConfiguration.fromJsonString(createConfigString()),
            paymentItems: [
              PaymentItem(
                label: widget.config.applePay?.label,
                amount: (widget.config.amount / 100).toStringAsFixed(2),
              )
            ],
            type: widget.buttonType,
            style: widget.buttonStyle,
            onPaymentResult: onApplePayResult,
            width: MediaQuery.of(context).size.width,
            height: 40,
            onError: (_) {
              onApplePayError();
            },
            loadingIndicator: const Center(
              child: CircularProgressIndicator(),
            ),
          )
        : ConstrainedBox(
            constraints: BoxConstraints.tightFor(
              width: MediaQuery.of(context).size.width,
              height: 40,
            ),
            child: UiKitView(
              viewType: applePayButtonViewNativeId,
              creationParamsCodec: const StandardMessageCodec(),
              creationParams: createCustomNativeConfig(),
              onPlatformViewCreated: (_) {
                widget.channel.setMethodCallHandler((call) async {
                  if (call.method == 'onApplePayResult') {
                    onApplePayResult(call.arguments);
                  } else if (call.method == 'onApplePayError') {
                    onApplePayError();
                  }
                });
              },
            ),
          );
  }
}
