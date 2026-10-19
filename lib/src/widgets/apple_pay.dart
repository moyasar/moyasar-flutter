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

  final bool _isRunningOnIos =
      !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;
  int _availabilityCheck = 0;
  static int _nextCallbackId = 0;
  late final MethodChannel _callbackChannel =
      MethodChannel('${widget.channel.name}/callbacks/${_nextCallbackId++}');

  PaymentRequest? _paymentRequest;
  String? _apiKey;
  Function? _paymentCallback;
  String? _activeNativeConfig;
  bool _submitted = false;
  bool _disposed = false;
  dynamic _pendingResult;

  @override
  void initState() {
    super.initState();

    // Apple Pay only exists on iOS. Bail out before touching the channel so the
    // widget is inert on other platforms instead of relying on the host app to
    // wrap it in a platform check.
    if (!_isRunningOnIos) {
      return;
    }

    _callbackChannel.setMethodCallHandler(_handleNativeCall);
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
    if (!listEquals(
        oldWidget.config.supportedNetworks, widget.config.supportedNetworks)) {
      _refreshAvailability();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    if (_isRunningOnIos) {
      WidgetsBinding.instance.removeObserver(this);
      // An authorized payment can outlive its widget. Keep its own listener
      // until the native session finishes, without affecting other buttons.
      if (_paymentRequest == null) {
        _callbackChannel.setMethodCallHandler(null);
      }
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
    final check = ++_availabilityCheck;
    ApplePayAvailability availability;

    try {
      final name =
          await widget.channel.invokeMethod<String>("getApplePayAvailability", {
        "supportedNetworks":
            widget.config.supportedNetworks.map((e) => e.toJson()).toList()
      });

      availability = ApplePayAvailability.fromName(name) ??
          ApplePayAvailability.notSupported;
    } catch (error) {
      debugPrint("Apple Pay availability check failed: $error");
      availability = ApplePayAvailability.notSupported;
    }

    if (!mounted ||
        check != _availabilityCheck ||
        availability == _availability) {
      return;
    }

    setState(() {
      _availability = availability;
    });
  }

  Future<dynamic> _handleNativeCall(MethodCall call) async {
    if (call.method == 'onApplePayStarted') {
      if (_disposed || _paymentRequest != null) return false;

      // Reject a tap from a native view that Flutter is replacing. Otherwise
      // the sheet could authorize an old total while we submit the new total.
      final nativeConfig = createCustomNativeConfig();
      if (call.arguments != nativeConfig) return false;

      final config = widget.config;
      // Moyasar currently documents multi-currency for card payments. Keep
      // Apple Pay in SAR so the sheet and charge cannot disagree or imply a
      // currency conversion the SDK does not perform.
      if (config.currency != 'SAR') {
        widget.onPaymentResult(UnspecifiedError(
            'Apple Pay currently supports SAR only. No payment was submitted.'));
        return false;
      }
      final request = PaymentRequest(
        config,
        ApplePayPaymentRequestSource(
            '', config.applePay!.manual, config.applePay!.saveCard),
      );
      try {
        // PaymentConfig is mutable, including nested metadata and the splits
        // list. Freeze those values before authorization starts as well.
        request.metadata = config.metadata == null
            ? null
            : Map<String, dynamic>.from(
                jsonDecode(jsonEncode(config.metadata)));
        request.splits = config.splits == null ? null : List.of(config.splits!);
      } catch (_) {
        widget.onPaymentResult(UnspecifiedError(
            'Invalid Apple Pay payment metadata. No payment was submitted.'));
        return false;
      }
      _paymentRequest = request;
      _apiKey = config.publishableApiKey;
      _paymentCallback = widget.onPaymentResult;
      _activeNativeConfig = nativeConfig;
      setState(() {});
      return true;
    } else if (call.method == 'onApplePayResult') {
      return _processToken(call.arguments);
    } else if (call.method == 'onApplePayFinished') {
      if (_pendingResult != null) _finishPayment(_pendingResult);
    } else if (call.method == 'onApplePayError') {
      // Closing the sheet after token submission cannot undo processing and
      // must not turn an in-flight charge into a reported cancellation.
      if (!_submitted) {
        final error = call.arguments is String
            ? UnspecifiedError(call.arguments as String)
            : PaymentCanceledError();
        if (_paymentCallback != null) {
          _finishPayment(error);
        } else if (!_disposed && call.arguments is String) {
          // Native request validation can fail before a session is started.
          widget.onPaymentResult(error);
        }
      }
    }

    return null;
  }

  Future<bool> _processToken(dynamic arguments) async {
    final request = _paymentRequest;
    if (request == null || _submitted) return false;
    _submitted = true;

    final token = arguments is Map ? arguments['token'] : null;
    if (token is! String || token.trim().isEmpty) {
      _pendingResult = UnprocessableTokenError();
      return false;
    }

    (request.source as ApplePayPaymentRequestSource).token = token;
    try {
      _pendingResult =
          await Moyasar.pay(apiKey: _apiKey!, paymentRequest: request);
      final result = _pendingResult;
      if (result is PaymentResponse &&
          (result.amount != request.amount ||
              result.currency != request.currency)) {
        _pendingResult = UnspecifiedError(
            'Payment ${result.id} does not match the requested amount or currency. Verify it on your server before retrying.');
      }
    } catch (_) {
      // Parsing failures must also settle the native authorization callback.
      // Do not expose a response body or token in an exception message.
      _pendingResult = UnspecifiedError(
          'Could not process the Apple Pay response. Verify the payment status before retrying.');
    }

    final result = _pendingResult;
    return result is PaymentResponse &&
        (result.status == PaymentStatus.paid ||
            result.status == PaymentStatus.authorized ||
            result.status == PaymentStatus.captured);
  }

  void _finishPayment(dynamic result) {
    final callback = _paymentCallback;
    if (callback == null) return;

    _paymentRequest = null;
    _paymentCallback = null;
    _apiKey = null;
    _activeNativeConfig = null;
    _pendingResult = null;
    _submitted = false;
    if (_disposed) {
      _callbackChannel.setMethodCallHandler(null);
    } else {
      setState(() {});
    }

    // Deliver exactly once, after dismissal, to the callback that started the
    // payment even if the parent rebuilt or removed the checkout meanwhile.
    callback(result);
  }

  String createCustomNativeConfig() {
    return jsonEncode({
      "merchantIdentifier": "${widget.config.applePay?.merchantId}",
      "paymentLabel": "${widget.config.applePay?.label}",
      "merchantCapabilities": widget.config.applePay?.merchantCapabilities,
      "supportedCountries": widget.config.applePay?.supportedCountries,
      "supportedNetworks":
          widget.config.supportedNetworks.map((e) => e.toJson()).toList(),
      "countryCode": "SA",
      "currencyCode": "SAR",
      "paymentAmount":
          _formatAmount(widget.config.amount, widget.config.currency),
      "buttonType": widget.buttonType.name,
      "buttonStyle": widget.buttonStyle.name,
      "callbackChannel": _callbackChannel.name,
    });
  }

  /// Convert ISO 4217 minor units without floating-point rounding. Most
  /// currencies use two digits; these are the zero, three and four digit ones.
  static String _formatAmount(int amount, String currency) {
    const zeroDigits = {
      'BIF',
      'CLP',
      'DJF',
      'GNF',
      'ISK',
      'JPY',
      'KMF',
      'KRW',
      'PYG',
      'RWF',
      'UGX',
      'UYI',
      'VND',
      'VUV',
      'XAF',
      'XOF',
      'XPF',
    };
    const threeDigits = {'BHD', 'IQD', 'JOD', 'KWD', 'LYD', 'OMR', 'TND'};
    final digits = zeroDigits.contains(currency)
        ? 0
        : threeDigits.contains(currency)
            ? 3
            : (currency == 'CLF' || currency == 'UYW')
                ? 4
                : 2;
    if (digits == 0) return amount.toString();
    final value = amount.abs().toString().padLeft(digits + 1, '0');
    final split = value.length - digits;
    return '${amount < 0 ? '-' : ''}${value.substring(0, split)}.${value.substring(split)}';
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

    final nativeConfig = _activeNativeConfig ?? createCustomNativeConfig();

    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(
        width: MediaQuery.of(context).size.width,
        height: 40,
      ),
      child: IgnorePointer(
        ignoring: _paymentRequest != null,
        child: Stack(
          fit: StackFit.expand,
          children: [
            UiKitView(
              // A native view reads `creationParams` once, when it is created, and
              // Flutter only recreates it when the key changes. Keying on the config
              // itself means any change the native side depends on — the amount above
              // all — produces a fresh view instead of a button holding stale data.
              key: ValueKey('${availability.name}|$nativeConfig'),
              viewType: _applePayButtonViewNativeId,
              creationParamsCodec: const StandardMessageCodec(),
              creationParams: nativeConfig,
            ),
            if (_paymentRequest != null)
              const ColoredBox(
                color: Color(0xCCFFFFFF),
                child: Center(
                  child: SizedBox.square(
                    dimension: 22,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
