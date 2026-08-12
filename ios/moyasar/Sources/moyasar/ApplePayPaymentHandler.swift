import Flutter
import PassKit

/// Tracks progress through a single Apple Pay session so `paymentAuthorizationControllerDidFinish`
/// can tell a user cancellation / failed authorization (report `onApplePayError`) apart from a
/// sheet dismissal that follows a successful `onApplePayResult` (no further callback needed).
private enum ApplePaySessionStatus {
    case started, presented, authorizationStarted, authorized
}

class ApplePayPaymentHandler: NSObject {

    private var controller: PKPaymentAuthorizationController?
    private let channel: FlutterMethodChannel
    private var sessionStatus: ApplePaySessionStatus = .started

    init(channel: FlutterMethodChannel) {
        self.channel = channel
    }

    func presentApplePay(applePayConfig: Any?) {
        guard let applePayConfigData = (applePayConfig as? String)?.data(using: .utf8), let config = try? JSONDecoder().decode(ApplePayConfig.self, from: applePayConfigData) else {
            channel.invokeMethod("onApplePayError", arguments: nil)
            return
        }

        let request = PKPaymentRequest()

        // The amount always crosses the channel with a "." separator, so parse it
        // with a fixed one — the device locale would misread it where "," is the
        // decimal mark, charging the wrong amount.
        let amount = NSDecimalNumber(
            string: config.paymentAmount,
            locale: ["NSLocaleDecimalSeparator": "."]
        )

        request.paymentSummaryItems = [PKPaymentSummaryItem(label: config.paymentLabel, amount: amount, type: .final)]
        request.merchantIdentifier = config.merchantIdentifier
        request.countryCode = config.countryCode
        request.currencyCode = config.currencyCode
        request.supportedNetworks = config.supportedNetworks.compactMap({ PKPaymentNetwork.fromString($0) })
        request.merchantCapabilities = PKMerchantCapability(config.merchantCapabilities.compactMap({ PKMerchantCapability.fromString($0) }))

        sessionStatus = .started
        controller = PKPaymentAuthorizationController(paymentRequest: request)
        controller?.delegate = self
        controller?.present(completion: { [weak self] presented in
            if presented {
                self?.sessionStatus = .presented
            } else {
                self?.channel.invokeMethod("onApplePayError", arguments: nil)
            }
        })
    }

    /// Opens Wallet on the add-card screen.
    ///
    /// Used when Apple Pay is supported but no card we accept has been added,
    /// so the user has a way forward instead of a button that can't pay.
    func openApplePaySetup() {
        PKPassLibrary().openPaymentSetup()
    }
}

extension ApplePayPaymentHandler: PKPaymentAuthorizationControllerDelegate {

    func paymentAuthorizationControllerWillAuthorizePayment(_ controller: PKPaymentAuthorizationController) {
        sessionStatus = .authorizationStarted
    }

    func paymentAuthorizationController(_ controller: PKPaymentAuthorizationController, didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {
        let paymentToken = String(decoding: payment.token.paymentData, as: UTF8.self)

        sessionStatus = .authorized
        channel.invokeMethod("onApplePayResult", arguments: [ "token": paymentToken ] )
        completion(.success)
    }

    func paymentAuthorizationControllerDidFinish(_ controller: PKPaymentAuthorizationController) {
        let sessionStatus = self.sessionStatus

        controller.dismiss {
            // Only report an error if the sheet closed without a successful authorization
            // (user canceled, or authorization started but didn't complete).
            if sessionStatus != .authorized {
                self.channel.invokeMethod("onApplePayError", arguments: nil)
            }
        }
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
