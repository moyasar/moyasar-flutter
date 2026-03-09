import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:moyasar/src/samsung_pay_sdk/model/address_control.dart';
import 'package:moyasar/src/samsung_pay_sdk/samsung_pay_sdk_flutter.dart';
import 'model/custom_sheet.dart';
import 'model/custom_sheet_payment_info.dart';
import 'model/payment_card_info.dart';
import 'samsung_pay_sdk_flutter_platform_interface.dart';
import 'dart:developer' as developer;

/// An implementation of [SamsungPaySdkFlutterPlatform] that uses method channels.
class MethodChannelSamsungPaySdkFlutter extends SamsungPaySdkFlutterPlatform {
  /// The method channel used to interact with the native platform.

  String TAG = "SPAYSDKFLUTTERPLUGIN:MethodChannel";
  @visibleForTesting
  final methodChannel = const MethodChannel('samsung_pay_sdk_flutter');

  late StatusListener? statusListener;
  late AddCardListener? addCardListener;
  late GetCardListener? getCardListener;
  late CardInfoListener? cardInfoListener;
  late CustomSheetTransactionInfoListener? customSheetTransactionInfoListener;
  SheetUpdatedListener? sheetUpdatedListener;


  MethodChannelSamsungPaySdkFlutter(){
    methodChannel.setMethodCallHandler(dispatchCallback);
  }
  ///@nodoc
  Future<dynamic> dispatchCallback(MethodCall call) async {
    Map<String, dynamic> argumentData= jsonDecode(call.arguments.toString());
    developer.log(name: TAG,jsonEncode(argumentData));
    developer.log(name: TAG, 'dispatchCallback()');
    if(call.method == "samsungPayStatusFlutter"){
      if(argumentData["event"]  == "onSuccess"){
        developer.log(name: TAG, 'method: samsungPayStatusFlutter, event: onSuccess');
        return statusListener?.onSuccess(argumentData['status'].toString(), argumentData['bundle']);
      }else{
        developer.log(name: TAG, 'method: samsungPayStatusFlutter, event: onFail');
        return statusListener?.onFail(argumentData["status"].toString(),argumentData["bundle"]);
      }
    }
    else if(call.method == "addCardFlutter"){
      if(argumentData["event"].toString()  == "onSuccess"){
        developer.log(name: TAG, 'method: addCardFlutter, event: onSuccess');
        addCardListener?.onSuccess(argumentData['status'].toString(), argumentData['card']);
      }else if(argumentData["event"].toString()  == "onFail"){
        developer.log(name: TAG, 'method: addCardFlutter, event: onFail');
        addCardListener?.onFail(argumentData["status"].toString(),argumentData["bundle"]);
      }else{
        developer.log(name: TAG, 'method: addCardFlutter, event: onProgress');
        addCardListener?.onProgress(argumentData['currentCount'].toString(),argumentData['totalCount'].toString(),argumentData['bundle']);
      }
    }
    else if(call.method == "getAllCardsFlutter"){
      if(argumentData["event"].toString()  == "onSuccess"){
        developer.log(name: TAG, 'method: getAllCardsFlutter, event: onSuccess');
        try{
          List<WalletCard> cardList = (argumentData["cardList"] as List).map((e) => WalletCard.fromJson(e)).toList();
          // print(cardList.elementAt(0).cardInfo.cardType);
          getCardListener?.onSuccess(cardList);
        }on Exception catch(e){
          if (kDebugMode) {
            print(e);
          }
        }
      }else{
        developer.log(name: TAG, 'method: getAllCardsFlutter, event: onFail');
        getCardListener?.onFail(argumentData["status"].toString(),argumentData["bundle"]);
      }
    }
    else if(call.method == "requestCardInfoFlutter"){
      if(argumentData["event"].toString()  == "onResult"){
        developer.log(name: TAG, 'method: requestCardInfoFlutter, event: onResult');
        try{
          List<PaymentCardInfo> cardlist = (argumentData["cardList"] as List).map((e) => PaymentCardInfo.fromJson(e)).toList();
          cardInfoListener?.onResult(cardlist);
        }on Exception catch(e){
          if (kDebugMode) {
            print(e);
          }
        }
      }else{
        developer.log(name:TAG, 'method: requestCardInfoFlutter, event: onFailure');
        cardInfoListener?.onFailure(argumentData["errorCode"].toString(),argumentData["bundle"]);
      }
    }else if(call.method == "setSheetUpdatedListenerFlutter"){
      if(argumentData["event"].toString() == "onResult"){
        developer.log(name: TAG, 'method: setSheetUpdatedListenerFlutter, event: onResult');
        try{
          CustomSheet customSheet = CustomSheet.fromJson(argumentData["customSheet"], sheetUpdatedListener);
          sheetUpdatedListener?.onResult(argumentData["updatedControlId"].toString(),customSheet);
        }on Exception catch (e){
          print(e.toString());
        }
      }
    }else if(call.method == "startInAppPayWithCustomSheetFlutter"){
      if(argumentData["event"].toString() == "onCardInfoUpdated"){
        developer.log(name: TAG, 'method: startInAppPayWithCustomSheetFlutter, event: onCardInfoUpdated');
        try{
          PaymentCardInfo selectedCardInfo = PaymentCardInfo.fromJson(argumentData["selectedCardInfo"]);
          CustomSheet customSheet = CustomSheet.fromJson(argumentData["customSheet"], sheetUpdatedListener);
          customSheetTransactionInfoListener?.onCardInfoUpdated(selectedCardInfo,customSheet);
        }on Exception catch (e){
          print(e);
        }
      }else if(argumentData["event"].toString() == "onSuccess"){
        developer.log(name: TAG, 'method: startInAppPayWithCustomSheetFlutter, event: onSuccess');
        try{
          CustomSheetPaymentInfo response = CustomSheetPaymentInfo.fromJson(argumentData["response"], sheetUpdatedListener);
          customSheetTransactionInfoListener?.onSuccess(response, argumentData["paymentCredential"].toString(),argumentData["extraPaymentData"]);
        }on Exception catch (e){
          print(e);
        }
      }else if(argumentData["event"].toString() == "onFailure"){
        developer.log(name: TAG, 'method: startInAppPayWithCustomSheetFlutter, event: onFailure');
        customSheetTransactionInfoListener?.onFail(argumentData["errorCode"].toString(),argumentData["errorData"]);
      }
    }
    else{
      throw UnimplementedError("Method isn't implemented yet!!!!");
    }
  }

