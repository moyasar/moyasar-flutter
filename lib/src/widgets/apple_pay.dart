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
///
/// A user with no card in Wallet still sees the normal payment button: since
/// iOS 15 they can add one from inside the payment sheet. On iOS 14 and below
/// the sheet can't do that, so the widget shows Apple's "Set Up Apple Pay"
/// button instead, which opens Wallet; it switches back to the payment button
/// once the user returns.
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

  /// The wording Apple shows on the button, e.g. "Buy with Apple Pay" for
  /// [ApplePayButtonType.buy]. Pick the one that matches the action the user
  /// is completing. Defaults to [ApplePayButtonType.inStore].
  final ApplePayButtonType buttonType;

  /// The button's color scheme. Use [ApplePayButtonStyle.automatic] to follow
  /// the system light/dark appearance. Defaults to [ApplePayButtonStyle.black].
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
  void didUpdateWidget(covariant ApplePay oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!_isRunningOnIos) {
      return;
    }

    // Readiness is decided from the accepted networks, so it has to be
    // re-checked when they change.
    if (!listEquals(oldWidget.config.supportedNetworks,
        widget.config.supportedNetworks)) {
      _refreshAvailability();
    }
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
      final arguments = call.arguments;

      // Values decoded by the standard codec arrive as `Map<Object?, Object?>`.
      // Anything else means the payload is malformed; report it rather than
      // throwing, which would leave the payment with no response at all.
      if (arguments is! Map) {
        widget.onPaymentResult(UnprocessableTokenError());
        return null;
      }

      onApplePayResult(Map<String, dynamic>.from(arguments));
    } else if (call.method == 'onApplePayError') {
      onApplePayError();
    }

    return null;
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

    final nativeConfig = createCustomNativeConfig();

    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(
        width: MediaQuery.of(context).size.width,
        height: 40,
      ),
      child: UiKitView(
        // A native view reads `creationParams` once, when it is created, and
        // Flutter only recreates it when the key changes. Keying on the config
        // itself means any change the native side depends on — the amount above
        // all — produces a fresh view instead of a button holding stale data.
        key: ValueKey('${availability.name}|$nativeConfig'),
        viewType: _applePayButtonViewNativeId,
        creationParamsCodec: const StandardMessageCodec(),
        creationParams: nativeConfig,
      ),
    );
  }
}
