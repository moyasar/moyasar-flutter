
import 'package:samsung_pay_sdk_flutter/model/wallet_card.dart';

import 'model/custom_sheet.dart';
import 'model/custom_sheet_payment_info.dart';
import 'model/payment_card_info.dart';

/// The requested operation status is returned via this listener.<br>
/// Upon on success, status and extra data (if any) will be returned via onSuccess callback.<br>
/// On any failure, the error code and error reason is provided along with failure callback.<br>
///
/// See [getSamsungPayStatus(StatusListener)]<br>
/// See [getWalletInfo(List, StatusListener)]<br>
/// See [startSimplePay(CardInfo, StatusListener)]<br>
///

class StatusListener{
  /// Invoked when request operation is success.<br>
  ///
  ///<b>[Parameters]:</b><br>
  /// [status]
  ///          Status code of the request.<br>
  ///          Refer to each of the APIs for details.
  ///
  /// [bundle]
  ///          Extra data(if any) related to request.<br>
  ///          Extra data differs from APIs.
  ///
  ///
  Function(String status, Map<String, dynamic> bundle) onSuccess;
  /// Invoked when request operation has failed.<br>
  ///
  /// <b>[Parameters]:</b><br>
  ///  [errorCode]
  ///            Failure reason. <br>
  ///            Refer to each of the APIs for details.
  ///
  /// [bundle]
  ///            Extra data(if any) related to request.<br>
  ///            Extra data differs from APIs.
  ///
  ///
  Function(String errorCode, Map<String, dynamic> bundle) onFail;
  StatusListener({required this.onSuccess, required this.onFail});
}

///
/// The requested add card operation status is returned via this listener.<br>
///
/// See [addCard(AddCardInfo addCardInfo,AddCardListener addCardListener)]<br>
///

class AddCardListener{
  /// Invoked when request operation is success.<br>
  ///
  /// <b>[Parameters]:</b><br>
  /// [status]
  ///          Added card status. <br>
  ///
  /// [card]
  ///          Added card information.
  ///
  Function(String status, Map<String, dynamic> card) onSuccess;
  /// Invoked when request operation has failed.<br>
  ///
  ///  <b>[Parameters]:</b><br>
  ///  [errorCode]
  ///            Failure reason. <br>
  ///
  /// [bundle]
  ///            Extra data(if any) related to request failure.<br>
  ///
  Function(String errorCode, Map<String, dynamic> bundle) onFail;
  /// Invoked when progress is updated.<br>
  /// In case of TSM solution, it takes time for card provisioning.
  /// While provisioning, issuer app can use the progress information to show on the progress bar.<br>
  ///
  ///  <b>[Parameters]:</b><br>
  ///  [currentCount]
  ///            Current step count if needed.
  ///
  /// [totalCount]
  ///            Total step count if needed.
  ///
  /// [bundle]
  ///            Extra data(if any) related to progress if needed.<br>
  ///
  Function(String currentCount, String totalCount, Map<String, dynamic> bundle) onProgress;
  AddCardListener({required this.onSuccess, required this.onFail, required this.onProgress});
}

///
/// The requested getAllCards operation status is returned via this listener.<br>
///
/// See [getAllCards((GetCardListener getCardListener)]
///

class GetCardListener{
  /// Invoked when request operation is success.<br>
  ///
  /// See [WalletCard]
  ///
  ///<b>[Parameters]:</b><br>
  /// [cards]
  ///            List of cards and its status. <br>
  ///
  Function(List<WalletCard> card) onSuccess;
  /// Invoked when request operation has failed.<br>
  ///
  /// <b>[Parameters]:</b><br>
  /// [errorCode]
  ///            Failure reason. <br>
  ///
  /// [bundle]
  ///            Extra data(if any) related to request.<br>
  ///
  Function(String errorCode, Map<String,dynamic> bundle) onFail;
  GetCardListener({required this.onSuccess, required this.onFail});
}
/// This listener is for listening requestCardInfo() callback events.
///
/// [requestCardInfo(PaymentCardInfo paymentCardInfo, CardInfoListener cardInfoListener)]
///

