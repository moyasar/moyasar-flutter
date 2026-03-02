import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:samsung_pay_sdk_flutter/model/payment_card_info.dart';
import 'package:samsung_pay_sdk_flutter/samsung_pay_sdk_flutter_method_channel.dart';
import 'model/custom_sheet.dart';
import 'model/custom_sheet_payment_info.dart';
import 'samsung_pay_sdk_flutter.dart';
import 'samsung_pay_sdk_flutter_platform_interface.dart';

export 'spay_core.dart';
export 'samsung_pay_listener.dart';
export 'model/add_card_info.dart';
export 'model/partner_info.dart';
export 'model/wallet_card.dart';
///
/// This class provides APIs to get the Samsung Pay status on the device.
//  Also, this class provides APIs to activate Samsung Pay on the device.<br>
//  Partner apps must check the Samsung Pay status on the device
//  before performing any card management or payment operation.
///
class SamsungPaySdkFlutter {

  PartnerInfo? _partnerInfo;
  SamsungPaySdkFlutterPlatform? methodChannelSamsungPaySdkFlutter;

  ///API to initiate Samsung Wallet with Partner information .<br>
  ///Partner (Issuers, Merchants, and so on) applications must call this to initiate Samsung Wallet before calling any API.<br>
  SamsungPaySdkFlutter(PartnerInfo partnerInfo){
    _partnerInfo=partnerInfo;
    _initSamsungPay(_partnerInfo);
  }

  Future<bool?>? _initSamsungPay(PartnerInfo? partnerInfo) {
    methodChannelSamsungPaySdkFlutter = SamsungPaySdkFlutterPlatform.instance = MethodChannelSamsungPaySdkFlutter();
    return methodChannelSamsungPaySdkFlutter?.initSamsungPay(partnerInfo);
  }

  ///API to get the Samsung Pay status on the device.<br>
  ///Partner (Issuers, Merchants, and so on) applications must call this API to
  ///check the current state of Samsung Wallet before doing any operation.<br>
  ///
  ///<b>[Parameter listener]</b><br>
  ///    Callback through which the result is provided.<br><br>
  ///
  ///    On success, Samsung Pay status code is provided via [StatusListener.onSuccess]
  ///    If Samsung Wallet is ready to be used, [SpaySdk.SPAY_READY] will be returned.<br>
  ///    Otherwise, [SpaySdk.SPAY_NOT_READY] or [SpaySdk.SPAY_NOT_SUPPORTED]
  ///    or [SpaySdk.SPAY_NOT_ALLOWED_TEMPORALLY] can be returned
  ///    with [SpaySdk.EXTRA_ERROR_REASON] from Bundle.<br><br>
  ///
  ///    Also, partner can get extra information from Bundle data.<br>
  ///    <table>
  ///        <tr style="border:1px solid black;">
  ///            <th style="border:1px solid black;">Bundle Keys(if provided)</th>
  ///            <th style="border:1px solid black;">Bundle Values</th>
  ///        </tr>
  ///        <tr style="border:1px solid black;">
  ///            <th style="border:1px solid black;">[SpaySdk.EXTRA_COUNTRY_CODE]</th>
  ///            <th style="border:1px solid black;">Device Country code(ISO 3166-1 alpha-2)</th>
  ///        </tr>
  ///        <tr style="border:1px solid black;">
  ///            <th style="border:1px solid black;">[SpaySdk.EXTRA_MEMBER_ID]</th>
  ///            <th style="border:1px solid black;">String memberID (for Korean issuers only)</th>
  ///        </tr>
  ///    </table>
  ///    On any failure, the failure code is provided via [StatusListener.onFail].<br><br>
  ///
  ///    [Note]
  ///    Please refer [SpaySdk.COMMON_STATUS_TABLE] in detail.<br>
  ///
  ///Throws NullPointerException
  ///            Thrown if the callback passed is null.
  ///

  void getSamsungPayStatus(StatusListener statusListener) {
    try{
      methodChannelSamsungPaySdkFlutter?.getSamsungPayStatus(statusListener);
    }on PlatformException catch(e){
      if (kDebugMode) {
        print(e);
      }
    }
  }

