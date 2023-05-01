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
        applePay: ApplePayConfig(
            label: "Blue Coffee", merchantId: "merchant.mysr.fghurayri"));

    expect(paymentConfig.publishableApiKey, "api_key");
    expect(paymentConfig.amount, 123);
    expect(paymentConfig.currency, "USD");
    expect(paymentConfig.description, "Coffee!");
    expect(paymentConfig.metadata, meta);
    expect(PaymentConfig.callbackUrl, "https://example.com/thanks");

    expect(paymentConfig.applePay!.label, "Blue Coffee");
    expect(paymentConfig.applePay!.merchantId, "merchant.mysr.fghurayri");
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
