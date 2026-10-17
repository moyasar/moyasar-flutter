import 'package:flutter_test/flutter_test.dart';
import 'package:moyasar/moyasar.dart';

import 'package:coffee_flutter/main.dart';
import 'package:coffee_flutter/widgets/coffee.dart';
import 'package:coffee_flutter/widgets/payment.dart';

void main() {
  testWidgets('renders the coffee checkout and payment methods',
      (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.byType(CoffeeShop), findsOneWidget);
    expect(find.byType(CoffeeImage), findsOneWidget);
    expect(find.byType(PaymentMethods), findsOneWidget);
    expect(find.byType(CreditCard), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
