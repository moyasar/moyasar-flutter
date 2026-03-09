import 'dart:convert';
import 'package:samsung_pay_sdk_flutter/model/sheet_control.dart';
import 'package:samsung_pay_sdk_flutter/model/sheet_item.dart';
import 'package:samsung_pay_sdk_flutter/samsung_pay_sdk_flutter.dart';
import 'address.dart';

/// This class provides AddressControl on custom payment sheet.<br>
///
/// AddressControl is used for displaying billing address or shipping address<br>
/// on custom payment sheet from "My Info" menu option on Samsung Wallet app.<br>
/// <br>
/// [Caution]: AddressControl must be returned in onResult() on SheetUpdatedListener<br>
///            to remove progress bar on custom payment sheet.<br>
///

class AddressControl extends SheetControl{
  static const String EXTRA_DISPLAY_OPTION = "extra_display_option";

  SheetItem? sheetItem;
  Address? address;
  int? displayOption;
  int? errorCode;
  SheetUpdatedListener? sheetUpdatedListener;

  /// Constructor to create AddressControl.<br>
  ///
  /// <b>[Parameters:]</b><br>
  ///  [controlId] Unique ID to represent the AddressControl.<br>
  ///              This ID is used to compare and identify the other SheetControls.<br>
  ///
  /// [sheetItemType] SheetItemType represents billing address or shipping address.<br>
  ///      <br>
  ///      The possible values are:<br>
  ///        [SheetItemType.BILLING_ADDRESS]<br>
  ///        [SheetItemType.ZIP_ONLY_ADDRESS]<br>
  ///        [SheetItemType.SHIPPING_ADDRESS]<br>
  ///      It is possible to show only one billing AddressControl and one shipping AddressControl.<br>
  ///
  /// <b>[Exceptions:]</b><br>
  /// Throws an [ArgumentError] if controlId is null or empty.<br>
  /// Throws an [ArgumentError] if sheetItemType is not<br>
  ///         [sheetItemType.BILLING_ADDRESS] or<br>
  ///         [sheetItemType.ZIP_ONLY_ADDRESS] or<br>
  ///         [sheetItemType.SHIPPING_ADDRESS]<br>
  ///
  ///
  AddressControl(String controlId, String sheetItemType): super(controltype: Controltype.ADDRESS){
    setControlId(controlId);
    if ((sheetItemType == SheetItemType.BILLING_ADDRESS.name) || (sheetItemType == SheetItemType.SHIPPING_ADDRESS.name) || (sheetItemType == SheetItemType.ZIP_ONLY_ADDRESS.name)){
      sheetItem = SheetItem(sheetItemType: sheetItemType);
    } else {
      throw ArgumentError("AddressControl : sheetItemType must be either BILLING_ADDRESS or " "SHIPPING_ADDRESS or" + "ZIP_ONLY_ADDRESS.");
    }
  }

  ///
  /// API to get address. <br>
  ///
  /// Return The address of the AddressControl.
  ///
  ///
  Address? getAddress(){
    return address;
  }

  ///
  /// API to set address. <br>
  ///
  /// <b>[Parameters:]</b><br>
  /// [address] Address to be set. <br>
  ///      <br>
  ///       The possible values are:<br>
  ///         [SheetItemType.BILLING_ADDRESS]<br>
  ///         [SheetItemType.SHIPPING_ADDRESS]<br>
  ///      <br>
  ///
  ///
  void setAddress(Address address){
    this.address=address;
  }

  ///
  /// API to get address title. <br>
  ///
  /// Return Title of the AddressControl.
  ///
  ///
  String? getAddressTitle(){
    return sheetItem?.title;
  }

  ///
  /// API to get address type. <br>
  ///
  /// Return SheetItemType of the AddressControl.<br>
  ///      <br>
  ///      The returned value can be one of the following SheetItemTypes:<br>
  ///       [SheetItemType.BILLING_ADDRESS]<br>
  ///       [SheetItemType.SHIPPING_ADDRESS]<br>
  ///      <br>
  ///
  ///
  SheetItemType? getAddressType(){
    if(sheetItem!.sheetItemType == SheetItemType.SHIPPING_ADDRESS.name) {
      return SheetItemType.SHIPPING_ADDRESS;
    } else {
      return SheetItemType.BILLING_ADDRESS;
    }
  }

  ///
  /// API to set address title. <br>
  ///
  /// <b>[Parameters:]</b><br>
  /// [title] Title of the AddressControl.<br>
  ///         If title is empty like "", then default title is displayed.<br>
  ///
  /// <b>[Exceptions:]</b><br>
  /// [Throws an [ArgumentError] if title is null.<br>
  ///
  ///
  void setAddressTitle(String title){
    sheetItem!.title= title;
  }

