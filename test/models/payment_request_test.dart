import 'package:flutter_test/flutter_test.dart';
import 'package:moyasar/moyasar.dart';
import 'package:moyasar/src/models/payment_type.dart';

void main() {
  test('should create a valid payment request with CC.', () {
    Map<String, dynamic> metadata = {"size": "xl", "code": 255};

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
    Map<String, dynamic> metadata = {"size": "xl", "code": 255};

    PaymentConfig config = PaymentConfig(
        publishableApiKey: "api_key",
        amount: 123,
        description: "Coffee!",
        metadata: metadata);

    ApplePayPaymentRequestSource apprs =
        ApplePayPaymentRequestSource("toktoken", false, false);

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
    expect((pr.source as ApplePayPaymentRequestSource).saveCard, 'false');
  });

  test('should create a valid manual payment request with Apple Pay.', () {
    Map<String, dynamic> metadata = {"size": "xl", "code": 255};

    PaymentConfig config = PaymentConfig(
        publishableApiKey: "api_key",
        amount: 123,
        description: "Coffee!",
        metadata: metadata);

    ApplePayPaymentRequestSource apprs =
        ApplePayPaymentRequestSource("toktoken", true, false);

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
    expect((pr.source as ApplePayPaymentRequestSource).saveCard, 'false');
  });

  test('should create a payment request with Apple Pay with save card.', () {
    Map<String, dynamic> metadata = {"size": "xl", "code": 255};

    PaymentConfig config = PaymentConfig(
        publishableApiKey: "api_key",
        amount: 123,
        description: "Coffee!",
        metadata: metadata);

    ApplePayPaymentRequestSource apprs =
        ApplePayPaymentRequestSource("toktoken", true, true);

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
    expect((pr.source as ApplePayPaymentRequestSource).saveCard, 'true');
  });

  group('CardTokenPaymentRequestSource', () {
    test('includes all fields when provided', () {
      final source = CardTokenPaymentRequestSource(
        token: 'token_123456789',
        cvc: '123',
        statementDescriptor: 'Test Payment',
        threeDS: true,
        manual: true,
      );

      expect(source.toJson(), {
        'type': 'token',
        'token': 'token_123456789',
        'cvc': '123',
        'statement_descriptor': 'Test Payment',
        '3ds': true,
        'manual': true,
      });
    });

    test('includes only required fields when optional ones are omitted', () {
      final source = CardTokenPaymentRequestSource(token: 'token_abc');

      expect(source.toJson(), {
        'type': 'token',
        'token': 'token_abc',
      });
    });

    test('throws if token does not start with "token_"', () {
      expect(
        () => CardTokenPaymentRequestSource(token: 'invalid_token'),
        throwsA(isA<AssertionError>()),
      );
    });

    test('throws if CVC is invalid (less than 3 digits)', () {
      expect(
        () => CardTokenPaymentRequestSource(token: 'token_abc', cvc: '12'),
        throwsA(isA<AssertionError>()),
      );
    });

    test('throws if statement descriptor exceeds 255 characters', () {
      final longDesc = 'A' * 256;

      expect(
        () => CardTokenPaymentRequestSource(
            token: 'token_abc', statementDescriptor: longDesc),
        throwsA(isA<AssertionError>()),
      );
    });
  });
}