  /// API to get the requested wallet information from Samsung Wallet.<br>
  /// Partner app can use this information to uniquely identify the user
  /// and Samsung Wallet app on a particular device.
  ///
  /// Parameters:<br>
  ///  [listener]
  ///            Callback through which the result is provided. <br>
  ///            On success, [StatusListener.onSuccess(status: Int, walletData: Bundle)] is
  ///            invoked with wallet information. <br>
  ///
  /// <table>
  ///     <tr style="border:1px solid black;">
  ///         <th style="border:1px solid black;" rowspan="2">Status</th>
  ///         <th style="border:1px solid black;" rowspan="2">Bundle Keys</th>
  ///         <th style="border:1px solid black;" rowspan="2">Bundle Values</th>
  ///         <th style="border:1px solid black;" colspan="2">USAGE</th>
  ///     </tr>
  ///     <tr style="border:1ps solid black;">
  ///         <td style="border:1px solid black;">VTS</td>
  ///         <td style="border:1px solid black;">MDES</td>
  ///     </tr>
  ///     <tr style="border:1px solid black;">
  ///         <td style="border:1px solid black;" rowspan="3">[SpaySdk.ERROR_NONE]</td>
  ///         <td style="border:1px solid black;">[SpaySdk.WALLET_DM_ID]</td>
  ///         <td style="border:1px solid black;">String Device Management ID</td>
  ///         <td style="border:1px solid black;">N/A</td>
  ///         <td style="border:1px solid black;" rowspan="3">paymentAppInstanceId = DEVICE_ID + Padding("00") + WALLET_DM_ID<br>
  ///         (*If you need 'paymentAppInstanceId', you can generate it as above)</td>
  ///     </tr>
  ///     <tr style="border:1px solid black;">
  ///         <td style="border:1px solid black;">[SpaySdk.DEVICE_ID]</td>
  ///         <td style="border:1px solid black;">String Device ID</td>
  ///         <td style="border:1px solid black;">clientDeviceID</td>
  ///     </tr>
  ///     <tr style="border:1px solid black;">
  ///         <td style="border:1px solid black;">[SpaySdk.WALLET_USER_ID]</td>
  ///         <td style="border:1px solid black;">String Wallet User ID</td>
  ///         <td style="border:1px solid black;">clientWalletAccountID</td>
  ///     </tr>
  /// </table>
  /// <br>
  ///            On any failure, the error code is provided via [StatusListener.onFail: (errorCode, bundle)].<br><br>
  ///
 ///  [Note]
  ///     Please refer [SpaySdk.COMMON_STATUS_TABLE] in details.<br>
  ///
  /// <b>[Exceptions]:</b><br>
  /// Throws an [ArgumentError] if parameters are null.
  ///
  Future<void> getWalletInfo(StatusListener statusListener) async {
    try{
      methodChannelSamsungPaySdkFlutter?.getWalletInfo(statusListener);
    }on PlatformException catch(e){
      if (kDebugMode) {
        print(e);
      }
    }
  }

  ///
  /// API to go to Samsung Pay update page.<br>
  /// Partner app checks the Samsung Pay status with
  /// [getSamsungPayStatus(StatusListener statusListener)] API.<br><br>
  ///
  /// If the status is [SpaySdk.SPAY_NOT_READY] and
  /// [SpaySdk.EXTRA_ERROR_REASON] is [SpaySdk.ERROR_SPAY_APP_NEED_TO_UPDATE],<br>
  /// partner app can call this API to go to update Samsung Wallet app.<br><br>
  ///
  /// If Samsung Wallet App version is same or bigger than 2.1.00, it goes to "About SamsungPay" menu.<br>
  /// If Samsung Wallet App version is lower than 2.1.00 or KR device, it launches Samsung Wallet App main screen.
  ///
  Future<void> goToUpdatePage()async{
    await methodChannelSamsungPaySdkFlutter?.goToUpdatePage();
  }

