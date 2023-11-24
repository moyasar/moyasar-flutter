import 'package:flutter_test/flutter_test.dart';
import 'package:moyasar/moyasar.dart';
import 'package:moyasar/src/models/payment_type.dart';

void main() {
  test('should create a valid payment request with CC.', () {
    Map<String, String> metadata = {"size": "xl"};

    PaymentConfig config = PaymentConfig(
        publishableApiKey: "api_key",
        amount: 123,
        description: "Coffee!",
        metadata: metadata);

    CardFormModel creditCardData = CardFormModel(
        name: "Faisal",
        number: "4111111111111111",
        month: "12",
        year: "2030",
        cvc: "123");

    CardPaymentRequestSource cprs = CardPaymentRequestSource(
        creditCardData: creditCardData,
        tokenizeCard: true,
        manualPayment: false);

    PaymentRequest pr = PaymentRequest(config, cprs);

    expect(pr.amount, 123);
    expect(pr.callbackUrl, "https://example.com/thanks");
    expect(pr.currency, "SAR");
    expect(pr.description, "Coffee!");
    expect(pr.metadata, metadata);

    expect(
        (pr.source as CardPaymentRequestSource).type, PaymentType.creditcard);
    expect((pr.source as CardPaymentRequestSource).company, CardCompany.visa);
    expect((pr.source as CardPaymentRequestSource).name, "Faisal");
    expect((pr.source as CardPaymentRequestSource).number, "4111111111111111");
    expect((pr.source as CardPaymentRequestSource).month, "12");
    expect((pr.source as CardPaymentRequestSource).year, "2030");
    expect((pr.source as CardPaymentRequestSource).cvc, "123");
    expect((pr.source as CardPaymentRequestSource).saveCard, "true");
  });

  test('should create a valid payment request with Apple Pay.', () {
    Map<String, String> metadata = {"size": "xl"};

    PaymentConfig config = PaymentConfig(
        publishableApiKey: "api_key",
        amount: 123,
        description: "Coffee!",
        metadata: metadata);

    ApplePayPaymentRequestSource apprs =
        ApplePayPaymentRequestSource("toktoken", false);

    PaymentRequest pr = PaymentRequest(config, apprs);

    expect(pr.amount, 123);
    expect(pr.callbackUrl, "https://example.com/thanks");
    expect(pr.currency, "SAR");
    expect(pr.description, "Coffee!");
    expect(pr.metadata, metadata);

    expect(
        (pr.source as ApplePayPaymentRequestSource).type, PaymentType.applepay);
    expect((pr.source as ApplePayPaymentRequestSource).token, "toktoken");
    expect((pr.source as ApplePayPaymentRequestSource).manual, 'false');
  });

  test('should create a valid manual paymentrequest with Apple Pay.', () {
    Map<String, String> metadata = {"size": "xl"};

    PaymentConfig config = PaymentConfig(
        publishableApiKey: "api_key",
        amount: 123,
        description: "Coffee!",
        metadata: metadata);

    ApplePayPaymentRequestSource apprs =
        ApplePayPaymentRequestSource("toktoken", true);

    PaymentRequest pr = PaymentRequest(config, apprs);

    expect(pr.amount, 123);
    expect(pr.callbackUrl, "https://example.com/thanks");
    expect(pr.currency, "SAR");
    expect(pr.description, "Coffee!");
    expect(pr.metadata, metadata);

    expect(
        (pr.source as ApplePayPaymentRequestSource).type, PaymentType.applepay);
    expect((pr.source as ApplePayPaymentRequestSource).token, "toktoken");
    expect((pr.source as ApplePayPaymentRequestSource).manual, 'true');
  });
}