class CardInfoListener{
  /// This callback is received when the card information is received successfully.
  ///
  /// <b>[Parameters]:</b><br>
  /// [paymentCardInfo]
  ///            PaymentCardInfo List.
  ///            Null, if Samsung Pay does not have any card for online.
  ///            payment.<br>
  ///            Otherwise, card list of supported card brands is returned.
  ///
  Function(List<PaymentCardInfo> paymentCardInfo) onResult;
  /// This callback is received when the card information cannot be retrieved.<br>
  /// For example, when Plugin service in the Samsung Wallet app dies abnormally.
  ///
  /// <b>[Parameters]:</b><br>
  /// [errorCode]
  ///            Error code, the reason for failure.<br>
  ///
  /// [bundle]
  ///            Extra Error Data provided by Samsung Pay. <br>
  Function(String errorCode, Map<String, dynamic> bundle) onFailure;
  CardInfoListener({required this.onResult, required this.onFailure});
}

/// This interface is for listening callback events of online (in-app) custom sheet payment.<br>
/// This is invoked when card is changed by the user on the custom payment sheet,
/// and also with the success or failure of online (in-app) payment.<br>
///
/// This listener is registered when
/// [startInAppPayWithCustomSheet(CustomSheetPaymentInfo customSheetPaymentInfo,CustomSheetTransactionInfoListener customSheetTransactionInfoListener)]
/// API is called.<br><br>
///
/// [Caution]: AmountBoxControl must be returned in onCardInfoUpdated() on SheetUpdatedListener
/// to remove progress bar on custom payment sheet.
///
/// [startInAppPayWithCustomSheet(CustomSheetPaymentInfo customSheetPaymentInfo,CustomSheetTransactionInfoListener customSheetTransactionInfoListener)]
///

class CustomSheetTransactionInfoListener{
  /// This callback is received when the user changes card on the custom payment sheet in
  /// Samsung Pay.<br>
  /// In this callback, updateSheet() method must be called to update current payment sheet.
  ///
  /// See [updateSheet(CustomSheet customSheet, {int? customErrorCode, String? customErrorMessage})]<br>
  ///
  /// <b>[Parameters]:</b><br>
  /// [paymentCardInfo]
  ///            Currently selected card's information.
 ///
  Function(PaymentCardInfo paymentCardInfo, CustomSheet customSheet) onCardInfoUpdated;
  /// This callback is received when the online (in-app) payment transaction is approved by
  /// user and able to successfully generate in-app payload. The payload could be an
  /// encrypted cryptogram (direct in-app payment) or Payment Gateway's token reference ID
  /// (indirect in-app payment).
  ///
  /// <b>[Parameters]:</b><br>
  /// [customSheetPaymentInfo]
  ///              Online payment information from Samsung Pay.<br>
  ///              Since API level 1.5, {@link SpaySdk#EXTRA_LAST4_FPAN} and {@link SpaySdk#EXTRA_LAST4_DPAN} of the card
  ///              which was used for the current transaction is included in CardInfo.
  /// [paymentCredential]
  ///              Payment Credentials. Example: Cryptogram, AID (direct in-app payment), or
  ///              tokenRefId (indirect in-app payment).
  /// [extraPaymentData]
  ///              Additional payment credentials if any.
  ///
  Function(CustomSheetPaymentInfo customSheetPaymentInfo, String paymentCredential,  Map<String, dynamic>? extraPaymentData) onSuccess;
  /// This callback is received when the online payment transaction has failed.
  ///
  /// <b>[Parameters]:</b><br>
  /// [errCode]
  ///            The result code of error cause.<br>
  ///
  /// [bundle]
  ///              Extra error message data, if any, provided by Samsung Pay.<br>
  ///
  /// [Note]
  ///      Please refer [SpaySdk.COMMON_STATUS_TABLE] in detail.<br>
  ///
  Function(String errorCode, Map<String, dynamic> bundle) onFail;
  CustomSheetTransactionInfoListener({required this.onCardInfoUpdated, required this.onSuccess, required this.onFail});
}

/// This listener is for listening SheetControl events.
///
/// See [AddressControl]<br>
/// See [AmountBoxControl]<br>
/// See [PlainTextControl]<br>
/// See [SpinnerControl]<br>
/// See [CustomSheet]<br>
///

class SheetUpdatedListener{
  /// This callback is received when Controls are updated.<br>
  /// In this callback, updateSheet() method must be called to update current payment sheet.
  ///
  /// See [updateSheet(CustomSheet customSheet, {int? customErrorCode, String? customErrorMessage})]<br>
  ///
  /// <b>[Parameters]:</b><br>
  /// [updatedControlId]
  ///        Updated SheetControlId.
  /// [customSheet]
  ///        Updated CustomSheet.
  ///
  Function(String updatedControlId, CustomSheet customSheet) onResult;
  SheetUpdatedListener({required this.onResult});
}