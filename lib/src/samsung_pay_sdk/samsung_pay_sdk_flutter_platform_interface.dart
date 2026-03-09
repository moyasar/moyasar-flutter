import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'model/add_card_info.dart';
import 'model/custom_sheet.dart';
import 'model/custom_sheet_payment_info.dart';
import 'model/partner_info.dart';
import 'model/payment_card_info.dart';
import 'samsung_pay_listener.dart';
import 'samsung_pay_sdk_flutter_method_channel.dart';

abstract class SamsungPaySdkFlutterPlatform extends PlatformInterface {
  /// Constructs a SamsungPaySdkFlutterPlatform.
  SamsungPaySdkFlutterPlatform() : super(token: _token);

  static final Object _token = Object();

  static SamsungPaySdkFlutterPlatform _instance = MethodChannelSamsungPaySdkFlutter();

  /// The default instance of [SamsungPaySdkFlutterPlatform] to use.
  ///
  /// Defaults to [MethodChannelSamsungPaySdkFlutter].
  static SamsungPaySdkFlutterPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [SamsungPaySdkFlutterPlatform] when
  /// they register themselves.
  static set instance(SamsungPaySdkFlutterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<bool?> initSamsungPay(PartnerInfo? partnerInfo);
  Future<void> getSamsungPayStatus(StatusListener statusListener);
  Future<void> getWalletInfo(StatusListener statusListener);
  Future<void>goToUpdatePage();
  Future<void>activateSamsungPay();
  Future<void> addCard(AddCardInfo addCardInfo,AddCardListener addCardListener);
  Future<void> getAllCards(GetCardListener getCardListener);
  Future<void> requestCardInfo(PaymentCardInfo paymentCardInfo, CardInfoListener cardInfoListener);
  Future<void> startInAppPayWithCustomSheet(CustomSheetPaymentInfo customSheetPaymentInfo, CustomSheetTransactionInfoListener customSheetTransactionInfoListener);
  Future<void> updateSheet(CustomSheet customSheet, {int? customErrorCode, String? customErrorMessage});
}
