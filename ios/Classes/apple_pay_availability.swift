import Flutter
import PassKit

public class ApplePayAvailability: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter.moyasar.com/apple_pay", binaryMessenger: registrar.messenger())
    let instance = ApplePayAvailability()
    registrar.addMethodCallDelegate(instance, channel: channel)
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
    return PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: supportedNetworks.map { PKPaymentNetwork(rawValue: $0) })
  }
}