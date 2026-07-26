import Flutter
import PassKit
import UIKit

public class SwiftPlugin: NSObject, FlutterPlugin {
    
    let applePayChannelId = "flutter.moyasar.com/apple_pay"
    let applePayButtonId = "flutter.moyasar.com/apple_pay/button"
    
    private let applePayHandler: ApplePayPaymentHandler
    private let channel: FlutterMethodChannel
    
    init(flutterMessenger: FlutterBinaryMessenger) {
        self.channel = FlutterMethodChannel(name: applePayChannelId, binaryMessenger: flutterMessenger)
        self.applePayHandler = ApplePayPaymentHandler(channel: channel)
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let instance = SwiftPlugin(flutterMessenger: registrar.messenger())
        registrar.addMethodCallDelegate(instance, channel: instance.channel)
        
        let applePayViewFactory = ApplePayViewFactory(messenger: registrar.messenger(), delegate: instance)
        registrar.register(applePayViewFactory, withId: instance.applePayButtonId)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getApplePayAvailability":
            guard let args = call.arguments as? [String: Any],
                  let supportedNetworks = args["supportedNetworks"] as? [String] else {
                result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments", details: nil))
                return
            }

            result(ApplePayAvailability.current(supportedNetworks: supportedNetworks).rawValue)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}

extension SwiftPlugin: ApplePayButtonHandler {
    func onApplePayButtonPressed(applePayConfig: Any?) {
        applePayHandler.presentApplePay(applePayConfig: applePayConfig)
    }

    func onApplePaySetupButtonPressed() {
        applePayHandler.openApplePaySetup()
    }
}
