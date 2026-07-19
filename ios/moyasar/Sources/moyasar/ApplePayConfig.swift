public struct ApplePayConfig: Codable {
    let merchantIdentifier: String
    let paymentLabel: String
    let merchantCapabilities: [String]
    let supportedNetworks: [String]
    let countryCode: String
    let currencyCode: String
    let paymentAmount: String
}
