import 'package:coffee_flutter/theme/app_theme.dart';
import 'package:coffee_flutter/widgets/payment.dart';
import 'package:flutter/material.dart';
import 'package:moyasar/moyasar.dart';
import 'package:moyasar/theme/moyasar_theme.dart';

import 'widgets/coffee.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      home: const CoffeeShop(),
    );
  }
}

class CoffeeShop extends StatefulWidget {
  const CoffeeShop({super.key});

  @override
  State<CoffeeShop> createState() => _CoffeeShopState();
}

class _CoffeeShopState extends State<CoffeeShop> {
  final paymentConfig = PaymentConfig(
      publishableApiKey: 'pk_test_r6eZg85QyduWZ7PNTHT56BFvZpxJgNJ2PqPMDoXA',
      amount: 100, // SAR 1
      description: 'order #1324',
      metadata: {'size': '250g', 'code': 255},
      creditCard: CreditCardConfig(saveCard: false, manual: false),
      applePay: ApplePayConfig(
          merchantId: 'merchant.com.mysr.apple',
          label: 'Blue Coffee Beans',
          manual: false,
          saveCard: false));

  void onPaymentResult(result) {
    if (result is PaymentResponse) {
      showToast(context, result.status.name);
      switch (result.status) {
        case PaymentStatus.paid:
          // handle success.
          break;
        case PaymentStatus.failed:
          // handle failure.
          break;
        case PaymentStatus.authorized:
          // handle authorized.
          break;
        default:
      }
      return;
    }

    // handle failures.
    if (result is ApiError) {
      showToast(context, result.message);
    }
    if (result is AuthError) {
      showToast(context, result.message);
    }
    if (result is ValidationError) {
      showToast(context, result.message);
    }
    if (result is PaymentCanceledError) {
      showToast(context, result.message);
    }
    if (result is UnprocessableTokenError) {
      showToast(context, result.message);
    }
    if (result is TimeoutError) {
      showToast(context, result.message);
    }
    if (result is NetworkError) {
      showToast(context, result.message);
    }
    if (result is UnspecifiedError) {
      showToast(context, result.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: ListView(
              children: [
                const CoffeeImage(),
                MoyasarTheme(
                  data: AppTheme.darkTheme,
                  child: PaymentMethods(
                    paymentConfig: paymentConfig,
                    onPaymentResult: onPaymentResult,
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

void showToast(context, status) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      "Status: $status",
      style: const TextStyle(fontSize: 20),
    ),
  ));
}
