import 'package:flutter_test/flutter_test.dart';
import 'package:moyasar/moyasar.dart';

void main() {
  test('should create a valid payment config with only required fields.', () {
    PaymentConfig paymentConfig = PaymentConfig(
        publishableApiKey: "api_key", amount: 123, description: "Coffee");

    expect(paymentConfig.publishableApiKey, "api_key");
    expect(paymentConfig.amount, 123);
    expect(paymentConfig.currency, "SAR");
    expect(paymentConfig.description, "Coffee");
    expect(paymentConfig.metadata, null);
    expect(paymentConfig.supportedNetworks,
        ["amex", "visa", "mada", "masterCard"]);
    expect(PaymentConfig.callbackUrl, "https://example.com/thanks");
  });

  test('should create a valid payment config with all fields.', () {
    const meta = {"size": "2xl"};

    PaymentConfig paymentConfig = PaymentConfig(
        publishableApiKey: "api_key",
        amount: 123,
        currency: "USD",
        description: "Coffee!",
        metadata: meta,
        supportedNetworks: ["mada"],
        creditCard: CreditCardConfig(saveCard: false, manual: false),
        applePay: ApplePayConfig(
            label: "Blue Coffee",
            merchantId: "merchant.mysr.fghurayri",
            manual: false,
            merchantCapabilities: ["3DS"]));

    expect(paymentConfig.publishableApiKey, "api_key");
    expect(paymentConfig.amount, 123);
    expect(paymentConfig.currency, "USD");
    expect(paymentConfig.description, "Coffee!");
    expect(paymentConfig.metadata, meta);
    expect(paymentConfig.supportedNetworks, ["mada"]);
    expect(PaymentConfig.callbackUrl, "https://example.com/thanks");

    expect(paymentConfig.creditCard!.saveCard, false);
    expect(paymentConfig.creditCard!.manual, false);

    expect(paymentConfig.applePay!.label, "Blue Coffee");
    expect(paymentConfig.applePay!.merchantId, "merchant.mysr.fghurayri");
    expect(paymentConfig.applePay!.manual, false);
    expect(paymentConfig.applePay!.merchantCapabilities, ["3DS"]);
  });

  test(
      'should throw assertion error if required fields are not filled as expected.',
      () {
    // Invalid API key.
    expect(
        () => PaymentConfig(
            publishableApiKey: "", amount: 100, description: "Coffee"),
        throwsAssertionError);

    // Invalid amount.
    expect(
        () => PaymentConfig(
            publishableApiKey: "key", amount: 0, description: "Coffee"),
        throwsAssertionError);

    // Invalid description.
    expect(
        () =>
            PaymentConfig(publishableApiKey: "key", amount: 0, description: ""),
        throwsAssertionError);
  });
}
