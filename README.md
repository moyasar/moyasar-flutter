# Moyasar Flutter SDK

Accept payments in your Flutter app through **Apple Pay**, **Samsung Pay**, **STC Pay**, and **Credit Card** — with the 3DS step handled for you.

![Moyasar Flutter SDK Demo](https://i.imgur.com/nis9yCm.gif)

| Method | Platforms | Widget |
| --- | --- | --- |
| Credit Card (with managed 3DS) | iOS, Android | `CreditCard` |
| Apple Pay | iOS | `ApplePay` |
| Samsung Pay | Android (Samsung devices) | `SamsungPay` |
| STC Pay | iOS, Android | `STCPay` |

Every widget **hides itself** when its method isn't available on the device, so you can drop them all into one screen without platform checks.

## Install

```sh
flutter pub add moyasar
```

Requires Flutter `>=1.17.0`, Dart `>=2.18.2 <4.0.0`, and iOS 12.0+.
You'll need a Moyasar account — [get your API keys](https://docs.moyasar.com/guides/dashboard/get-your-api-keys).

## Quick start

```dart
import 'package:flutter/material.dart';
import 'package:moyasar/moyasar.dart';

class Checkout extends StatelessWidget {
  Checkout({super.key});

  final paymentConfig = PaymentConfig(
    publishableApiKey: 'YOUR_PUBLISHABLE_API_KEY',
    amount: 25758, // SAR 257.58 — smallest currency unit (1 SAR = 100 halalas)
    description: 'Order #1324',
    creditCard: CreditCardConfig(saveCard: false, manual: false),
    applePay: ApplePayConfig(
      merchantId: 'YOUR_APPLE_MERCHANT_ID',
      label: 'YOUR_STORE_NAME',
      manual: false,
      saveCard: false,
    ),
    samsungPay: SamsungPayConfig(
      serviceId: 'YOUR_SAMSUNG_SERVICE_ID',
      merchantName: 'YOUR_STORE_NAME',
    ),
  );

  void onPaymentResult(result) {
    if (result is PaymentResponse && result.status == PaymentStatus.paid) {
      // Verify on your backend before fulfilling the order.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ApplePay(config: paymentConfig, onPaymentResult: onPaymentResult),
        SamsungPay(config: paymentConfig, onPaymentResult: onPaymentResult),
        CreditCard(config: paymentConfig, onPaymentResult: onPaymentResult),
      ],
    );
  }
}
```

> A widget requires its matching config: `ApplePay` needs `applePay`, `SamsungPay` needs `samsungPay`.

## Handling the result

`onPaymentResult` receives either a `PaymentResponse` or an error. Always check the type first:

```dart
void onPaymentResult(result) {
  if (result is PaymentResponse) {
    switch (result.status) {
      case PaymentStatus.paid:
        // Charged. Verify on your backend before fulfilling.
        break;
      case PaymentStatus.authorized:
      case PaymentStatus.captured:
        // Manual capture flow: funds held, then taken.
        break;
      case PaymentStatus.initiated:
        // Awaiting the 3DS step or an OTP.
        break;
      case PaymentStatus.failed:
        // Declined.
        break;
    }
    return;
  }

  if (result is PaymentCanceledError) {
    // The user dismissed the payment sheet.
  } else if (result is ValidationError) {
    // Invalid input — inspect result.errors.
  } else if (result is NetworkError || result is TimeoutError) {
    // Connectivity problem; let the user retry.
  }
}
```

| Error type | Meaning |
| --- | --- |
| `PaymentCanceledError` | The user dismissed the payment sheet. |
| `UnprocessableTokenError` | The wallet returned an empty or unusable token. |
| `ValidationError` | Invalid request data. Has `message` and `errors`. |
| `AuthError` | The publishable API key was rejected. |
| `ApiError` | Moyasar returned a server-side error. |
| `NetworkError` / `TimeoutError` | The request never completed. |
| `UnspecifiedError` | Anything else. |

Per-method details (masked card number, STC message, 3DS URL) live on `result.source`.

## Apple Pay

1. [Set up your Apple developer account and connect it to Moyasar](https://help.moyasar.com/en/article/moyasar-dashboard-apple-pay-certificate-activation-9l6sd5/).
2. [Enable the Apple Pay capability in Xcode](https://help.apple.com/xcode/mac/current/#/dev44ce8ef13).

```dart
ApplePay(
  config: paymentConfig,
  onPaymentResult: onPaymentResult,
  buttonType: ApplePayButtonType.buy,          // optional, default: inStore
  buttonStyle: ApplePayButtonStyle.automatic,  // optional, default: black
)
```

Renders Apple's native `PKPaymentButton` and drives the sheet through PassKit — no third-party dependency.

**Visibility** is handled for you:

| Situation | Behavior |
| --- | --- |
| Not iOS, or the device can't support Apple Pay | Renders nothing |
| iOS 15+, no card in Wallet | Payment button — the user adds a card inside the sheet |
| iOS 14 and below, no card | "Set Up Apple Pay", which opens Wallet |
| Card available | Payment button |

**`buttonType`:** `plain`, `buy`, `setUp`, `inStore`, `donate`, `checkout`, `book`, `subscribe`, `reload`, `addMoney`, `topUp`, `order`, `rent`, `support`, `contribute`, `tip`
**`buttonStyle`:** `white`, `whiteOutline`, `black`, `automatic` (follows light/dark mode)

## Samsung Pay

Samsung Android devices only. Add the `spay_sdk_api_level` meta-data to your `AndroidManifest.xml` — see the [integration guide](https://docs.moyasar.com/guides/samsung-pay/basic-integration/). The SDK bundles Samsung's official Flutter plugin, so no app-level override is needed.

```dart
SamsungPay(config: paymentConfig, onPaymentResult: onPaymentResult)
```

The widget hides itself when Samsung Pay isn't ready. To check explicitly in a custom flow:

```dart
final eligible = await SamsungPayEligibility.isEligible(paymentConfig);

final result = await SamsungPayEligibility.check(paymentConfig); // with diagnostics
debugPrint('${result.reason}'); // ready, notAndroid, notReady, sdkError, timeout...
```

## Credit Card & STC Pay

Both render a full form and accept an optional `locale`. `Localization.ar()` also switches the layout to RTL; individual strings can be overridden through its named parameters.

```dart
CreditCard(config: paymentConfig, onPaymentResult: onPaymentResult)

STCPay(
  config: paymentConfig,
  onPaymentResult: onPaymentResult,
  locale: const Localization.ar(),
)
```

## Configuration

### `PaymentConfig`

| Field | Type | Default | Description |
| --- | --- | --- | --- |
| `publishableApiKey` | `String` | **required** | Your publishable key. |
| `amount` | `int` | **required** | Smallest currency unit (`25758` = SAR 257.58). |
| `description` | `String` | **required** | Tag for the payment. |
| `currency` | `String` | `'SAR'` | ISO currency code. |
| `metadata` | `Map<String, dynamic>?` | `null` | Searchable key/value pairs. |
| `supportedNetworks` | `List<PaymentNetwork>` | `visa, mada, masterCard, unionPay` | Also accepts `amex`. |
| `applePay` | `ApplePayConfig?` | `null` | Required by `ApplePay`. |
| `samsungPay` | `SamsungPayConfig?` | `null` | Required by `SamsungPay`. |
| `creditCard` | `CreditCardConfig?` | `null` | Used by `CreditCard`. |
| `merchantCountryCode` | `String` | `'SA'` | Used by Samsung Pay. |
| `givenID` | `String?` | `null` | Sets the payment ID — use for idempotent retries. |
| `splits` | `List<PaymentSplit>?` | `null` | Split the amount (aggregation clients only). |
| `baseUrl` | `String?` | `null` | Override the API host, e.g. `https://apimig.moyasar.com`. |
| `applyCoupon` | `bool?` | `null` | Set `false` to skip coupon application. |

### `ApplePayConfig`

| Field | Type | Default | Description |
| --- | --- | --- | --- |
| `merchantId` | `String` | **required** | Must match Xcode and your dashboard. |
| `label` | `String` | **required** | Store name in the payment sheet. |
| `manual` | `bool` | **required** | Authorize now, capture later. |
| `saveCard` | `bool` | **required** | Tokenize for later charges. |
| `merchantCapabilities` | `List<String>` | `["3DS", "debit", "credit"]` | Must include `"3DS"`. |
| `supportedCountries` | `List<String>` | `["SA"]` | Widening this raises fraud risk. |

### `SamsungPayConfig`

| Field | Type | Default | Description |
| --- | --- | --- | --- |
| `serviceId` | `String` | **required** | From the Samsung merchant dashboard. |
| `merchantName` | `String` | **required** | Shown in the payment sheet. |
| `orderNumber` | `String?` | auto-generated | `[A-Za-z0-9-]`, max 36 chars. Returned as `samsungpay_order_id` in the response metadata. |
| `manual` | `bool` | `false` | Authorize now, capture later. |

### `CreditCardConfig`

`saveCard` (`bool`, required) — tokenize after a successful payment.
`manual` (`bool`, required) — authorize now, capture later.

### `PaymentSplit`

Divide a payment among recipients, in compliance with SAMA and ZATCA. Aggregation clients only — splits on other payments are ignored. The splits must total the payment amount.

```dart
splits: [
  PaymentSplit(recipientId: 'ENTITY_ID', amount: 20000, recipientType: 'Entity'),
  PaymentSplit(recipientId: 'PLATFORM_ID', amount: 5758, recipientType: 'Platform', feeSource: true),
]
```

Also accepts `description`, `reference`, `feeSource` (default `false`, only one split may be the fee source), and `refundable` (default `true`).

## Building your own UI

Use these when you need full control over the interface — you collect the payment data, the SDK talks to the API.

```dart
// Credit Card
final source = CardPaymentRequestSource(
  creditCardData: CardFormModel(
    name: 'John Doe',
    number: '4111111111111111',
    cvc: '123',
    month: '05',
    year: '2027',
  ),
  tokenizeCard: paymentConfig.creditCard!.saveCard,
  manualPayment: paymentConfig.creditCard!.manual,
);

// Apple Pay — appleToken is the PKPaymentToken payment data
final source = ApplePayPaymentRequestSource(
  appleToken,
  paymentConfig.applePay!.manual,
  paymentConfig.applePay!.saveCard,
);

// Samsung Pay
final source = SamsungPayPaymentRequestSource(
  samsungPayToken: token,
  manualPayment: paymentConfig.samsungPay!.manual,
);

// Then, for any source:
final result = await Moyasar.pay(
  apiKey: paymentConfig.publishableApiKey,
  paymentRequest: PaymentRequest(paymentConfig, source),
);
```

With a custom Credit Card UI, **3DS is your responsibility**: when `status` is `initiated`, open `(result.source as CardPaymentResponseSource).transactionUrl` in a web view and watch for the redirect to `PaymentConfig.callbackUrl`.

STC Pay takes two steps — start the payment, then verify the OTP:

```dart
final result = await Moyasar.pay(
  apiKey: paymentConfig.publishableApiKey,
  paymentRequest: PaymentRequest(paymentConfig, StcRequestSource(mobile: '0512345678')),
);

final transactionUrl = (result.source as StcResponseSource).transactionUrl!;

final verified = await Moyasar.verifyOTP(
  transactionURL: transactionUrl,
  otpRequest: OtpRequestSource(otpValue: '1234'),
);
```

## Testing

- **Credit Card** — [test cards](https://docs.moyasar.com/guides/card-payments/test-cards) work against the sandbox.
- **Apple Pay** — use a **real device**; the simulator can't complete an authorization. [Test amounts](https://docs.moyasar.com/guides/apple-pay/testing).
- **Samsung Pay** — requires a Samsung device. The example app uses flavors: `flutter run --flavor default_` (Apple Pay) or `--flavor spay` (Samsung Pay). See [example/CONFIGURATION_GUIDE.md](example/CONFIGURATION_GUIDE.md).

## Deprecations

`STCPaymentComponent` is deprecated and will be removed in the next major version — it's a drop-in rename to `STCPay`.

---

Issues and pull requests are welcome at [moyasar/moyasar-flutter](https://github.com/moyasar/moyasar-flutter).
