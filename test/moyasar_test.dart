import 'package:flutter_test/flutter_test.dart';
import 'package:moyasar/moyasar.dart';

void main() {
  test('should perform credit card payment successfully without tokenizing.',
      () async {
    Map<String, String> metadata = {"size": "xl"};
    PaymentConfig config = PaymentConfig(
        publishableApiKey: "pk_test_r6eZg85QyduWZ7PNTHT56BFvZpxJgNJ2PqPMDoXA",
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
        tokenizeCard: false,
        manualPayment: false);

    PaymentRequest pr = PaymentRequest(config, cprs);

    var res =
        await Moyasar.pay(apiKey: config.publishableApiKey, paymentRequest: pr);

    expect(res.status, PaymentStatus.initiated);
    expect((res.source as CardPaymentResponseSource).transactionUrl,
        startsWith("https"));
    expect((res.source as CardPaymentResponseSource).token, null);
  });

  test('should perform credit card payment successfully with tokenizing.',
      () async {
    Map<String, String> metadata = {"size": "xl"};
    PaymentConfig config = PaymentConfig(
        publishableApiKey: "pk_test_r6eZg85QyduWZ7PNTHT56BFvZpxJgNJ2PqPMDoXA",
        amount: 123,
        description: "Coffee!",
        metadata: metadata,
        creditCard: CreditCardConfig(
          saveCard: true,
          manual: false,
        ));

    CardFormModel creditCardData = CardFormModel(
        name: "Faisal",
        number: "4111111111111111",
        month: "12",
        year: "2030",
        cvc: "123");

    CardPaymentRequestSource cprs = CardPaymentRequestSource(
        creditCardData: creditCardData,
        tokenizeCard: config.creditCard!.saveCard,
        manualPayment: config.creditCard!.manual);

    PaymentRequest pr = PaymentRequest(config, cprs);

    var res =
        await Moyasar.pay(apiKey: config.publishableApiKey, paymentRequest: pr);

    expect(res.status, PaymentStatus.initiated);
    expect((res.source as CardPaymentResponseSource).transactionUrl,
        startsWith("https"));
    expect(
        (res.source as CardPaymentResponseSource).token, startsWith("token_"));
  });

  test('should perform credit card authorization successfully.', () async {
    Map<String, String> metadata = {"size": "xl"};
    PaymentConfig config = PaymentConfig(
      publishableApiKey: "pk_test_r6eZg85QyduWZ7PNTHT56BFvZpxJgNJ2PqPMDoXA",
      amount: 123,
      description: "Coffee!",
      metadata: metadata,
      creditCard: CreditCardConfig(saveCard: false, manual: true),
    );

    CardFormModel creditCardData = CardFormModel(
        name: "Faisal",
        number: "4111111111111111",
        month: "12",
        year: "2030",
        cvc: "123");

    CardPaymentRequestSource cprs = CardPaymentRequestSource(
        creditCardData: creditCardData,
        tokenizeCard: config.creditCard!.saveCard,
        manualPayment: config.creditCard!.manual);

    PaymentRequest pr = PaymentRequest(config, cprs);

    var res =
        await Moyasar.pay(apiKey: config.publishableApiKey, paymentRequest: pr);

    expect(res.status, PaymentStatus.initiated);
    expect((res.source as CardPaymentResponseSource).transactionUrl,
        startsWith("https"));
  });
}
