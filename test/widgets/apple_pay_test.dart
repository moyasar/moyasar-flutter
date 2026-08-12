import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moyasar/moyasar.dart';

void main() {
  const channel = MethodChannel('flutter.moyasar.com/apple_pay');

  final binding = TestWidgetsFlutterBinding.ensureInitialized();

  /// Records the calls the widget makes, and replies with [availability].
  List<MethodCall> mockNativeAvailability(String? availability) {
    final calls = <MethodCall>[];

    binding.defaultBinaryMessenger.setMockMethodCallHandler(channel, (call) async {
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

  Widget buildSubject({int amount = 123, Function? onPaymentResult}) =>
      MaterialApp(
        home: Scaffold(
          body: ApplePay(
            config: PaymentConfig(
              publishableApiKey: 'pk_test_key',
              amount: amount,
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
  Future<void> sendFromNative(String method, Object? arguments) {
    return binding.defaultBinaryMessenger.handlePlatformMessage(
      channel.name,
      channel.codec.encodeMethodCall(MethodCall(method, arguments)),
      (_) {},
    );
  }

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

    await sendFromNative('onApplePayResult', null);
    await sendFromNative('onApplePayResult', 'not-a-map');
    await tester.pumpAndSettle();

    expect(results, hasLength(2));
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

    await sendFromNative('onApplePayError', null);
    await tester.pumpAndSettle();

    expect(results.single, isA<PaymentCanceledError>());

    debugDefaultTargetPlatformOverride = null;
  });
}