  ///
  /// API to get display option of [SheetItemType.SHIPPING_ADDRESS] on custom payment sheet. <br>
  ///
  /// Return Current display option of shipping address on custom payment sheet<br>
  ///      <br>
  ///      The returned value will be a combination of below constants:<br>
  ///       [SpaySdk.DISPLAY_OPTION_ADDRESSEE]<br>
  ///       [SpaySdk.DISPLAY_OPTION_ADDRESS]<br>
  ///       [SpaySdk.DISPLAY_OPTION_PHONE_NUMBER]<br>
  ///       [SpaySdk.DISPLAY_OPTION_EMAIL]<br>
  ///      <br>
  ///

  int? getDisplayOption(){
    return displayOption;
  }

  ///
  /// API to set display option of  [SheetItemType.SHIPPING_ADDRESS] on custom payment sheet. <br>
  ///
  /// <b>[Parameters:]</b><br>
  /// [displayOption]
  ///      Display option for shipping address on custom payment sheet<br>
  ///      <br>
  ///      If displayOption is not set, then default addressControl is displayed on custom payment sheet.
  ///      <br><br>
  ///      The possible value is combination of below constants:<br>
  ///      [SpaySdk.DISPLAY_OPTION_ADDRESSEE]<br>
  ///      [SpaySdk.DISPLAY_OPTION_ADDRESS]<br>
  ///      [SpaySdk.DISPLAY_OPTION_PHONE_NUMBER]<br>
  ///      [SpaySdk.DISPLAY_OPTION_EMAIL]<br>
  ///
  /// <b>[Exceptions:]</b><br>
  /// Throws an [ArgumentError] if [SheetItemType.SHIPPING_ADDRESS] is not set in constructor.<br>
  ///

  void setDisplayOption(int displayOption){
    if (sheetItem!.sheetItemType != SheetItemType.SHIPPING_ADDRESS.name) {
      throw ArgumentError("setDisplayOption : sheetItemType must be SHIPPING_ADDRESS.");
    }
    this.displayOption = displayOption;
    sheetItem!.extraValue={EXTRA_DISPLAY_OPTION:displayOption};
  }

  ///
  /// API to get error code of the AddressControl. <br>
  ///
  /// Return The error code.
  ///      <br>
  ///      The returned value can be one of the following error codes:<br>
  ///        [SpaySdk.ERROR_BILLING_ADDRESS_INVALID]<br>
  ///        [SpaySdk.ERROR_BILLING_ADDRESS_NOT_EXIST]<br>
  ///        [SpaySdk.ERROR_SHIPPING_ADDRESS_INVALID]<br>
  ///        [SpaySdk.ERROR_SHIPPING_ADDRESS_UNABLE_TO_SHIP]<br>
  ///        [SpaySdk.ERROR_SHIPPING_ADDRESS_NOT_EXIST]<br>
  ///
  ///
  int? getErrorCode(){
    return errorCode;
  }

  ///
  /// API to set error code of the AddressControl. <br>
  ///
  /// <b>[Parameters:]</b><br>
  /// [errorCode]
  ///  The possible values are:<br>
  ///             [SpaySdk.ERROR_BILLING_ADDRESS_INVALID]<br>
  ///              [SpaySdk.ERROR_BILLING_ADDRESS_NOT_EXIST]<br>
  ///              [SpaySdk.ERROR_SHIPPING_ADDRESS_INVALID]<br>
  ////             [SpaySdk.ERROR_SHIPPING_ADDRESS_UNABLE_TO_SHIP]<br>
  ///              [SpaySdk.ERROR_SHIPPING_ADDRESS_NOT_EXIST]<br>
  ///
  ///
  void setErrorCode(int errorCode){
    this.errorCode = errorCode;
  }

  ///@nodoc
  factory AddressControl.fromJson(Map<String, dynamic> json, SheetUpdatedListener? sheetUpdatedListener){
    AddressControl addressControl = AddressControl(json["controlId"].toString(), SheetItem.fromJson(json["sheetItem"]).sheetItemType.toString());
    addressControl.sheetItem = SheetItem.fromJson(json["sheetItem"]);
    addressControl.address = Address.fromJson(json["address"]);
    addressControl.sheetUpdatedListener = sheetUpdatedListener;
    if(SheetItem.fromJson(json["sheetItem"]).sheetItemType.toString() == SheetItemType.SHIPPING_ADDRESS.name) {
      addressControl.setDisplayOption(json["displayOption"] as int);
    }
    addressControl.setErrorCode(json["errorCode"] as int);
    return addressControl;
  }

  ///@nodoc
  @override
  Map<String, dynamic> toJson(){
    Map<String, dynamic> addressControl= {};
    addressControl["controltype"] = controltype.name;
    addressControl["controlId"] = controlId;
    if(sheetItem != null) {
      addressControl["sheetItem"] = sheetItem?.toJson();
    }
    if(address != null) {
      addressControl["address"] = address?.toJson();
    }
    if(displayOption != null) {
      addressControl["displayOption"] = displayOption;
    }
    if(errorCode != null) {
      addressControl["errorCode"] = errorCode;
    }
    if(sheetUpdatedListener != null) {
      addressControl["sheetUpdatedListener"] = true;
    } else {
      addressControl["sheetUpdatedListener"] = false;
    }
    return addressControl;
  }
}