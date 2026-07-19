import Flutter
import PassKit

class ApplePayPaymentHandler: NSObject {
    
    private var controller: PKPaymentAuthorizationController?
    private let channel: FlutterMethodChannel
    
    init(channel: FlutterMethodChannel) {
        self.channel = channel
    }
    
    func presentApplePay(applePayConfig: Any?) {
        guard let applePayConfigData = (applePayConfig as? String)?.data(using: .utf8), let config = try? JSONDecoder().decode(ApplePayConfig.self, from: applePayConfigData) else {
            channel.invokeMethod("onApplePayError", arguments: nil)
            return
        }
        
        let request = PKPaymentRequest()
        
        request.paymentSummaryItems = [PKPaymentSummaryItem(label: config.paymentLabel, amount: NSDecimalNumber(string: config.paymentAmount) , type: .final)]
        request.merchantIdentifier = config.merchantIdentifier
        request.countryCode = config.countryCode
        request.currencyCode = config.currencyCode
        request.supportedNetworks = config.supportedNetworks.compactMap({ PKPaymentNetwork.fromString($0) })
        request.merchantCapabilities = PKMerchantCapability(config.merchantCapabilities.compactMap({ PKMerchantCapability.fromString($0) }))
        
        controller = PKPaymentAuthorizationController(paymentRequest: request)
        controller?.delegate = self
        controller?.present()
    }
}

extension ApplePayPaymentHandler: PKPaymentAuthorizationControllerDelegate {
    
    func paymentAuthorizationController(_ controller: PKPaymentAuthorizationController, didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {
        let paymentToken = String(decoding: payment.token.paymentData, as: UTF8.self)
        
        channel.invokeMethod("onApplePayResult", arguments: [ "token": paymentToken ] )
        completion(.success)
    }
    
    func paymentAuthorizationControllerDidFinish(_ controller: PKPaymentAuthorizationController) {
        // TODO: Handle cancelled payment by the user
        controller.dismiss()
    }
}

internal extension PKMerchantCapability {
    
    static func fromString(_ capability: String) -> PKMerchantCapability? {
        switch capability {
        case "3DS":
            return .threeDSecure
        case "EMV":
            return .emv
        case "credit":
            return .credit
        case "debit":
            return .debit
        case "instantFundsOut":
            guard #available(iOS 17.0, *) else { return nil }
            return .instantFundsOut
        default:
            return nil
        }
    }
}

internal extension PKPaymentNetwork {
    
    static func fromString(_ paymentNetwork: String) -> PKPaymentNetwork? {
        switch paymentNetwork {
        case "amex":
            return .amex
        case "mada":
            guard #available(iOS 12.1.1, *) else { return nil }
            return .mada
        case "masterCard":
            return .masterCard
        case "visa":
            return .visa
        default:
            return nil
        }
    }
}