  @override
  Future<bool?> initSamsungPay(PartnerInfo? partnerInfo) async {
    developer.log(name: TAG, 'initSamsungPay()');
    return await methodChannel.invokeMethod<bool?>('initSamsungPay',jsonEncode(partnerInfo?.toJson()));
  }
  @override
  Future<void> getSamsungPayStatus(StatusListener statusListener) async {
    developer.log(name: TAG, 'getSamsungPayStatus()');
    this.statusListener=statusListener;
    await methodChannel.invokeMethod('getSamsungPayStatus');
  }
  @override
  Future<void> getWalletInfo(StatusListener statusListener) async {
    developer.log(name: TAG, 'getWalletInfo()');
    this.statusListener = statusListener;
    await methodChannel.invokeMethod('getWalletInfo');
  }

  @override
  Future<void> goToUpdatePage() async{
    developer.log(name: TAG,  'goToUpdatePage()');
    return await methodChannel.invokeMethod<void>('goToUpdatePage');
  }

  @override
  Future<void> activateSamsungPay() async{
    developer.log(name: TAG, 'activateSamsungPay()');
    await methodChannel.invokeMethod<void>('activateSamsungPay');
  }

  @override
  Future<void> addCard(AddCardInfo addCardInfo,AddCardListener addCardListener) async {
    developer.log(name: TAG, 'addCard()');
    this.addCardListener=addCardListener;
    await methodChannel.invokeMethod('addCard', jsonEncode(addCardInfo.toJson()));
  }

  @override
  Future<void> getAllCards(GetCardListener getCardListener) async {
    developer.log(name: TAG, 'getAllCards()');
    this.getCardListener=getCardListener;
    await methodChannel.invokeMethod('getAllCards');
  }

  @override
  Future<void> requestCardInfo(PaymentCardInfo paymentCardInfo, CardInfoListener cardInfoListener) async{
    developer.log(name: TAG, 'requestCardInfo()');
    this.cardInfoListener = cardInfoListener;
   // developer.log(name: TAG, jsonEncode(paymentCardInfo.toJson().toString()));
    await methodChannel.invokeMethod("requestCardInfo", jsonEncode(paymentCardInfo.toJson()));
  }

  @override
  Future<void> startInAppPayWithCustomSheet(CustomSheetPaymentInfo customSheetPaymentInfo,CustomSheetTransactionInfoListener customSheetTransactionInfoListener) async{
    developer.log(name: TAG,  'startInAppPayWithCustomSheet()');
    this.customSheetTransactionInfoListener = customSheetTransactionInfoListener;

    _setSheetUpdateListener(customSheetPaymentInfo);
    await methodChannel.invokeMethod("startInAppPayWithCustomSheet",jsonEncode(customSheetPaymentInfo.toJson()));
  }

  @override
  Future<void> updateSheet(CustomSheet customSheet, {int? customErrorCode, String? customErrorMessage}) async {
    developer.log(name: TAG, 'updateSheet()');
    Map<String, dynamic> updateSheetJson = {};
    var customSheetJsonObject = customSheet.toJson();
    updateSheetJson["customSheet"] = customSheetJsonObject;
    updateSheetJson["customErrorCode"] = customErrorCode;
    updateSheetJson["customErrorMessage"] = customErrorMessage;
    try {
      await methodChannel.invokeMethod('updateSheet', jsonEncode(updateSheetJson));
    } on Exception catch (e) {
      print(e);
    }
  }
  void _setSheetUpdateListener(CustomSheetPaymentInfo customSheetPaymentInfo) {
    customSheetPaymentInfo.customSheet.sheetControls?.forEach((element) {
      if(element.controltype == Controltype.ADDRESS){
        var addressControl = element as AddressControl;
        if(addressControl.sheetUpdatedListener != null) {
          sheetUpdatedListener = (element).sheetUpdatedListener;
        }
      }
    });
  }
}
