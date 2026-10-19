import Flutter
import PassKit

/// Keep the originating channel and controller alive until both the sheet and
/// payment processing finish. Dismissing a sheet does not cancel an HTTP request.
private final class ApplePaySession {
    let controller: PKPaymentAuthorizationController
    let channel: FlutterMethodChannel
    var state = ApplePaySessionState()
    var presentationError: String?

    init(controller: PKPaymentAuthorizationController, channel: FlutterMethodChannel) {
        self.controller = controller
        self.channel = channel
    }
}

class ApplePayPaymentHandler: NSObject {

    private var session: ApplePaySession?

    func presentApplePay(applePayConfig: Any?, channel: FlutterMethodChannel) {
        // The plugin has one handler for all buttons, so this also prevents
        // overlapping payments started from different checkout widgets.
        guard session == nil else { return }
        guard let applePayConfigData = (applePayConfig as? String)?.data(using: .utf8), let config = try? JSONDecoder().decode(ApplePayConfig.self, from: applePayConfigData) else {
            channel.invokeMethod("onApplePayError", arguments: "Invalid Apple Pay configuration. No payment was submitted.")
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

        let networks = config.supportedNetworks.compactMap { PKPaymentNetwork.fromString($0) }
        let capabilities = PKMerchantCapability(config.merchantCapabilities.compactMap { PKMerchantCapability.fromString($0) })
        // Invalid requests can raise a PassKit exception rather than return a
        // presentation error. Reject them before creating the controller.
        guard amount != .notANumber, amount.compare(NSDecimalNumber.zero) == .orderedDescending,
              !config.merchantIdentifier.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              !config.paymentLabel.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              config.countryCode.range(of: "^[A-Z]{2}$", options: .regularExpression) != nil,
              config.currencyCode.range(of: "^[A-Z]{3}$", options: .regularExpression) != nil,
              config.supportedCountries.allSatisfy({ $0.range(of: "^[A-Z]{2}$", options: .regularExpression) != nil }),
              !networks.isEmpty, capabilities.contains(.threeDSecure) else {
            channel.invokeMethod("onApplePayError", arguments: "Invalid Apple Pay payment request. Check the amount, merchant, countries, currency and capabilities. No payment was submitted.")
            return
        }

        request.paymentSummaryItems = [PKPaymentSummaryItem(label: config.paymentLabel, amount: amount, type: .final)]
        request.merchantIdentifier = config.merchantIdentifier
        request.countryCode = config.countryCode
        request.currencyCode = config.currencyCode
        request.supportedNetworks = networks
        request.merchantCapabilities = capabilities
        // An empty list means no issuer-country restriction.
        request.supportedCountries = config.supportedCountries.isEmpty ? nil : Set(config.supportedCountries)

        let controller = PKPaymentAuthorizationController(paymentRequest: request)
        let session = ApplePaySession(controller: controller, channel: channel)
        self.session = session
        controller.delegate = self

        // Dart snapshots the request and callback before we show the sheet.
        // A detached widget must not start a payment with no result listener.
        channel.invokeMethod("onApplePayStarted", arguments: applePayConfig) { response in
            DispatchQueue.main.async {
                guard self.session === session else { return }
                guard response as? Bool == true else {
                    controller.delegate = nil
                    self.session = nil
                    return
                }
                controller.present { presented in
                    DispatchQueue.main.async {
                        guard self.session === session, !presented else { return }
                        session.presentationError = "Could not present Apple Pay. No payment was submitted."
                        session.state.completeDismissal()
                        self.finishIfReady(session)
                    }
                }
            }
        }
    }

    /// Opens Wallet on the add-card screen.
    ///
    /// Used when Apple Pay is supported but no card we accept has been added,
    /// so the user has a way forward instead of a button that can't pay.
    func openApplePaySetup() {
        PKPassLibrary().openPaymentSetup()
    }

    private func finishIfReady(_ session: ApplePaySession) {
        guard self.session === session, let outcome = session.state.takeOutcome() else { return }

        let method = outcome == .payment ? "onApplePayFinished" : "onApplePayError"
        session.channel.invokeMethod(method, arguments: session.presentationError) { _ in
            DispatchQueue.main.async {
                guard self.session === session else { return }
                session.controller.delegate = nil
                self.session = nil
            }
        }
    }
}

extension ApplePayPaymentHandler: PKPaymentAuthorizationControllerDelegate {

    func paymentAuthorizationController(_ controller: PKPaymentAuthorizationController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        let paymentToken = String(decoding: payment.token.paymentData, as: UTF8.self)

        // Flutter channel calls and session mutations must run on the main queue.
        DispatchQueue.main.async {
            guard let session = self.session, session.controller === controller,
                  session.state.submit() else {
                completion(PKPaymentAuthorizationResult(status: .failure, errors: nil))
                return
            }
            session.channel.invokeMethod("onApplePayResult", arguments: ["token": paymentToken]) { response in
                DispatchQueue.main.async {
                    guard self.session === session else { return }
                    session.state.completeProcessing()
                    // Token creation is not payment success. Dart replies only
                    // after Moyasar has returned a payment status or an error.
                    let status: PKPaymentAuthorizationStatus = response as? Bool == true ? .success : .failure
                    completion(PKPaymentAuthorizationResult(status: status, errors: nil))
                    self.finishIfReady(session)
                }
            }
        }
    }

    func paymentAuthorizationControllerDidFinish(_ controller: PKPaymentAuthorizationController) {
        DispatchQueue.main.async {
            guard let session = self.session, session.controller === controller,
                  session.state.beginDismissal() else { return }
            controller.dismiss {
                DispatchQueue.main.async {
                    guard self.session === session else { return }
                    session.state.completeDismissal()
                    self.finishIfReady(session)
                }
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
        case "unionpay":
            return .chinaUnionPay
        default:
            return nil
        }
    }
}
