import 'dart:io';

import 'package:coffee_flutter/widgets/stc_ui_customization.dart';
import 'package:flutter/material.dart';
import 'package:moyasar/moyasar.dart';

class PaymentMethods extends StatelessWidget {
  final PaymentConfig paymentConfig;
  final Function onPaymentResult;

  const PaymentMethods(
      {super.key, required this.paymentConfig, required this.onPaymentResult});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (Platform.isIOS)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: ApplePay(
              config: paymentConfig,
              onPaymentResult: onPaymentResult,
            ),
          )
        else
          const SizedBox.shrink(),
        CreditCard(
          config: paymentConfig,
          onPaymentResult: onPaymentResult,
        ),

        //pay with STC Demo Button
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: SizedBox(
            child: ElevatedButton(
                style: ButtonStyle(
                  minimumSize:
                      const WidgetStatePropertyAll<Size>(Size.fromHeight(55)),
                  backgroundColor: const WidgetStatePropertyAll<Color>(
                    Colors.white,
                  ),
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Scaffold(
                            body: STCPaymentComponent(
                                config: paymentConfig,
                                onPaymentResult: onPaymentResult))),
                  );
                },
                child: const Text(
                  'Pay with STC Demo',
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                )),
          ),
        ),
        const SizedBox(height: 10),
        STCPay(
          config: paymentConfig,
          onPaymentResult: onPaymentResult,
        ),
      ],
    );
  }
}