  ///
  /// API to bring the Samsung Wallet app to a state in which cards can be added.<br>
  /// Samsung Pay might be either in stub only state or Samsung Account is not signed in state.<br>
  /// Partner app checks the Samsung Pay status with
  /// [getSamsungPayStatus(StatusListener statusListener)] API.<br><br>
  ///
  /// If the status is [SpaySdk.SPAY_NOT_READY] and
  /// [SpaySdk.EXTRA_ERROR_REASON] is [SpaySdk.ERROR_SPAY_SETUP_NOT_COMPLETED],<br>
  /// partner app can call this API to launch Samsung Pay and user can sign in to the app.<br>
  ///
  Future<void> activateSamsungPay() async{
    await methodChannelSamsungPaySdkFlutter?.activateSamsungPay();
  }
  ///
  /// API to add a card from partner app (example: issuer/bank app) to Samsung Pay.<br>
  /// Partner app uses this API to add card to Samsung Pay by providing the required card details.
  /// This helps user to add their cards to Samsung Pay directly from partner app.
  ///
  void addCard(AddCardInfo addCardInfo,AddCardListener addCardListener) {
    try{
      methodChannelSamsungPaySdkFlutter?.addCard(addCardInfo,addCardListener);
    }on PlatformException catch(e){
      if (kDebugMode) {
        print(e);
      }
    }
  }

  ///
  /// API to get all the cards from Samsung Pay for the given filter. <br>
  ///
  /// Since API level 2.13, [SamsungPaySdkFlutter.getAllCards] would return
  /// a card list in which a [WalletCard] of [SpaySdk.Brand.VISA] brand would hold
  /// a Token Reference ID as its [WalletCard.cardId] instead of a Provisioned Token ID in earlier API level.<br>
  ///
  /// Since API level 1.4, partner must define issuer names as a card filter
  /// on Samsung Pay Developers while on-boarding.
  ///
  /// <table>
  ///     <tr style="border:1px solid black;">
  ///         <th style="border:1px solid black;">Keys</th>
  ///         <th style="border:1px solid black;">Values</th>
  ///     </tr>
  ///     <tr style="border:1px solid black;">
  ///         <td style="border:1px solid black;">[SpaySdk.EXTRA_ISSUER_NAME]</td>
  ///         <td style="border:1px solid black;">String issuerName (issuerCode for Korean issuers)</td>
  ///     </tr>
  /// </table>
  /// <br>
  ///
  /// Parameter listener
  ///            Callback through which the result is provided. <br>
  ///            On success, [GetCardListener.onSuccess] is
  ///            invoked with list of Cards. <br><br>
  ///            On any failure, the error code is provided via
  ///            [GetCardListener.onFail].<br><br>
  ///
  /// [Note]
  ///     Please refer [SpaySdk.COMMON_STATUS_TABLE] for other status.<br>
  ///
  /// Throws NullPointerException
  ///            Thrown if listener is null.
  ///
  ///
  void getAllCards(GetCardListener getCardListener) {
    try{
      methodChannelSamsungPaySdkFlutter?.getAllCards(getCardListener);
    }on PlatformException catch(e){
      if (kDebugMode) {
        print(e);
      }
    }
  }


  /// API to request card information of the available cards for payment using Samsung Wallet.<br>
  ///
  /// The partner app can use this API to query available cards (user already has registered) in
  /// Samsung Wallet and decide whether to display Samsung Pay button or not on their application.<br>
  /// For example, if merchant app supports only one specific card brand, but the user has not registered
  /// any card with the brand, then merchant app decides not to display the Samsung Pay button
  /// with this query.<br><br>
  ///
  /// <b>[Parameters]:</b><br>
  /// [requestFilter]
  ///             Filter to limit return cardInfo list. This is optional parameter. If the caller does
  ///             not set any value, all the cards which are available for online (in-app) payment
  ///             on Samsung Wallet are returned.
  /// [listener]
  ///            Callback through which the result is provided.<br>
  ///            On success, [CardInfoListener.onResult(List)] is invoked with CardInfo list.<br><br>
  ///            On any failure, the failure code is provided via [CardInfoListener.onFailure(int, Bundle)].<br><br>
  ///[Note]
  ///       Please refer [SpaySdk.COMMON_STATUS_TABLE] for other status.<br>
  ///
  /// <b>[Exceptions]:</b><br>
  /// Throws an [ArgumentError] if the CardInfoListener is null.
  ///
  void requestCardInfo(PaymentCardInfo paymentCardInfo, CardInfoListener cardInfoListener){
    try{
      methodChannelSamsungPaySdkFlutter?.requestCardInfo(paymentCardInfo, cardInfoListener);
    }on PlatformException catch(e){
      print(e);
    }
  }


