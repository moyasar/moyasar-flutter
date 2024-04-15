## 2.0.8

The main theme of this release is to support latest versions of the Flutter tooling and the utilized dependencies.

- [Flutter] Upgrade to latest versions of Flutter tooling; Flutter to `3.19.5`, Dart to `3.3.3`, DevTools to `2.31.1`.
- [Moyasar] Upgrade `http` dependency to `1.2.1`.
- [Apple Pay] Upgrade `pay` dependency to `2.0.0`.
- [Credit Card] Upgrade `webview_flutter` dependency to `4.7.0`.
 
## 2.0.7

- [Apple Pay] Improve the UX by allowing the user to setup Apple Pay card if none is added yet.
 
## 2.0.6

- [Flutter] Upgrade to latest versions of Flutter tooling; Flutter to `3.16.9`, Dart to `3.2.6`, DevTools to `2.28.5`.
- [Moyasar] Upgrade `http` dependency to `1.2.0`.
- [Moyasar] Support customizing the accepted networks with `supportedNetworks` in the `PaymentConfig`.
- [Apple Pay] Support customizing the accepted payment capabilities with `merchantCapabilities` in the `ApplePayConfig`.
- [Apple Pay] Support customizing the Apple Pay button type and styling.
- [Credit Card] Upgrade `webview_flutter` dependency to `4.5.0`.
 
## 2.0.5

- [Flutter] Upgrade to latest versions of Flutter tooling; Flutter to `3.16.3`, Dart to `3.2.3`, DevTools to `2.28.4`.
- [Moyasar] Upgrade `http` dependency to `1.1.2`.
- [Moyasar] Handle potential HTTP request failures.
- [Apple Pay] Handle when the Apple Pay token is unprocessable.
- [Docs] Update the testing guides with latest help links.
- [Docs] Update the Apple Pay testing guide.

## 2.0.4

- [Moyasar] Support customizing the UI

## 2.0.3

The main theme of this release is to support latest versions of the Flutter tooling and the utilized dependencies.

- [Flutter] Upgrade to latest versions of Flutter tooling; Flutter to `3.16.0`, Dart to `3.2.0`, DevTools to `2.28.2`.
- [Moyasar] Upgrade `http` dependency to `1.1.0`.
- [Apple Pay] Upgrade `pay` dependency to `1.1.2`.
- [Credit Card] Upgrade `webview_flutter` dependency to `4.4.2`.
- [Credit Card] Explicitly set the text color of the Pay button to white.
- [Docs] Fix coding style (line wrapping) in the example.

## 2.0.2

- [Credit Card] Add an option to create manual payments, this will let you authorize payment but will not collect the amount from the user untill you send a capture request.
- [Apple Pay] Add an option to create manual payments, this will let you authorize payment but will not collect the amount from the user untill you send a capture request.

## 2.0.1

- [Credit Card] Add an option to tokenize (save) the credit card upon successful payment.
- [Credit Card] Fix an issue where some devices experience 3DS form rerendering when the user try to insert the OTP.

## 2.0.0

**Breaking Change For Apple Pay**: Apple Pay should be configured as part of the `PaymentConfig` object. Check the `Migrating Guide` > `From 1.0 to 2.0` section in the Readme for more details.

The purpose of this upgrade is to improve the pub points by supporintg up-to-date dependencies and improving the static analysis report.

- [Apple Pay] Upgrade `pay` dependecy to `1.1.1` to remove deprecation warnings.
- [Credit Card] Upgrade `webview_flutter` dependecy to `4.2.0` to support the latest major version.
- [Docs] Update the Apple Pay prerequisites by removing the need to create a JSON payment config under the asset folder.
- [Docs] Update the code example.
- [Docs] Fix the gif example.

## 1.0.2

- [Apple Pay] Fix showing the merchant name during the Apple Pay payment session to avoid possible app rejection.

## 1.0.1

- [Apple Pay] Fix handling the Apple Pay response when the `company` and `name` fields aren't returned from the API.
- [Docs] Fix a typo in the installation command.
- [Docs] Improve the application description in pub.dev

## 1.0.0

- Build the Dart Moyasar API wrapper.
- Add Apple Pay widget.
- Add Credit Card widget with managed 3DS step.
- Add tests.
- Add documentation.
