import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:moyasar/moyasar.dart';

void main() {
  for (final scenario in [
    {'name': 'direct payment', 'saveCard': false, 'manual': false},
    {'name': 'card tokenization', 'saveCard': true, 'manual': false},
    {'name': 'manual authorization', 'saveCard': false, 'manual': true},
  ]) {
    test('sends ${scenario['name']} and parses its 3DS response', () async {
      final saveCard = scenario['saveCard'] as bool;
      final manual = scenario['manual'] as bool;
      final config = PaymentConfig(
        publishableApiKey: 'pk_test_fixture',
        amount: 123,
        description: 'Coffee!',
        metadata: {'size': 'xl'},
      );
      final request = PaymentRequest(
        config,
        CardPaymentRequestSource(
          creditCardData: CardFormModel(
            name: 'Test Cardholder',
            number: '4111111111111111',
            month: '12',
            year: '2030',
            cvc: '123',
          ),
          tokenizeCard: saveCard,
          manualPayment: manual,
        ),
      );

      final result = await http.runWithClient(
        () => Moyasar.pay(
            apiKey: config.publishableApiKey, paymentRequest: request),
        () => MockClient((request) async {
          expect(request.method, 'POST');
          expect(request.url.toString(), 'https://api.moyasar.com/v1/payments');
          expect(request.headers['Authorization'],
              'Basic ${base64Encode(utf8.encode('pk_test_fixture'))}');
          final body = jsonDecode(request.body) as Map;
          expect(body['amount'], 123);
          expect(body['currency'], 'SAR');
          expect(body['metadata'], {'size': 'xl'});
          expect(body['source']['type'], 'creditcard');
          expect(body['source']['save_card'], saveCard.toString());
          expect(body['source']['manual'], manual.toString());

          return http.Response(
              jsonEncode({
                'id': 'fixture-payment-id',
                'status': 'initiated',
                'amount': 123,
                'fee': 0,
                'currency': 'SAR',
                'refunded': 0,
                'captured': 0,
                'amount_format': '1.23 SAR',
                'fee_format': '0.00 SAR',
                'refunded_format': '0.00 SAR',
                'captured_format': '0.00 SAR',
                'created_at': '2026-10-17T10:00:00Z',
                'updated_at': '2026-10-17T10:00:00Z',
                'source': {
                  'type': 'creditcard',
                  'company': 'visa',
                  'name': 'Test Cardholder',
                  'number': 'XXXX-XXXX-XXXX-1111',
                  'transaction_url': 'https://example.com/3ds/fixture',
                  'token': saveCard ? 'token_fixture' : null,
                },
              }),
              201);
        }),
      );

      expect(result, isA<PaymentResponse>());
      expect(result.status, PaymentStatus.initiated);
      final source = result.source as CardPaymentResponseSource;
      expect(source.transactionUrl, 'https://example.com/3ds/fixture');
      expect(source.token, saveCard ? 'token_fixture' : null);
    });
  }
}
