import 'package:coffee_flutter/widgets/payment.dart';
import 'package:flutter/material.dart';
import 'package:moyasar/moyasar.dart';

import 'widgets/coffee.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CoffeeShop(),
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
    publishableApiKey: 'pk_test_U38gMHTgVv4wYCd35Zk1JSEd1ZyMYyA9oQ7T4rKa',
    amount: 20001, // SAR 200.01
    description: 'Test payment',
    metadata: {'size': '250g', 'code': 255},
    merchantCountryCode: 'SA',
    supportedNetworks: [
      PaymentNetwork.mada,
      PaymentNetwork.visa,
      PaymentNetwork.masterCard,
      PaymentNetwork.amex
    ],
    creditCard: CreditCardConfig(saveCard: false, manual: false),
    applePay: ApplePayConfig(
        merchantId: 'merchant.com.mysr.apple',
        label: 'Blue Coffee Beans',
        manual: false,
        saveCard: false),
    samsungPay: SamsungPayConfig(
        serviceId: 'ea810dafb758408fa530b1',
        merchantName: 'Test Samsung Pay from app',
        orderNumber: 'c553ed70-fb79-487c-b3d2-15aca6aff90c',
        manual: false),
    // splits: [
    //   PaymentSplit(
    //       recipientId: "7d2d0797-a2be-40fe-bb1b-1fdec9824c95",
    //       amount: 8000),
    //   PaymentSplit(
    //       recipientId: "327680bb-d790-4643-8e10-31455a1ab3a6",
    //       amount: 2000,
    //       reference: "optional-reference-for-split-1fcfcbe9-ba75-4eed",
    //       description: "Platform processing fee",
    //       feeSource: true,
    //       refundable: false
    //   )
    // ]
  );

  void onPaymentResult(result) {
    if (result is PaymentResponse) {
      showToast(context, result.status.name);
      switch (result.status) {
        case PaymentStatus.paid:
          // handle success.
          break;
        case PaymentStatus.failed:
          // handle failure.
          String? errorMessage;
          if (result.source is CardPaymentResponseSource) {
            errorMessage = (result.source as CardPaymentResponseSource).message;
          } else if (result.source is ApplePayPaymentResponseSource) {
            errorMessage =
                (result.source as ApplePayPaymentResponseSource).message;
          } else if (result.source is SamsungPayPaymentResponseSource) {
            errorMessage =
                (result.source as SamsungPayPaymentResponseSource).message;
          } else if (result.source is StcResponseSource) {
            errorMessage = (result.source as StcResponseSource).message;
          }
          print(errorMessage ?? 'Payment failed');
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
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        body: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: ListView(
              children: [
                const CoffeeImage(),
                PaymentMethods(
                  paymentConfig: paymentConfig,
                  onPaymentResult: onPaymentResult,
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
