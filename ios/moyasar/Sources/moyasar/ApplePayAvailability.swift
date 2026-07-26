import PassKit

/// How ready this device is to pay with Apple Pay.
///
/// Apple exposes two separate questions, and they mean very different things:
/// whether the device supports Apple Pay at all, and whether the user has
/// already added a card we accept. Keeping them apart lets the button offer
/// card setup instead of silently disappearing on a perfectly capable iPhone.
enum ApplePayAvailability: String {
    /// The device, OS, or its restrictions can't support Apple Pay at all.
    case notSupported
    /// Apple Pay is supported, but no card we accept has been added yet.
    case needsSetup
    /// Apple Pay is supported and a card we accept is ready to be charged.
    case ready

    static func current(supportedNetworks: [String]) -> ApplePayAvailability {
        guard PKPaymentAuthorizationController.canMakePayments() else {
            return .notSupported
        }

        let networks = supportedNetworks.compactMap { PKPaymentNetwork.fromString($0) }

        return PKPaymentAuthorizationController.canMakePayments(usingNetworks: networks)
            ? .ready
            : .needsSetup
    }
}
