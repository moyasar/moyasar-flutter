/// Required configuration to setup Apple Pay.
class ApplePayConfig {
  /// The merchant id configured in the Moyasar Dashboard and xCode.
  String merchantId;

  /// The store name to be displayed in the Apple Pay payment session.
  String label;

  /// An option to enable the manual auth and capture.
  bool manual;

  /// An option to save (tokenize) the card for later charging.
  bool saveCard;

  /// Payment capabilities that the merchant supports.
  List<String> merchantCapabilities;

  /// ISO 3166 country codes restricting the countries where cards were issued.
  /// Defaults to an empty list, allowing cards issued in any country.
  /// Set a non-empty list, such as ['SA'], to restrict card-issuing countries.
  List<String> supportedCountries;

  ApplePayConfig(
      {required this.merchantId,
      required this.label,
      required this.manual,
      required this.saveCard,
      this.merchantCapabilities = const ["3DS", "debit", "credit"],
      this.supportedCountries = const []})
      : assert(merchantCapabilities.contains("3DS"),
            "Merchant capabilities must contain 3DS.");
}
