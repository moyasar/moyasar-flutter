import Flutter
import UIKit
import PassKit

protocol ApplePayButtonHandler: AnyObject {
    func onApplePayButtonPressed(applePayConfig: Any?)
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
        
        super.init()
        createAndLoadApplePayButton()
    }
    
    @objc func handleApplePayButtonPressed() {
        delegate?.onApplePayButtonPressed(applePayConfig: applePayConfig)
    }
    
    func view() -> UIView {
        return _view
    }
    
    func createAndLoadApplePayButton() {
        let applePayButton = PKPaymentButton(
            paymentButtonType: .inStore,
            paymentButtonStyle: .black
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
}
