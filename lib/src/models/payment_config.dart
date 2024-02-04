import 'package:moyasar/src/models/apple_pay_config.dart';
import 'package:moyasar/src/models/credit_card_config.dart';

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
  Map<String, String>? metadata;

  /// Optional configuration used to set accepted card networks.
  /// Supported Networks: ["amex", "visa", "mada", "masterCard"]
  List<String> supportedNetworks;

  /// The config required to setup Apple Pay.
  ApplePayConfig? applePay;

  /// The config required to extend the Credit Card payment feature.
  CreditCardConfig? creditCard;

  PaymentConfig(
      {required this.publishableApiKey,
      required this.amount,
      this.currency = 'SAR',
      required this.description,
      this.metadata,
      this.supportedNetworks = const ["amex", "visa", "mada", "masterCard"],
      this.applePay,
      this.creditCard})
      : assert(publishableApiKey.isNotEmpty,
            'Please fill `publishableApiKey` argument with your key.'),
        assert(amount > 0, 'Please add a positive amount.'),
        assert(description.isNotEmpty, 'Please add a description.'),
        assert(supportedNetworks.isNotEmpty,
            'At least 1 network must be supported.');
}
