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