  /// API to request online(in-app) payment with Samsung Wallet. <br>
  /// Partner app can use this API to make in-app purchase using Samsung Wallet from their
  /// application with custom payment sheet.<br>
  ///
  ///<b>[Parameters]:</b><br>
  ///
  /// [customSheetPaymentInfo]
  ///            Custom sheet and payment information from partner app(merchant app).
  /// [listener]
  ///            Callback through which the result is provided. <br>
  ///            On success, [CustomSheetTransactionInfoListener.onSuccess]
  ///            is invoked with payment credential.<br>
  ///            [CustomSheetTransactionInfoListener.onCardInfoUpdated] is
  ///            invoked when user changes the card on the payment sheet in Samsung Wallet.<br><br>
  ///            On any failure, the failure error code and error data are provided via
  ///            [CustomSheetTransactionInfoListener.onFailure].<br>
  ///            The failure code can be one of the following codes with bundle data:
  /// <table>
  ///     <tr style="border:1px solid black;">
  ///         <th style="border:1px solid black;">Status</th>
  ///     </tr>
  ///     <tr style="border:1px solid black;">
  ///         <td style="border:1px solid black;">[SpaySdk.ERROR_USER_CANCELED] (-7)</td>
  ///     </tr>
  ///     <tr style="border:1px solid black;">
  ///         <td style="border:1px solid black;">[SpaySdk.ERROR_DUPLICATED_SDK_API_CALLED] (-105)</td>
  /// </table>
  ///
  /// [Note]
  ///     Please refer [SpaySdk.COMMON_STATUS_TABLE] for other status.<br>
  ///
  /// <b>[Exceptions]:</b><br>
  /// Throws an [ArgumentError] if parameters are null.
  /// Throws an [ArgumentError] if Samsung Pay SDK Service is not available.
  /// Throws an [ArgumentError] if mandatory custom sheet information and payment information values are not set.
  ///
  void startInAppPayWithCustomSheet(CustomSheetPaymentInfo customSheetPaymentInfo,CustomSheetTransactionInfoListener customSheetTransactionInfoListener){
    try{
      methodChannelSamsungPaySdkFlutter?.startInAppPayWithCustomSheet(customSheetPaymentInfo, customSheetTransactionInfoListener);
    }on PlatformException catch(e){
      print(e);
    }
  }

  /// API to update sheet on the custom payment sheet.<br><br>
  ///
  ///<b>[Parameters]:</b><br>
  /// [sheet]
  ///            CustomSheet is to be updated.
  ///
  /// <b>[Exceptions]:</b><br>
  /// Throws an [ArgumentError] if service is disconnected.
  /// Throws an [ArgumentError] if the sheetControl is null.
  ///
  void updateSheet(CustomSheet customSheet, {int? customErrorCode, String? customErrorMessage}) {
    if(customErrorCode==null && customErrorMessage==null)
    {
      methodChannelSamsungPaySdkFlutter?.updateSheet(customSheet);
    }
    else if(customErrorCode!=null && customErrorMessage!=null)
    {
      methodChannelSamsungPaySdkFlutter?.updateSheet(customSheet, customErrorCode: customErrorCode, customErrorMessage: customErrorMessage);
    }
    else
    {
      throw Exception("You must set errorCode and errorMessage.");
    }
  }
}
