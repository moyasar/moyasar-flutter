Easily accept payments through Apple Pay or Credit Card (with managed 3DS step) in your Flutter app with Moyasar.

![Moyasar Flutter SDK Demo](https://i.imgur.com/nis9yCm.gif)

## Features

Use this plugin to support:

- **Apple Pay**: Quickly and safely accept Apple Pay payments.
- **Credit Card**: Easily accept many card companies while not worrying about managing the required 3DS step.

## Getting started

### Prerequisites

#### **Accepting Apple Pay Payments in iOS**

Complete the following steps to easily accept Apple Pay payments:

- Follow [this guide](https://help.moyasar.com/en/article/moyasar-dashboard-apple-pay-certificate-activation-9l6sd5/) to setup your Apple developer account and integrate it with Moyasar.
- Follow [this guide](https://help.apple.com/xcode/mac/9.3/#/deva43983eb7?sub=dev44ce8ef13) to enable accepting Apple Pay in your application using xCode.

#### **Accepting Credit Card Payments in Android**

Due to depending on the `flutter_webview` package to manage the 3DS step, make sure to set the correct minSdkVersion in android/app/build.gradle if it was previously lower than 19:

```
android {
    defaultConfig {
        minSdkVersion 19
    }
}
```

### Installation

```sh
flutter pub add moyasar
```

## Usage

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

## Testing

### Credit Cards
Moyasar provides a sandbox environment for testing credit card payments without charging any real money. This allows you to test your integration and ensure that everything is working correctly before going live with actual payments. Learn more about our testing cards [here](https://moyasar.com/docs/testing/credit-cards)

### Apple Pay
When using Apple Pay in the sandbox environment, you can try to make payments, but they will always fail. You can make sure that the integration has been completed once you go to Moyasar Dashboard and see the payment. Make sure to use a real device, not a simulator.

it's recommended that you test Apple Pay using our live environment, and voiding the payment after.


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
