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

  /// A list of ISO 3166 country codes to limit payments to cards from set countries.
  /// Only Saudi Arabia is enabled by default to prevent fraudulent transactions.
  /// You may enable more countries at your own risk.
  List<String> supportedCountries;

  ApplePayConfig(
      {required this.merchantId,
      required this.label,
      required this.manual,
      this.merchantCapabilities = const ["3DS", "debit", "credit"],
      this.supportedCountries = const ["SA"]})
      : assert(merchantCapabilities.contains("3DS"),
            "Merchant capabilities must contain 3DS.");
}
