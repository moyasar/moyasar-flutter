/// Required configuration to setup Apple Pay.
class ApplePayConfig {
  /// The merchant id configured in the Moyasar Dashboard and xCode.
  String merchantId;

  /// The store name to be displayed in the Apple Pay payment session.
  String label;

  /// An option to enable the manual auth and capture.
  bool manual;

  /// Payment capabilities that the merchant supports.
  List<String> merchantCapabilities;

  ApplePayConfig(
      {required this.merchantId,
      required this.label,
      required this.manual,
      this.merchantCapabilities = const ["3DS", "debit", "credit"]})
      : assert(merchantCapabilities.contains("3DS"),
            "Merchant capabilities must contain 3DS.");
}
