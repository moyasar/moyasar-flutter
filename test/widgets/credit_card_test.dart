import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moyasar/moyasar.dart';

Widget createTestableApp(Localization? locale) {
  final paymentConfig = PaymentConfig(
      publishableApiKey: "api_key", amount: 123, description: "Coffee");

  void onPaymentResult() {}

  return MaterialApp(
      home: Scaffold(
          body: locale == null
              ? CreditCard(
                  config: paymentConfig, onPaymentResult: onPaymentResult)
              : CreditCard(
                  locale: locale,
                  config: paymentConfig,
                  onPaymentResult: onPaymentResult)));
}

void main() {
  group('credit card', () {
    testWidgets('should require all fields', (tester) async {
      const locale = Localization.en();

      await tester.pumpWidget(createTestableApp(null));

      const payButtonText = "Pay SAR 1.23";

      Finder payButton = find.text(payButtonText);
      expect(payButton, findsOneWidget);

      await tester.tap(payButton);
      await tester.pumpAndSettle();

      expect(find.text(locale.nameRequired), findsOneWidget);
      expect(find.text(locale.cardNumberRequired), findsOneWidget);
      expect(find.text(locale.expiryRequired), findsOneWidget);
      expect(find.text(locale.cvcRequired), findsOneWidget);

      Finder nameField = find.widgetWithText(TextFormField, locale.nameOnCard);
      Finder cardNumberField =
          find.widgetWithText(TextFormField, locale.cardNumber);
      Finder expiryField =
          find.widgetWithText(TextFormField, "${locale.expiry} (MM / YY)");
      Finder cvcField = find.widgetWithText(TextFormField, locale.cvc);

      await tester.enterText(nameField, "Faisal Alghurayri");
      await tester.enterText(cardNumberField, "4111111111111111");
      await tester.enterText(expiryField, "12/30");
      await tester.enterText(cvcField, "123");

      await tester.pumpAndSettle();

      expect(find.text(locale.nameRequired), findsNothing);
      expect(find.text(locale.cardNumberRequired), findsNothing);
      expect(find.text(locale.expiryRequired), findsNothing);
      expect(find.text(locale.cvcRequired), findsNothing);
    });
  });
}
