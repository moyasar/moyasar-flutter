import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moyasar/moyasar.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  const channel = MethodChannel('flutter.moyasar.com/apple_pay');

  final binding = TestWidgetsFlutterBinding.ensureInitialized();

  /// Records the calls the widget makes, and replies with [availability].
  List<MethodCall> mockNativeAvailability(String? availability) {
    final calls = <MethodCall>[];

    binding.defaultBinaryMessenger.setMockMethodCallHandler(channel,
        (call) async {
      calls.add(call);
      return availability;
    });

    return calls;
  }

  PaymentConfig buildConfig() => PaymentConfig(
        publishableApiKey: 'pk_test_key',
        amount: 123,
        description: 'Test payment',
        applePay: ApplePayConfig(
          merchantId: 'merchant.com.test',
          label: 'Test Store',
          manual: false,
          saveCard: false,
        ),
      );

  Widget buildSubject(
          {int amount = 123,
          String currency = 'SAR',
          Function? onPaymentResult}) =>
      MaterialApp(
        home: Scaffold(
          body: ApplePay(
            config: PaymentConfig(
              publishableApiKey: 'pk_test_key',
              amount: amount,
              currency: currency,
              description: 'Test payment',
              applePay: ApplePayConfig(
                merchantId: 'merchant.com.test',
                label: 'Test Store',
                manual: false,
                saveCard: false,
              ),
            ),
            onPaymentResult: onPaymentResult ?? (_) {},
          ),
        ),
      );

  /// Delivers [arguments] to the widget's handler the way the native side
  /// would, going through the real codec rather than calling the handler
  /// directly.
  Future<dynamic> sendFromNative(MethodChannel target, String method,
      [Object? arguments]) {
    final result = Completer<dynamic>();
    binding.defaultBinaryMessenger.handlePlatformMessage(
      target.name,
      target.codec.encodeMethodCall(MethodCall(method, arguments)),
      (data) {
        try {
          result.complete(
              data == null ? null : target.codec.decodeEnvelope(data));
        } catch (error, stack) {
          result.completeError(error, stack);
        }
      },
    );
    return result.future;
  }

  MethodChannel callbackChannel(WidgetTester tester, {int index = 0}) {
    final view =
        tester.widgetList<UiKitView>(find.byType(UiKitView)).elementAt(index);
    final config = jsonDecode(view.creationParams as String) as Map;
    return MethodChannel(config['callbackChannel'] as String);
  }

  String nativeConfigFor(WidgetTester tester, MethodChannel target) {
    final view = tester
        .widgetList<UiKitView>(find.byType(UiKitView))
        .singleWhere((view) =>
            (jsonDecode(view.creationParams as String)
                as Map)['callbackChannel'] ==
            target.name);
    return view.creationParams as String;
  }

  Future<dynamic> startPayment(WidgetTester tester, MethodChannel target,
          {String? config}) =>
      sendFromNative(target, 'onApplePayStarted',
          config ?? nativeConfigFor(tester, target));

  Future<void> pumpIos(WidgetTester tester, Widget subject) async {
    mockNativeAvailability('ready');
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    addTearDown(() => debugDefaultTargetPlatformOverride = null);
    await tester.pumpWidget(subject);
    await tester.pumpAndSettle();
    debugDefaultTargetPlatformOverride = null;
  }

  http.Response paymentResponse({String status = 'paid'}) => http.Response(
      jsonEncode({
        'id': 'test-payment-id',
        'status': status,
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
          'type': 'applepay',
          'number': 'XXXX-XXXX-XXXX-1234',
          'gateway_id': 'test-gateway-id',
        },
      }),
      201);

  tearDown(() {
    binding.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  /// Pumps the widget as [platform], restoring the override before the test
  /// ends — the framework asserts debug variables are unset by then.
  Future<void> pumpAs(WidgetTester tester, TargetPlatform platform) async {
    debugDefaultTargetPlatformOverride = platform;
    addTearDown(() => debugDefaultTargetPlatformOverride = null);

    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    debugDefaultTargetPlatformOverride = null;
  }

  testWidgets('renders nothing on Android without calling the native side',
      (tester) async {
    final calls = mockNativeAvailability('ready');

    await pumpAs(tester, TargetPlatform.android);

    expect(find.byType(UiKitView), findsNothing);
    expect(calls, isEmpty);
  });

  testWidgets('renders nothing when the device cannot support Apple Pay',
      (tester) async {
    mockNativeAvailability('notSupported');

    await pumpAs(tester, TargetPlatform.iOS);

    expect(find.byType(UiKitView), findsNothing);
  });

  testWidgets('asks the native side for availability on iOS', (tester) async {
    final calls = mockNativeAvailability('notSupported');

    await pumpAs(tester, TargetPlatform.iOS);

    expect(calls, hasLength(1));
    expect(calls.single.method, 'getApplePayAvailability');
    expect(
      (calls.single.arguments as Map)['supportedNetworks'],
      buildConfig().supportedNetworks.map((e) => e.toJson()).toList(),
    );
  });

  testWidgets('rebuilds the native view when the amount changes',
      (tester) async {
    // A native view reads its creationParams once, so a changed amount must
    // produce a new key — otherwise the button would charge the stale amount.
    mockNativeAvailability('ready');
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    addTearDown(() => debugDefaultTargetPlatformOverride = null);

    await tester.pumpWidget(buildSubject(amount: 10000));
    await tester.pumpAndSettle();
    final firstKey = tester.widget<UiKitView>(find.byType(UiKitView)).key;

    await tester.pumpWidget(buildSubject(amount: 20000));
    await tester.pumpAndSettle();
    final secondKey = tester.widget<UiKitView>(find.byType(UiKitView)).key;

    expect(secondKey, isNot(firstKey));
    expect(
      tester.widget<UiKitView>(find.byType(UiKitView)).creationParams,
      contains('"paymentAmount":"200.00"'),
    );

    debugDefaultTargetPlatformOverride = null;
  });

  testWidgets('does not open a stale native view configuration',
      (tester) async {
    final results = <dynamic>[];
    await pumpIos(tester, buildSubject(onPaymentResult: results.add));
    final target = callbackChannel(tester);
    final staleConfig = nativeConfigFor(tester, target);
    await tester
        .pumpWidget(buildSubject(amount: 999, onPaymentResult: results.add));
    expect(await startPayment(tester, target, config: staleConfig), isFalse);
    expect(results, isEmpty);
  });

  testWidgets('rejects AED before opening Apple Pay', (tester) async {
    final results = <dynamic>[];
    await pumpIos(
        tester, buildSubject(currency: 'AED', onPaymentResult: results.add));
    final target = callbackChannel(tester);
    expect(await startPayment(tester, target), isFalse);
    expect(results.single, isA<UnspecifiedError>());
    expect((results.single as UnspecifiedError).message, contains('SAR only'));
  });

  testWidgets('reports an error when the native result is not a map',
      (tester) async {
    // A malformed payload must still reach onPaymentResult — throwing here
    // would be swallowed by the channel and the payment would never respond.
    mockNativeAvailability('ready');
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    addTearDown(() => debugDefaultTargetPlatformOverride = null);

    final results = <dynamic>[];
    await tester.pumpWidget(buildSubject(onPaymentResult: results.add));
    await tester.pumpAndSettle();

    final target = callbackChannel(tester);
    for (final payload in [
      null,
      'not-a-map',
      <Object?, Object?>{1: 'invalid'},
      {'token': 123},
      {'token': ''}
    ]) {
      expect(await startPayment(tester, target), isTrue);
      expect(
          await sendFromNative(target, 'onApplePayResult', payload), isFalse);
      await sendFromNative(target, 'onApplePayFinished');
    }
    await tester.pumpAndSettle();

    expect(results, hasLength(5));
    expect(results.every((r) => r is UnprocessableTokenError), isTrue);

    debugDefaultTargetPlatformOverride = null;
  });

  testWidgets('reports a canceled payment when the native side errors',
      (tester) async {
    mockNativeAvailability('ready');
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    addTearDown(() => debugDefaultTargetPlatformOverride = null);

    final results = <dynamic>[];
    await tester.pumpWidget(buildSubject(onPaymentResult: results.add));
    await tester.pumpAndSettle();

    final target = callbackChannel(tester);
    await startPayment(tester, target);
    await sendFromNative(target, 'onApplePayError');
    await sendFromNative(target, 'onApplePayError');
    await tester.pumpAndSettle();

    expect(results.single, isA<PaymentCanceledError>());

    debugDefaultTargetPlatformOverride = null;
  });

  for (final status in [
    'paid',
    'authorized',
    'captured',
    'failed',
    'initiated'
  ]) {
    testWidgets('waits for $status and dismissal before notifying the merchant',
        (tester) async {
      final results = <dynamic>[];
      await pumpIos(tester, buildSubject(onPaymentResult: results.add));
      final target = callbackChannel(tester);
      final response = Completer<http.Response>();
      var requests = 0;

      await http.runWithClient(() async {
        expect(await startPayment(tester, target), isTrue);
        final pending =
            sendFromNative(target, 'onApplePayResult', {'token': 'test-token'});
        await tester.pump(const Duration(seconds: 10));

        expect(results, isEmpty);
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        expect(await startPayment(tester, target), isFalse);
        expect(
            await sendFromNative(
                target, 'onApplePayResult', {'token': 'duplicate'}),
            isFalse);
        await sendFromNative(target, 'onApplePayError');
        expect(results, isEmpty);
        expect(requests, 1);

        response.complete(paymentResponse(status: status));
        expect(
            await pending, ['paid', 'authorized', 'captured'].contains(status));
        expect(results, isEmpty);
        await sendFromNative(target, 'onApplePayFinished');
        await sendFromNative(target, 'onApplePayFinished');
        await tester.pumpAndSettle();

        expect(results, hasLength(1));
        expect((results.single as PaymentResponse).status.name, status);
        expect(find.byType(CircularProgressIndicator), findsNothing);
      },
          () => MockClient((_) {
                requests++;
                return response.future;
              }));
    });
  }

  testWidgets('preserves request and callback across a parent rebuild',
      (tester) async {
    final original = <dynamic>[];
    final replacement = <dynamic>[];
    await pumpIos(
        tester, buildSubject(amount: 123, onPaymentResult: original.add));
    final target = callbackChannel(tester);
    final response = Completer<http.Response>();
    var requests = 0;
    String? requestBody;

    await http.runWithClient(() async {
      await startPayment(tester, target);
      final pending =
          sendFromNative(target, 'onApplePayResult', {'token': 'test-token'});
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // A parent rebuild while the server request is pending must not replace
      // the request, callback, or active native session.
      await tester.pumpWidget(
          buildSubject(amount: 999, onPaymentResult: replacement.add));
      expect(await startPayment(tester, target), isFalse);
      expect(requests, 1);
      expect(jsonDecode(requestBody!)['amount'], 123);
      expect(tester.widget<UiKitView>(find.byType(UiKitView)).creationParams,
          contains('"paymentAmount":"1.23"'));
      response.complete(paymentResponse());
      final authorizationSucceeded = await pending;
      expect(authorizationSucceeded, isTrue);
      await sendFromNative(target, 'onApplePayFinished');
      expect(original, hasLength(1));
      expect(original.single, isA<PaymentResponse>());
    },
        () => MockClient((request) {
              requests++;
              requestBody = request.body;
              return response.future;
            }));
    await tester.pumpAndSettle();
    expect(original, hasLength(1));
    expect(replacement, isEmpty);
    expect(tester.widget<UiKitView>(find.byType(UiKitView)).creationParams,
        contains('"paymentAmount":"9.99"'));
  });

  testWidgets('disposing an idle button preserves the other button listener',
      (tester) async {
    final results = <dynamic>[];
    Widget buttons({bool showFirst = true}) => MaterialApp(
            home: Scaffold(
                body: Column(children: [
          if (showFirst)
            ApplePay(
                key: const ValueKey('first'),
                config: buildConfig(),
                onPaymentResult: (_) {}),
          ApplePay(
              key: const ValueKey('second'),
              config: buildConfig(),
              onPaymentResult: results.add),
        ])));
    await pumpIos(tester, buttons());
    final target = callbackChannel(tester, index: 1);
    await tester.pumpWidget(buttons(showFirst: false));
    expect(await startPayment(tester, target), isTrue);
    expect(await sendFromNative(target, 'onApplePayResult', {'token': ''}),
        isFalse);
    await sendFromNative(target, 'onApplePayFinished');
    await tester.pumpAndSettle();
    expect(results.single, isA<UnprocessableTokenError>());
  });

  testWidgets('delivers an in-flight result to its owner after disposal',
      (tester) async {
    final first = <dynamic>[];
    final second = <dynamic>[];
    Widget buttons({bool showFirst = true}) => MaterialApp(
            home: Scaffold(
                body: Column(children: [
          if (showFirst)
            ApplePay(
                key: const ValueKey('first'),
                config: buildConfig(),
                onPaymentResult: first.add),
          ApplePay(
              key: const ValueKey('second'),
              config: buildConfig(),
              onPaymentResult: second.add),
        ])));
    await pumpIos(tester, buttons());
    final firstChannel = callbackChannel(tester);
    final secondChannel = callbackChannel(tester, index: 1);
    expect(firstChannel.name, isNot(secondChannel.name));
    final response = Completer<http.Response>();

    await http.runWithClient(() async {
      await startPayment(tester, firstChannel);
      final pending = sendFromNative(
          firstChannel, 'onApplePayResult', {'token': 'test-token'});
      await tester.pump();
      await tester.pumpWidget(buttons(showFirst: false));
      response.complete(paymentResponse());
      expect(await pending, isTrue);
      await sendFromNative(firstChannel, 'onApplePayFinished');
      expect(first, hasLength(1));
      expect(second, isEmpty);

      // Disposing the first widget must not remove the second one's handler.
      expect(await startPayment(tester, secondChannel), isTrue);
      await sendFromNative(secondChannel, 'onApplePayError');
      expect(second.single, isA<PaymentCanceledError>());
      await tester.pumpAndSettle();
    }, () => MockClient((_) => response.future));
  });

  testWidgets('reports malformed API responses instead of losing the callback',
      (tester) async {
    final results = <dynamic>[];
    await pumpIos(tester, buildSubject(onPaymentResult: results.add));
    final target = callbackChannel(tester);

    await http.runWithClient(() async {
      await startPayment(tester, target);
      expect(
          await sendFromNative(
              target, 'onApplePayResult', {'token': 'test-token'}),
          isFalse);
      await sendFromNative(target, 'onApplePayFinished');
      expect(results.single, isA<UnspecifiedError>());
      await tester.pumpAndSettle();
    },
        () => MockClient(
            (_) async => http.Response('<html>upstream error</html>', 502)));
  });

  testWidgets('rejects a payment response with the wrong amount or currency',
      (tester) async {
    final results = <dynamic>[];
    await pumpIos(tester, buildSubject(onPaymentResult: results.add));
    final target = callbackChannel(tester);
    await http.runWithClient(() async {
      expect(await startPayment(tester, target), isTrue);
      expect(
          await sendFromNative(
              target, 'onApplePayResult', {'token': 'test-token'}),
          isFalse);
      await sendFromNative(target, 'onApplePayFinished');
      expect(results.single, isA<UnspecifiedError>());
      expect((results.single as UnspecifiedError).message,
          contains('does not match'));
    },
        () => MockClient((_) async => http.Response(
            jsonEncode({
              'id': 'mismatched-payment',
              'status': 'paid',
              'amount': 124,
              'fee': 0,
              'currency': 'AED',
              'refunded': 0,
              'captured': 0,
              'amount_format': '1.24 AED',
              'fee_format': '0.00 AED',
              'refunded_format': '0.00 AED',
              'captured_format': '0.00 AED',
              'created_at': '2026-10-17T10:00:00Z',
              'updated_at': '2026-10-17T10:00:00Z',
              'source': {
                'type': 'applepay',
                'number': 'XXXX-XXXX-XXXX-1234',
                'gateway_id': 'test-gateway-id',
              },
            }),
            201)));
    await tester.pumpAndSettle();
  });

  testWidgets('returns a timeout once and does not retry the charge',
      (tester) async {
    final results = <dynamic>[];
    await pumpIos(tester, buildSubject(onPaymentResult: results.add));
    final target = callbackChannel(tester);
    final response = Completer<http.Response>();
    var requests = 0;

    await http.runWithClient(() async {
      await startPayment(tester, target);
      final pending =
          sendFromNative(target, 'onApplePayResult', {'token': 'test-token'});
      await tester.pump();
      await tester.pump(const Duration(seconds: 46));
      expect(await pending, isFalse);
      await sendFromNative(target, 'onApplePayFinished');
      expect(results.single, isA<TimeoutError>());
      expect(requests, 1);

      response.complete(paymentResponse());
      await tester.pumpAndSettle();
      expect(results, hasLength(1));
    },
        () => MockClient((_) {
              requests++;
              return response.future;
            }));
  });
}
