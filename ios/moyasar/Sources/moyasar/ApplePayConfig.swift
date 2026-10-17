public struct ApplePayConfig: Codable {
    let merchantIdentifier: String
    let paymentLabel: String
    let merchantCapabilities: [String]
    let supportedNetworks: [String]
    let supportedCountries: [String]
    let countryCode: String
    let currencyCode: String
    let paymentAmount: String
    let callbackChannel: String
    let buttonType: String?
    let buttonStyle: String?
}
