import Flutter
import UIKit
import PassKit

protocol ApplePayButtonHandler: AnyObject {
    func onApplePayButtonPressed(applePayConfig: Any?)
    func onApplePaySetupButtonPressed()
}

class ApplePayViewFactory: NSObject, FlutterPlatformViewFactory {
    private let messenger: FlutterBinaryMessenger
    private var delegate: ApplePayButtonHandler
    
    init(messenger: FlutterBinaryMessenger, delegate: ApplePayButtonHandler) {
        self.messenger = messenger
        self.delegate = delegate
        super.init()
    }
    
    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        return ApplePayView(
            frame: frame,
            viewIdentifier: viewId,
            arguments: args,
            binaryMessenger: messenger,
            delegate: delegate
        )
    }
    
    func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }
}

class ApplePayView: NSObject, FlutterPlatformView {

    private var _view: UIView
    private weak var delegate: ApplePayButtonHandler?
    private let applePayConfig: Any?
    private let availability: ApplePayAvailability

    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        binaryMessenger messenger: FlutterBinaryMessenger,
        delegate: ApplePayButtonHandler
    ) {
        self._view = UIView()
        self.delegate = delegate
        self.applePayConfig = args

        // A config we can't read means we can't build a payment request either,
        // so render nothing rather than a button that could never charge.
        let config = ApplePayView.decodeConfig(from: args)
        self.availability = config
            .map { ApplePayAvailability.current(supportedNetworks: $0.supportedNetworks) }
            ?? .notSupported

        super.init()
        createAndLoadApplePayButton(config: config)
    }

    @objc func handleApplePayButtonPressed() {
        switch availability {
        case .ready:
            delegate?.onApplePayButtonPressed(applePayConfig: applePayConfig)
        case .needsSetup:
            delegate?.onApplePaySetupButtonPressed()
        case .notSupported:
            break
        }
    }

    func view() -> UIView {
        return _view
    }

    func createAndLoadApplePayButton(config: ApplePayConfig?) {
        guard availability != .notSupported else { return }

        // Offer card setup instead of a pay button the user couldn't complete.
        let buttonType: PKPaymentButtonType = availability == .needsSetup
            ? .setUp
            : PKPaymentButtonType.fromString(config?.buttonType)

        let applePayButton = PKPaymentButton(
            paymentButtonType: buttonType,
            paymentButtonStyle: PKPaymentButtonStyle.fromString(config?.buttonStyle)
        )

        applePayButton.translatesAutoresizingMaskIntoConstraints = false
        applePayButton.addTarget(self, action: #selector(handleApplePayButtonPressed), for: .touchUpInside)
        _view.addSubview(applePayButton)

        NSLayoutConstraint.activate([
            applePayButton.topAnchor.constraint(equalTo: _view.topAnchor),
            applePayButton.bottomAnchor.constraint(equalTo: _view.bottomAnchor),
            applePayButton.leftAnchor.constraint(equalTo: _view.leftAnchor),
            applePayButton.rightAnchor.constraint(equalTo: _view.rightAnchor)
        ])
    }

    private static func decodeConfig(from config: Any?) -> ApplePayConfig? {
        guard let configData = (config as? String)?.data(using: .utf8) else {
            return nil
        }

        return try? JSONDecoder().decode(ApplePayConfig.self, from: configData)
    }
}

internal extension PKPaymentButtonType {
    static func fromString(_ type: String?) -> PKPaymentButtonType {
        switch type {
        case "plain": return .plain
        case "buy": return .buy
        case "setUp": return .setUp
        case "inStore": return .inStore
        case "donate": return .donate
        case "checkout": return .checkout
        case "book": return .book
        case "subscribe": return .subscribe
        case "reload":
            guard #available(iOS 15.0, *) else { return .inStore }
            return .reload
        case "addMoney":
            guard #available(iOS 15.0, *) else { return .inStore }
            return .addMoney
        case "topUp":
            guard #available(iOS 15.0, *) else { return .inStore }
            return .topUp
        case "order":
            guard #available(iOS 15.0, *) else { return .inStore }
            return .order
        case "rent":
            guard #available(iOS 15.0, *) else { return .inStore }
            return .rent
        case "support":
            guard #available(iOS 15.0, *) else { return .inStore }
            return .support
        case "contribute":
            guard #available(iOS 15.0, *) else { return .inStore }
            return .contribute
        case "tip":
            guard #available(iOS 15.0, *) else { return .inStore }
            return .tip
        default: return .inStore
        }
    }
}

internal extension PKPaymentButtonStyle {
    static func fromString(_ style: String?) -> PKPaymentButtonStyle {
        switch style {
        case "white": return .white
        case "whiteOutline": return .whiteOutline
        case "black": return .black
        case "automatic":
            guard #available(iOS 14.0, *) else { return .black }
            return .automatic
        default: return .black
        }
    }
}
