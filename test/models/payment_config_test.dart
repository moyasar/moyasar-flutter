import 'package:flutter_test/flutter_test.dart';
import 'package:moyasar/moyasar.dart';

void main() {
  test('should create a valid payment config with only required fields.', () {
    PaymentConfig paymentConfig =
        PaymentConfig(publishableApiKey: "api_key", amount: 123);

    expect(paymentConfig.publishableApiKey, "api_key");
    expect(paymentConfig.amount, 123);
    expect(paymentConfig.currency, "SAR");
    expect(paymentConfig.description, null);
    expect(paymentConfig.metadata, null);
    expect(paymentConfig.callbackUrl, "https://example.com/thanks");
  });

  test('should create a valid payment config with all fields.', () {
    const meta = {"size": "2xl"};

    PaymentConfig paymentConfig = PaymentConfig(
        publishableApiKey: "api_key",
        amount: 123,
        currency: "USD",
        description: "Coffee!",
        metadata: meta);

    expect(paymentConfig.publishableApiKey, "api_key");
    expect(paymentConfig.amount, 123);
    expect(paymentConfig.currency, "USD");
    expect(paymentConfig.description, "Coffee!");
    expect(paymentConfig.metadata, meta);
    expect(paymentConfig.callbackUrl, "https://example.com/thanks");
  });

  test(
      'should throw assertion error if required fields are not filled as expected.',
      () {
    // Invalid API key.
    expect(() => PaymentConfig(publishableApiKey: "", amount: 100),
        throwsAssertionError);

    // Invalid amount.
    expect(() => PaymentConfig(publishableApiKey: "key", amount: 0),
        throwsAssertionError);
  });
}
