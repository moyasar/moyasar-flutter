/// Required configuration to setup Apple Pay.
class ApplePayConfig {
  /// The merchant id configured in the Moyasar Dashboard and xCode.
  String merchantId;

  /// The store name to be displayed in the Apple Pay payment session.
  String label;

  /// An option to enable the manual auth and capture
  bool manual;

  List<String> merchantCapabilities;

  List<String> supportedNetworks;

  ApplePayConfig(
      {required this.merchantId,
      required this.label,
      required this.manual,
      this.merchantCapabilities = const ["3DS", "debit", "credit"],
      this.supportedNetworks = const ["amex", "visa", "mada", "masterCard"]})
      : assert(merchantCapabilities.contains("3DS"),
            "Merchant Capabilities must contain 3DS"),
        assert(supportedNetworks.isNotEmpty,
            'at least 1 network must be supported');
}
