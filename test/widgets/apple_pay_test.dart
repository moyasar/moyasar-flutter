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

  Widget buildSubject() => MaterialApp(
        home: Scaffold(
          body: ApplePay(config: buildConfig(), onPaymentResult: (_) {}),
        ),
      );

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
}
