# Moyasar Flutter SDK

Easily accept payments through Apple Pay, STC Pay, or Credit Card (with managed 3DS step) in your Flutter app with Moyasar.

![Moyasar Flutter SDK Demo](https://i.imgur.com/nis9yCm.gif)

## Features

Use this plugin to support:

- **Apple Pay**
- **STC Pay**
- **Credit Card**

## Getting started

### Prerequisites

#### **Accepting Apple Pay Payments in iOS**

Complete the following steps to easily accept Apple Pay payments:

- Follow [this guide](https://help.moyasar.com/en/article/moyasar-dashboard-apple-pay-certificate-activation-9l6sd5/) to setup your Apple developer account and integrate it with Moyasar.
- Follow [this guide](https://help.apple.com/xcode/mac/9.3/#/deva43983eb7?sub=dev44ce8ef13) to enable accepting Apple Pay in your application using xCode.

#### **Accepting Payments in Android**

Due to depending on the `pay` package, make sure to set the correct minSdkVersion in android/app/build.gradle if it was previously lower than 21:

```gradle
android {
    defaultConfig {
        minSdkVersion 21
    }
}
```

### Installation

```sh
flutter pub add moyasar
```

## Usage

### Moyasar Widgets

```dart
import 'package:flutter/material.dart';
import 'package:moyasar/moyasar.dart';

class PaymentMethods extends StatelessWidget {
  PaymentMethods({super.key});

  final paymentConfig = PaymentConfig(
    publishableApiKey: 'YOUR_API_KEY',
    amount: 25758, // SAR 257.58
    description: 'order #1324',
    metadata: {'size': '250g'},
    creditCard: CreditCardConfig(saveCard: true, manual: false),
    applePay: ApplePayConfig(merchantId: 'YOUR_MERCHANT_ID', label: 'YOUR_STORE_NAME', manual: false),
  );

  void onPaymentResult(result) {
    if (result is PaymentResponse) {
      switch (result.status) {
        case PaymentStatus.paid:
          // handle success.
          break;
        case PaymentStatus.failed:
          // handle failure.
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ApplePay(
            config: paymentConfig,
            onPaymentResult: onPaymentResult,
        ),
        const Text("or"),
        CreditCard(
          config: paymentConfig,
          onPaymentResult: onPaymentResult,
        )
      ],
    );
  }
}
```

### Custom Widgets

```dart
// Unified config for Moyasar API
  final paymentConfig = PaymentConfig(
    publishableApiKey: 'YOUR_API_KEY',
    amount: 25758, // SAR 257.58
    description: 'order #1324',
    metadata: {'size': '250g'},
    creditCard: CreditCardConfig(saveCard: true, manual: false),
    applePay: ApplePayConfig(
        merchantId: 'YOUR_MERCHANT_ID',
        label: 'YOUR_STORE_NAME',
        manual: false),
  );

  // Callback once the user clicks on the custom Apple Pay widget
  void onSubmitApplePay(applePay) async {
    final source = ApplePayPaymentRequestSource(
        applePay['token'], (paymentConfig.applePay as ApplePayConfig).manual);
    final paymentRequest = PaymentRequest(paymentConfig, source);

    final result = await Moyasar.pay(
        apiKey: paymentConfig.publishableApiKey,
        paymentRequest: paymentRequest);

    onPaymentResult(result);
  }

  // Callback once the user fills & submit their CC information using the custom form widget
  
  void onSubmitCcForm() async {
    final source = CardPaymentRequestSource(
        creditCardData: CardFormModel(
            name: 'John Doe',
            number: '4111111111111111',
            month: '05',
            year: '2025'),
        tokenizeCard: (paymentConfig.creditCard as CreditCardConfig).saveCard,
        manualPayment: (paymentConfig.creditCard as CreditCardConfig).manual);

    final paymentRequest = PaymentRequest(paymentConfig, source);

    final result = await Moyasar.pay(
        apiKey: paymentConfig.publishableApiKey,
        paymentRequest: paymentRequest);

    onPaymentResult(result);
  }
  
 // Callback once the user fills & submit their mobile number for STC and OTP information using the custom form widget

 # Mobile Number
 
  final source = StcRequestSource( mobile: phoneController.text );
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
  onPaymentResult(result);

 # OTP
 
  final otpRequest = OtpRequestSource( otpValue: otpController.text);
  final result = await Moyasar.verifyOTP(
                        transactionURL: transactionUrl!,
                        otpRequest: otpRequest,
                      );
                      
  onPaymentResult(result);


  // Unified payment result processor
  void onPaymentResult(result) {
    if (result is PaymentResponse) {
      switch (result.status) {
        case PaymentStatus.initiated:
          // handle 3DS redirection.
          break;
        case PaymentStatus.paid:
          // handle success.
          break;
        case PaymentStatus.failed:
          // handle failure.
          break;
      }
    }
  }
```

## Testing

### Credit Cards

Moyasar provides a sandbox environment for testing credit card payments without charging any real money. This allows you to test your integration and ensure that everything is working correctly before going live with actual payments. Learn more about our testing cards [here](https://docs.moyasar.com/guides/card-payments/test-cards)

### Apple Pay

Please use a real device to perform Apple Pay testing and not a simulator. Learn more on how to test different scenarios in the sandbox [here.](https://docs.moyasar.com/guides/apple-pay/test-cards)

## Migration Guide

### From `1.0` to `2.0`

This upgrade changes how Apple Pay is configured. Do the following changes to complete the upgrade:

- Delete the `default_payment_profile_apple_pay.json` file under your assets file.
- Update the `paymentConfig` instance to include the new `applePay` configuration.

```diff
final paymentConfig = PaymentConfig(
    publishableApiKey: 'YOUR_API_KEY',
    amount: 25758, // SAR 257.58
    description: 'order #1324',
    metadata: {'size': '250g'},
+   applePay: ApplePayConfig(merchantId: 'YOUR_MERCHANT_ID', label: 'YOUR_STORE_NAME'),
);
```
