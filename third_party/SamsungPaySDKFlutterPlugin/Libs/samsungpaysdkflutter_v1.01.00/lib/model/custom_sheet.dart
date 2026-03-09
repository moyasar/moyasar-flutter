
import 'package:samsung_pay_sdk_flutter/model/address_control.dart';
import 'package:samsung_pay_sdk_flutter/model/plain_text_control.dart';
import 'package:samsung_pay_sdk_flutter/model/sheet_control.dart';
import 'package:samsung_pay_sdk_flutter/model/spinner_control.dart';
import 'package:samsung_pay_sdk_flutter/samsung_pay_sdk_flutter.dart';

import 'amount_box_control.dart';

/// This class provides custom payment sheet which contains various SheetControls.
///

class CustomSheet {
  List<SheetControl>? sheetControls=[];

  /// Constructor to create CustomSheet.<br>
  /// CustomSheet is used to contain various SheetControls.
  ///
  /// See [startInAppPayWithCustomSheet(CustomSheetPaymentInfo, PaymentManager.CustomSheetTransactionInfoListener)]
  ///
  CustomSheet();

  ///
  /// API to add SheetControl (add SheetControl in specific location).<br>
  ///
  /// <b>[Parameters:]</b><br>
  /// [sheetControl]<br>
  ///       SheetControl to be set. <br>
  ///       The possible values are:<br>
  ///          [AddressControl]<br>
  ///          [AmountBoxControl]<br>
  ///          [PlainTextControl]<br>
  ///      <br>
  ///[location]<br>
  ///        SheetControl location to be displayed on custom payment sheet.For this case you need to call the method by using key: value format (location: 2).<br>
  ///       <br>
  ///
  /// <b>[Exceptions]</b><br>
  /// Throws an [ArgumentError] if the sheetControl is null.
  /// Throws an [ArgumentError] if same ID is used in other SheetControls.
  /// Throws an [ArgumentError] if there is no data in AmountBoxControl.
  /// Throws an [ArgumentError] [AmountBoxControl.setAmountTotal(double, String)] API method should be called when AmountBoxControl is
  ///        created or updated.<br>
  ///        If setAmountTotal() is not called, AMOUNT_TOTAL SheetItemType is not the last item in AmountBoxControl.
  ///
  void addControl(SheetControl sheetControl,{int? location}){
    location??= sheetControls!.length;
      if (location < 0 || location > sheetControls!.length) {
        throw ArgumentError("addItem : there is abnormal location.");
      } else if (getSheetControl(sheetControl.controlId!) != null) {
        throw ArgumentError("addControl : same id is used.");
      }

    if(sheetControl.controltype == Controltype.AMOUNTBOX){
      AmountBoxControl amountBoxControl =  sheetControl as AmountBoxControl;
      int lastItemIndex = amountBoxControl.getItems()!.length - 1;
      if (lastItemIndex < 0) {
        throw ArgumentError("addControl : No data in AmountBoxControl.");
      } else if (amountBoxControl.getItems()!.elementAt(lastItemIndex).getSheetItemType() != (SheetItemType.AMOUNT_TOTAL.name)) {
        throw ArgumentError("AMOUNT_TOTAL type must be the last item in AmountBoxControl.");
      }
    }
    sheetControls?.insert(location,sheetControl);

  }

  ///
  /// API to get SheetControl.<br>
  ///
  /// <b>[Parameters:]</b><br>
  /// [controlId] ID to find SheetControl.<br>
  ///
  /// Return SheetControl which has the controlId.
  ///
  /// <b>[Exceptions:]</b><br>
  /// Throws an [ArgumentError] if the controlId is empty.
  ///
  /// API Level 1.3
  SheetControl? getSheetControl(String controlId) {
    if(controlId.isNotEmpty){
      for (SheetControl sheetControl in sheetControls!) {
        if (controlId == sheetControl.controlId) {
          return sheetControl;
        }
      }
    } else{
      throw ArgumentError("You must provide valid controlId");
    }
    return null;
  }

  ///
  /// API to get SheetControl list.<br>
  ///
  /// Return SheetControl list.
  ///
  List<SheetControl>? getSheetControls() {
    return sheetControls;
  }

  ///
  /// API to remove SheetControl.<br>
  ///
  /// <b>[Parameters:]</b><br>
  /// [sheetControl]
  ///       SheetControl to be removed.<br>
  ///       The possible values are:<br>
  ///            [AddressControl]<br>
  ///            [AmountBoxControl]<br>
  ///            [PlainTextControl]<br>
  ///      <br>
  ///
  /// Return 'true', if successfully deleted . Otherwise, return 'false'.
  ///
  /// <b>[exceptions]</b><br>
  /// Throws an [ArgumentError] if the sheetControl is null.
  /// Throws an [ArgumentError] if SheetControl type is [Controltype.AMOUNTBOX] or [Controltype.ADDRESS].
  ///
  bool removeControl(SheetControl sheetControl){
    if (sheetControl.controltype == Controltype.AMOUNTBOX) {
      throw ArgumentError("AmountBoxControl must not be deleted.");
    } else if (sheetControl.controltype == Controltype.ADDRESS) {
      throw ArgumentError("AddressControl must not be deleted.");
    }
    if(sheetControls!.contains(sheetControl)){
      sheetControls!.remove(sheetControl);
      return true;
    }
    return false;
  }

  ///
  /// API to update SheetControl.<br>
  ///
  /// <b>[Parameters:]</b><br>
  /// [sheetControl]
  ///       SheetControl to be updated.<br>
  ///       The possible values are:<br>
  ///            [AddressControl]<br>
  ///            [AmountBoxControl]<br>
  ///            [PlainTextControl]<br>
  ///      <br>
  ///
  /// Return 'true', if successfully updated. Otherwise, return 'false'.
  ///
  /// <b>[Exceptions:]</b><br>
  /// Throws an [ArgumentError] if the sheetControl is null.
  ///

  bool updateControl(SheetControl sheetControl) {
    int foundIndex = 0;
    if (sheetControls != null) {
      for (; foundIndex < sheetControls!.length;foundIndex++){
        if (sheetControl == sheetControls![foundIndex]) {
          sheetControls![foundIndex]=sheetControl;
          return true;
        }
      }
    }
    return false;
  }

  ///@nodoc
  factory CustomSheet.fromJson(Map<String, dynamic> json, SheetUpdatedListener? sheetUpdatedListener){
    CustomSheet customSheet = CustomSheet();
    for(var sheetControl in json["sheetControls"]){
      if(sheetControl["controltype"] == Controltype.ADDRESS.name){
        AddressControl addressControl = AddressControl.fromJson(sheetControl, sheetUpdatedListener);
        customSheet.addControl(addressControl);
      }
      else if(sheetControl["controltype"] == Controltype.AMOUNTBOX.name){
        AmountBoxControl amountBoxControl = AmountBoxControl.fromJson(sheetControl);
        customSheet.addControl(amountBoxControl);
      }
      else if(sheetControl["controltype"] == Controltype.SPINNER.name){
        SpinnerControl spinnerControl = SpinnerControl.fromJson(sheetControl);
        customSheet.addControl(spinnerControl);
      }
      else if(sheetControl["controltype"] == Controltype.PLAINTEXT.name){
        PlainTextControl plainTextControl = PlainTextControl.fromJson(sheetControl);
        customSheet.addControl(plainTextControl);
      }
    }
    return customSheet;
  }

  ///@nodoc
  Map<String, dynamic> toJson() => {
    "sheetControls": sheetControls!.map((e)=>e.toJson()).toList(),
  };
}
