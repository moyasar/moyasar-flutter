import 'package:moyasar/src/models/apple_pay_config.dart';
import 'package:moyasar/src/models/credit_card_config.dart';
import 'package:moyasar/src/models/payment_split.dart';
import 'package:moyasar/src/models/samsung_pay_config.dart';

/// Supported Networks: [PaymentNetwork.amex, PaymentNetwork.visa, PaymentNetwork.mada, PaymentNetwork.masterCard]
enum PaymentNetwork {
  amex,
  visa,
  mada,
  masterCard;

  String toJson() {
    switch (this) {
      case PaymentNetwork.amex:
        return 'amex';
      case PaymentNetwork.visa:
        return 'visa';
      case PaymentNetwork.mada:
        return 'mada';
      case PaymentNetwork.masterCard:
        return 'masterCard';
    }
  }
}

/// Used by Moyasar API along with any of the supported sources.
class PaymentConfig {
  /// Used internally to manage the 3DS step.
  static String callbackUrl = "https://example.com/thanks";

  /// You can find your [publishableApiKey] in your Moyasar Dashboard.
  /// Go to https://docs.moyasar.com/get-your-api-keys for more details.
  late String publishableApiKey;

  /// The smallest currency unit.
  /// For example, to charge `SAR 257.58` you will have the [amount] as `25758`.
  /// In other words, 10 SAR = 10 * 100 Halalas.
  late int amount;

  /// Must be in ISO 3166-1 alpha-3 country code format.
  /// The default value is "SAR".
  String currency;

  /// Can be any string you want to tag the payment.
  /// For example `Payment for Order #34321`
  String description;

  /// The [metadata] adds searchable key/value pairs to the payment.
  /// For example `{"size": "xl"}`
  Map<String, dynamic>? metadata;

  /// Optional configuration used to set accepted card networks.
  /// Supported Networks: [PaymentNetwork.amex, PaymentNetwork.visa, PaymentNetwork.mada, PaymentNetwork.masterCard]
  List<PaymentNetwork> supportedNetworks;

  /// The config required to setup Apple Pay.
  ApplePayConfig? applePay;

  /// The config required to setup Samsung Pay (Android only).
  SamsungPayConfig? samsungPay;

  /// Merchant country code for Samsung Pay (e.g. "SA", "US"). Default "SA".
  String merchantCountryCode;

  /// The config required to extend the Credit Card payment feature.
  CreditCardConfig? creditCard;

  /// given_id It is going be the ID of the created payment.
  String? givenID;

  /// Optional payment splits for dividing payment amount among recipients.
  /// Only available for aggregation clients. Splitting on non-aggregated payments will be ignored.
  /// Contact your account manager to enable this feature.
  List<PaymentSplit>? splits;

  /// Optional base URL for the API endpoint.
  /// Default is 'https://api.moyasar.com/v1/payments'.
  /// For staging, use 'https://apimig.moyasar.com/v1/payments'.
  String? baseUrl;

  PaymentConfig(
      {required this.publishableApiKey,
      required this.amount,
      this.currency = 'SAR',
      required this.description,
      this.metadata,
      List<PaymentNetwork>? supportedNetworks,
      this.applePay,
      this.samsungPay,
      this.merchantCountryCode = 'SA',
      this.creditCard,
      this.givenID,
      this.splits,
      this.baseUrl})
      : supportedNetworks = (supportedNetworks ?? const [
          PaymentNetwork.visa,
          PaymentNetwork.mada,
          PaymentNetwork.masterCard
        ]).toSet().toList(),
        assert(publishableApiKey.isNotEmpty,
            'Please fill `publishableApiKey` argument with your key.'),
        assert(amount > 0, 'Please add a positive amount.'),
        assert(description.isNotEmpty, 'Please add a description.'),
        assert((supportedNetworks ?? const [
          PaymentNetwork.amex,
          PaymentNetwork.visa,
          PaymentNetwork.mada,
          PaymentNetwork.masterCard
        ]).toSet().isNotEmpty,
            'At least 1 network must be supported.');
}
