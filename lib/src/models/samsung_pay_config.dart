/// Required configuration to setup Samsung Pay.
///
/// Matches the React Native SDK configuration.
class SamsungPayConfig {
  /// The service ID generated in the Samsung merchant dashboard
  /// (e.g. ea810dafb758408fa530b1).
  final String serviceId;

  /// The merchant name to be displayed in the Samsung Pay payment session.
  final String merchantName;

  /// A unique identifier for the transaction:
  /// - Needed for refunds, chargebacks, and Visa card payments
  /// - Must be only alphanumeric characters and hyphens [A-Za-z0-9-]
  /// - Maximum length: 36 characters
  /// - If omitted, the SDK generates one automatically
  /// - Appears in the response metadata as 'samsungpay_order_id' upon successful payment
  final String? orderNumber;

  /// An option to enable the manual auth and capture.
  final bool manual;

  SamsungPayConfig({
    required this.serviceId,
    required this.merchantName,
    this.orderNumber,
    this.manual = false,
  });
}
