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


// Add this widget in your payment.dart file or a new file

class STCPay extends StatefulWidget {
  final PaymentConfig config;
  final Function onPaymentResult;

  const STCPay({
    Key? key,
    required this.config,
    required this.onPaymentResult,
  }) : super(key: key);

  @override
  State<STCPay> createState() => _STCPayState();
}

class _STCPayState extends State<STCPay> {
  bool isLoading = false;
  String? error;
  String? transactionUrl;
  final otpController = TextEditingController();

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _handlePayment(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF5D2D87), // STC Pay purple color
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.phone_android, color: Colors.white),
          SizedBox(width: 12),
          Text(
            'Pay with STC Pay',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  final phoneController = TextEditingController();

  Future<void> _handlePayment(BuildContext context) async {
    final localTransactionUrl = transactionUrl; // Create a local copy of the state variable
    final localIsLoading = isLoading;
    final localError = error;

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Pay with STC Pay'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (transactionUrl == null) ...[
                  TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'STC Pay Number',
                      hintText: '05XXXXXXXX',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ] else ...[
                  const Text('Enter the OTP sent to your phone'),
                  const SizedBox(height: 16),
                  TextField(
                    controller: otpController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'OTP',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],

              ],
            ),
            actions: [
              TextButton(
                onPressed: isLoading
                    ? null
                    : () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () async {
                  setState(() {
                    isLoading = true;
                    error = null;
                  });

                  try {
                    if (localTransactionUrl == null) {
                      // Initiate payment
                      final source = StcRequestSource(
                        mobile: phoneController.text
                      );
                      final paymentConfig = PaymentConfig(
                        publishableApiKey: widget.config.publishableApiKey,
                        amount: widget.config.amount,
                        description: widget.config.description,
                      );
                      final paymentRequest = PaymentRequest(
                        paymentConfig,
                        source,
                      );
                      final result = await Moyasar.pay(
                        apiKey: widget.config.publishableApiKey,
                        paymentRequest: paymentRequest,
                      );

                      if (result is PaymentResponse &&
                          result.status == PaymentStatus.initiated) {
                        final stcResponse = result.source as StcResponseSource;
                        setState(() {
                          transactionUrl = stcResponse.transactionUrl;
                        });
                      } else {
                        throw Exception('Failed to initiate payment');
                      }
                    } else {
                      // Verify OTP
                      final otpRequest = OtpRequestSource(
                        otpValue: otpController.text,
                      );
                      final result = await Moyasar.verifyOTP(
                        transactionURL: localTransactionUrl!,
                        otpRequest: otpRequest,
                      );
                      if (mounted) {
                        widget.onPaymentResult(result);
                        Navigator.pop(context);
                      }
                    }
                  } catch (e) {
                    setState(() => error = e.toString());
                  } finally {
                    if (mounted) {
                      setState(() => isLoading = false);
                    }
                  }
                },
                child: isLoading
                    ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
                    : Text(localTransactionUrl == null ? 'Pay' : 'Verify OTP'),
              ),
            ],
          );
        },
      ),
    );
  }
}