import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moyasar/moyasar.dart';
import 'package:moyasar/src/models/apple_pay_availability.dart';
import 'dart:convert';

/// The widget that shows the Apple Pay button.
///
/// The button hides itself on non-iOS platforms and on devices that can't use
/// Apple Pay, so apps don't need to guard it with their own platform check.
/// When Apple Pay is supported but no accepted card has been added yet, it
/// shows Apple's "Set Up Apple Pay" button, which opens Wallet so the user can
/// add one; the button switches to the normal payment button once they return.
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

class _ApplePayState extends State<ApplePay> with WidgetsBindingObserver {
  static const String _applePayButtonViewNativeId =
      "flutter.moyasar.com/apple_pay/button";

  /// `null` while the native readiness check is still in flight.
  ApplePayAvailability? _availability;

  bool get _isRunningOnIos => defaultTargetPlatform == TargetPlatform.iOS;

  @override
  void initState() {
    super.initState();

    // Apple Pay only exists on iOS. Bail out before touching the channel so the
    // widget is inert on other platforms instead of relying on the host app to
    // wrap it in a platform check.
    if (!_isRunningOnIos) {
      return;
    }

    widget.channel.setMethodCallHandler(_handleNativeCall);
    WidgetsBinding.instance.addObserver(this);
    _refreshAvailability();
  }

  @override
  void dispose() {
    if (_isRunningOnIos) {
      WidgetsBinding.instance.removeObserver(this);
      widget.channel.setMethodCallHandler(null);
    }

    super.dispose();
  }

  /// Re-checks readiness whenever the app is foregrounded, so the button
  /// updates after the user adds a card in Wallet and comes back.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refreshAvailability();
    }
  }

  Future<void> _refreshAvailability() async {
    ApplePayAvailability availability;

    try {
      final name = await widget.channel
          .invokeMethod<String>("getApplePayAvailability", {
        "supportedNetworks":
            widget.config.supportedNetworks.map((e) => e.toJson()).toList()
      });

      // An unrecognized response shouldn't hide a button that may well work, so
      // fall back to showing the normal payment button.
      availability =
          ApplePayAvailability.fromName(name) ?? ApplePayAvailability.ready;
    } catch (error) {
      debugPrint("Apple Pay availability check failed: $error");
      availability = ApplePayAvailability.ready;
    }

    if (!mounted || availability == _availability) {
      return;
    }

    setState(() {
      _availability = availability;
    });
  }

  Future<dynamic> _handleNativeCall(MethodCall call) async {
    if (call.method == 'onApplePayResult') {
      // Values decoded by the standard codec arrive as `Map<Object?, Object?>`.
      onApplePayResult(Map<String, dynamic>.from(call.arguments as Map));
    } else if (call.method == 'onApplePayError') {
      onApplePayError();
    }
  }

  void onApplePayError() {
    widget.onPaymentResult(PaymentCanceledError());
  }

  void onApplePayResult(Map<String, dynamic> paymentResult) async {
    final token = paymentResult['token'];

    if (((token ?? '') == '')) {
      widget.onPaymentResult(UnprocessableTokenError());
      return;
    }

    final source = ApplePayPaymentRequestSource(token,
        widget.config.applePay!.manual, widget.config.applePay!.saveCard);
    final paymentRequest = PaymentRequest(widget.config, source);

    final result = await Moyasar.pay(
        apiKey: widget.config.publishableApiKey,
        paymentRequest: paymentRequest);

    widget.onPaymentResult(result);
  }

  String createCustomNativeConfig() {
    return jsonEncode({
      "merchantIdentifier": "${widget.config.applePay?.merchantId}",
      "paymentLabel": "${widget.config.applePay?.label}",
      "merchantCapabilities": widget.config.applePay?.merchantCapabilities,
      "supportedCountries": widget.config.applePay?.supportedCountries,
      "supportedNetworks": widget.config.supportedNetworks.map((e) => e.toJson()).toList(),
      "countryCode": "SA",
      "currencyCode": "SAR",
      "paymentAmount": (widget.config.amount / 100).toStringAsFixed(2),
      "buttonType": widget.buttonType.name,
      "buttonStyle": widget.buttonStyle.name,
    });
  }

  @override
  Widget build(BuildContext context) {
    final availability = _availability;

    // Render nothing off iOS, while the check is still running, and on devices
    // that can't use Apple Pay at all.
    if (!_isRunningOnIos ||
        availability == null ||
        availability == ApplePayAvailability.notSupported) {
      return const SizedBox.shrink();
    }

    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(
        width: MediaQuery.of(context).size.width,
        height: 40,
      ),
      child: UiKitView(
        // Keyed on availability so the native view is rebuilt — and the button
        // swaps between "Set Up Apple Pay" and the payment button — when
        // readiness changes.
        key: ValueKey(availability),
        viewType: _applePayButtonViewNativeId,
        creationParamsCodec: const StandardMessageCodec(),
        creationParams: createCustomNativeConfig(),
      ),
    );
  }
}
