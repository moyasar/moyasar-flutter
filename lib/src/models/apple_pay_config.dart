/// Required configuration to setup Apple Pay.
class ApplePayConfig {
  /// The merchant id configured in the Moyasar Dashboard and xCode.
  String merchantId;

  /// The store name to be displayed in the Apple Pay payment session.
  String label;

  /// An option to enable the manual auth and capture
  bool manual;

  ApplePayConfig(
      {required this.merchantId, required this.label, required this.manual});
}
