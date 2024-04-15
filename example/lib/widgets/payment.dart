import 'dart:io';

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
        if (Platform.isIOS) Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: ApplePay(
            config: paymentConfig,
            onPaymentResult: onPaymentResult,
          ),
        ) else const SizedBox.shrink(),
        CreditCard(
          config: paymentConfig,
          onPaymentResult: onPaymentResult,
        )
      ],
    );
  }
}
