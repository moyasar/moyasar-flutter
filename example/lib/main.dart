import 'package:coffee_flutter/widgets/payment.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      publishableApiKey: 'pk_test_KjYR9npiw3UJJpwXpvaADS3ut5bKtyC6ip18FeDC',
      amount: 100, // SAR 1
      description: 'order #1324',
      callbackUrl: 'http://localhost:13404/auth.html',
      metadata: {'size': '250g'},
      creditCard: CreditCardConfig(saveCard: false, manual: false),


      applePay: ApplePayConfig(
          merchantId: 'merchant.mysr.fghurayri',
          label: 'Blue Coffee Beans',
          manual: false));

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
          // handle authorized
          break;
        default:
      }
      return;
    }

    // handle other type of failures.
    if (result is ApiError) {}
    if (result is AuthError) {}
    if (result is ValidationError) {}
    if (result is PaymentCanceledError) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        body: Center(
          child: 
          TextButton(
            onPressed: onSubmitCcForm,
            child: const Text('Pay'),
          ),
        ));
  }


 void onSubmitCcForm() async {
    final source = CardPaymentRequestSource(
      
        creditCardData: CardFormModel(
            name: 'John Doe',
            number: '4201320111111010',
            month: '05',
            year: '2025',cvc: 
            '100'),
        tokenizeCard: (paymentConfig.creditCard as CreditCardConfig).saveCard,
        manualPayment: (paymentConfig.creditCard as CreditCardConfig).manual);

    final paymentRequest = PaymentRequest(paymentConfig, source);

    final result = await Moyasar.pay(
        apiKey: paymentConfig.publishableApiKey,
        paymentRequest: paymentRequest);



    final String transactionUrl =
        (result.source as CardPaymentResponseSource).transactionUrl;

    if (kIsWeb) {
    

      try {
        final result = await FlutterWebAuth2.authenticate(
          url: transactionUrl,
          callbackUrlScheme: 'auth',
         
        );
final uri = Uri.parse(result);

final status = PaymentStatus.values.byName(uri.queryParameters['status']!);

    showToast(context, status);
     
      } on PlatformException catch (e) {
        print('PlatformException ${e}');
        // setState(() {
        //   _status = 'Got error: $e';
        // });
      }
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
}