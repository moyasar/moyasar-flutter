import PassKit

/// How ready this device is to pay with Apple Pay.
///
/// iOS 15 added card provisioning inside the payment sheet itself, so an empty
/// Wallet is no longer a reason to hold the user back: the normal payment
/// button opens the sheet and they add a card there, in one step.
///
/// Below iOS 15 the sheet can't do that, so we fall back to Apple's older
/// guidance — check the accepted networks and offer a setup button that sends
/// the user to Wallet instead.
enum ApplePayAvailability: String {
    /// The device, OS, or its restrictions can't support Apple Pay at all.
    case notSupported
    /// Pre-iOS 15 only: supported, but no card we accept has been added yet.
    case needsSetup
    /// Apple Pay is supported and the payment sheet can be presented.
    case ready

    static func current(supportedNetworks: [String]) -> ApplePayAvailability {
        guard PKPaymentAuthorizationController.canMakePayments() else {
            return .notSupported
        }

        // The sheet handles adding a card itself from here on.
        if #available(iOS 15.0, *) {
            return .ready
        }

        let networks = supportedNetworks.compactMap { PKPaymentNetwork.fromString($0) }

        return PKPaymentAuthorizationController.canMakePayments(usingNetworks: networks)
            ? .ready
            : .needsSetup
    }
}
