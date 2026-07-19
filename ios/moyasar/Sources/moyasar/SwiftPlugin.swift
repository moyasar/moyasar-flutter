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
       if (call.method == "isApplePayAvailable") {
         guard let args = call.arguments as? [String: Any], let supportedNetworks = args["supportedNetworks"] as? [String] else {
           result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments", details: nil))
           return
         }
    
         result(isApplePayAvailable(supportedNetworks: supportedNetworks))
       } else {
         result(FlutterMethodNotImplemented)
       }
     }
    
    private func isApplePayAvailable(supportedNetworks: [String]) -> Bool {
        // TODO: Check capabilities as well
        return PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: supportedNetworks.compactMap({ PKPaymentNetwork.fromString($0) }))
    }
}

extension SwiftPlugin: ApplePayButtonHandler {
    func onApplePayButtonPressed(applePayConfig: Any?) {
        applePayHandler.presentApplePay(applePayConfig: applePayConfig)
    }
}
