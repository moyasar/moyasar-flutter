# Coffee Flutter

Example application on how to integrate the Moyasar Flutter SDK.

The iOS example uses Swift Package Manager and requires Flutter 3.44 or later.
Run `flutter pub get`, then `flutter run` with a physical iPhone selected to test
Apple Pay. CocoaPods is not required for this example. The SDK still includes
`ios/moyasar.podspec` for applications using CocoaPods.

The Xcode `moyasar` navigator entry points to the plugin's **sources**, not its
Swift package directory. Keep it that way: Flutter's generated package already
loads the plugin. Adding the package directory as a local override can cause an
identity mismatch when the checkout directory is named `moyasar-flutter`.
See [Flutter issue #186881](https://github.com/flutter/flutter/issues/186881).

After a clean checkout, generate Flutter's package files with `flutter pub get`
before opening `ios/Runner.xcworkspace`. Use the `Runner` scheme for the standard
example.
