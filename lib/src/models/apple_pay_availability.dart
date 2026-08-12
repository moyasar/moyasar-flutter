/// How ready the current device is to pay with Apple Pay.
///
/// Mirrors the native `ApplePayAvailability` enum; the raw values must stay in
/// sync with it since they travel across the method channel by name.
enum ApplePayAvailability {
  /// The device, OS, or its restrictions can't support Apple Pay at all.
  notSupported,

  /// Apple Pay is supported, but no card we accept has been added yet.
  needsSetup,

  /// Apple Pay is supported and a card we accept is ready to be charged.
  ready;

  /// Returns the matching value, or `null` when [name] isn't recognized.
  static ApplePayAvailability? fromName(String? name) {
    for (final availability in ApplePayAvailability.values) {
      if (availability.name == name) {
        return availability;
      }
    }

    return null;
  }
}
