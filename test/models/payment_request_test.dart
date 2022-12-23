import 'package:flutter_test/flutter_test.dart';
import 'package:moyasar/moyasar.dart';
import 'package:moyasar/src/models/card_form_model.dart';
import 'package:moyasar/src/models/payment_request.dart';
import 'package:moyasar/src/models/payment_type.dart';
import 'package:moyasar/src/models/sources/apple_pay/apple_pay_request_source.dart';
import 'package:moyasar/src/models/sources/card/card_company.dart';
import 'package:moyasar/src/models/sources/card/card_request_source.dart';

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

    CardPaymentRequestSource cprs = CardPaymentRequestSource(creditCardData);

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
  });

  test('should create a valid payment request with Apple Pay.', () {
    Map<String, String> metadata = {"size": "xl"};

    PaymentConfig config = PaymentConfig(
        publishableApiKey: "api_key",
        amount: 123,
        description: "Coffee!",
        metadata: metadata);

    ApplePayPaymentRequestSource apprs =
        ApplePayPaymentRequestSource("toktoken");

    PaymentRequest pr = PaymentRequest(config, apprs);

    expect(pr.amount, 123);
    expect(pr.callbackUrl, "https://example.com/thanks");
    expect(pr.currency, "SAR");
    expect(pr.description, "Coffee!");
    expect(pr.metadata, metadata);

    expect(
        (pr.source as ApplePayPaymentRequestSource).type, PaymentType.applepay);
    expect((pr.source as ApplePayPaymentRequestSource).token, "toktoken");
  });
}
