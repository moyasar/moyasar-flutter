import 'dart:convert';
import 'package:samsung_pay_sdk_flutter/model/sheet_control.dart';
import 'package:samsung_pay_sdk_flutter/model/sheet_item.dart';
import 'package:samsung_pay_sdk_flutter/spay_core.dart';

/// This class provides AmountBoxControl on custom payment sheet.<br>
/// AmountBoxControl is used for displaying amount information on custom payment sheet.<br>
///

class AmountBoxControl extends SheetControl{
  List<SheetItem>? items =[];
  String? currencyCode;

  /// Constructor to create AmountBoxControl.<br>
  ///
  /// <b>[Parameters:]</b><br>
  /// [controlId] Unique ID to represent the AmountBoxControl.<br>
  ///             This ID is used to compare and identify the other SheetControls.<br>
  ///
  /// [currencyCode] Currency code to be used by Payment Gateway for payment.<br>
  ///                ISO 4217 currency code (example: USD, KRW, EUR, and so on / All uppercase).<br>
  ///
  /// <b>[Exceptions:]</b><br>
  /// Throws an [ArgumentError] if controlId is empty.<br>
  ///

  AmountBoxControl(String controlId, String currencyCode) : super(controltype: Controltype.AMOUNTBOX){
    setControlId(controlId);
    setCurrencyCode(currencyCode);
  }

  ///@nodoc
  List<SheetItem>? getItems() {
    return items;
  }

  ///@nodoc
  factory AmountBoxControl.fromJson(Map<String, dynamic> json){
    AmountBoxControl amountBoxControl = AmountBoxControl(json["controlId"], json["currencyCode"]);
    for(var item in json["items"]){
      SheetItem sheetItem =SheetItem.fromJson(item);
      amountBoxControl.items!.add(sheetItem);
    }
    return amountBoxControl;
  }

  ///@nodoc
  @override
  Map<String, dynamic> toJson(){
    Map<String, dynamic> data = super.toJson();
    data.addAll({
      "items": items!.map((e)=>e.toJson()).toList(),
      "currencyCode": currencyCode,
    });
    return data;
  }

  ///@nodoc
  int getAmountTotalIndex() {
    int foundIndex = 0;
    for (; foundIndex <  items!.length; foundIndex++) {
      if (items?[foundIndex].getSheetItemType() == SheetItemType.AMOUNT_TOTAL.name) {
        return foundIndex;
      }
    }
    return -1;
  }

  ///@nodoc
  bool _hasAmountTotal(){
    return getAmountTotalIndex() > -1;
  }

  ///@nodoc
  int _getItemIndex(String id) {
    for (int foundIndex = 0; foundIndex < items!.length; foundIndex++) {
      if (items?[foundIndex].getId() == id) {
        return foundIndex;
      }
    }
    return -1;
  }

  ///
  /// API to add item or add item (add item in a specific location, this is optional).
  ///
  /// <b>[Parameters:]</b><br>
  /// [id] - Unique ID to be set.<br>
  /// [title] - Title to be displayed.<br>
  /// [price] - Price to be set.<br>
  /// [extraPrice] - If extraPrice is set, extraPrice is displayed instead of price on custom payment sheet.<br>
  /// [location] - Location to be displayed in AmountBoxControl on custom payment sheet. For this case you need to call the method by using key: value format (location: 2).<br>
  ///
  /// <b>[Exceptions:]</b><br>
  /// Throws an [ArgumentError] if ID or title is empty.<br>
  /// Throws an [ArgumentError] if the same ID is used in other SheetControl.<br>
  /// Throws an [ArgumentError] if location is invalid or the same ID is used in other SheetControls.<br>
  ///

  void addItem(String id, String title, double price, String extraPrice,{int? location}) {
    if(location == null)
    {
      if (_hasAmountTotal()) {
        location = items!.length-1;
      } else {
        location = items!.length;
      }
    }
    if (id.isEmpty) {
      throw ArgumentError("addItem : You must set itemId.");
    } else if (title.isEmpty) {
      throw ArgumentError("addItem : You must set title.");
    } else if (location < 0 || (_hasAmountTotal() && location >= items!.length) || (!_hasAmountTotal() && location > items!.length)) {
      throw ArgumentError("addItem : there is abnormal location");
    } else if (_getItemIndex(id) > -1) {
      throw ArgumentError("addItem : same id is used.");
    }
    SheetItem sheetItem = SheetItem(id: id,title: title, dValue: price, sValue: extraPrice,sheetItemType: SheetItemType.AMOUNT_ITEM.name.toString());
    items?.insert(location, sheetItem);
  }

  ///
  /// API to check the item is existing or not.
  ///
  /// <b>[Parameters:]</b><br>
  /// [id] Unique ID to be checked.<br>
  ///
  /// <b>[Exceptions:]</b><br>
  /// Throws an [ArgumentError] if ID is empty.<br>
  ///
  /// Return 'true' or 'false'<br>
  ///

  bool existItem(String id)
  {
    if (id.isEmpty) {
      throw ArgumentError("You must set id.");
    }
    else if(items!.isEmpty) {
      throw ArgumentError("You don't have any item.");
    }
    else {
      final index = items!.indexWhere((items) => items.id == id);
      if (index==-1) {
        return false;
      }
      return true;
    }
  }

  ///
  /// API to return the currency code.<br>
  /// ISO 4217 currency code (example: USD, KRW, EUR, and so on).<br>
  ///
  /// Return Currency code.<br>
  ///
  ///
  String? getCurrencyCode(){
    return currencyCode;
  }

  ///
  /// API to set the currency code.
  ///
  /// <b>[Parameters:]</b><br>
  /// [currencyCode] Currency code to be used by Payment Gateway for payment.<br>
  ///                ISO 4217 currency code (example: USD, KRW, EUR, and so on / All uppercase).<br>
  ///
  /// <b>[Exceptions:]</b><br>
  /// Throws an [ArgumentError] if the currency code is empty.<br>
  ///
  void setCurrencyCode(String currencyCode){
    if (currencyCode.isEmpty) {
      throw ArgumentError("currencyCode is empty");
    }
    this.currencyCode = currencyCode;
  }

  ///
  /// API to get value for ID.
  ///
  /// <b>[Parameters:]</b><br>
  /// id Unique ID to get value.<br>
  /// Return double value<br>
  ///
  /// <b>[Exceptions:]</b><br>
  /// Throws an [ArgumentError] if the ID is empty.<br>
  /// Throws an [ArgumentError] if the ID is invalid.<br>
  ///
  double? getValue(String id)
  {
    if (id.isEmpty) {
      throw ArgumentError("You must set itemId.");
    }

    final index = items!.indexWhere((items) => items.id == id);
    if (index > -1) {
      return items!.elementAt(index).dValue;
    }
    throw ArgumentError("id is invalid.");
  }

  ///
  /// API to remove item.
  ///
  /// <b>[Parameters:]</b><br>
  /// [id] - ID of item to remove.<br>
  ///
  /// <b>[Exceptions:]</b><br>
  /// Throws an [ArgumentError] if the ID is empty.<br>
  /// Throws an [ArgumentError] if the ID is invalid.<br>
  ///

  void removeItem(String id){
    int index;
    if (id.isEmpty) {
      throw ArgumentError("removeItem : You must set itemId.");
    }
    else if ((index = _getItemIndex(id)) < 0) {
      throw ArgumentError("removeItem : there is no id.");
    }
    items?.removeAt(index);
  }

  ///
  /// API to set the amount total.
  ///
  /// <b>[Parameters:]</b><br>
  /// [price] - Price to be set.<br>
  ///           This amount is for online payment transaction.<br>
  ///
  /// [displayOption] - Amount total display option. Merchant must set one of the predefined formats to display total.<br>
  ///        The possible values are:<br>
  ///            [SpaySdk.FORMAT_TOTAL_PRICE_ONLY]<br>
  ///            [SpaySdk.FORMAT_TOTAL_ESTIMATED_AMOUNT]<br>
  ///            [SpaySdk.FORMAT_TOTAL_ESTIMATED_CHARGE]<br>
  ///            [SpaySdk.FORMAT_TOTAL_ESTIMATED_FARE]<br>
  ///            [SpaySdk.FORMAT_TOTAL_FREE_TEXT_ONLY]<br>
  ///            [SpaySdk.FORMAT_TOTAL_AMOUNT_PENDING]<br>
  ///            [SpaySdk.FORMAT_TOTAL_AMOUNT_PENDING_TEXT_ONLY]<br>
  ///            [SpaySdk.FORMAT_TOTAL_PENDING]<br>
  ///            [SpaySdk.FORMAT_TOTAL_PENDING_TEXT_ONLY]<br>
  ///            [SpaySdk.FORMAT_TOTAL_UP_TO_AMOUNT]<br>
  ///
  /// <b>[Exceptions:]</b><br>
  /// Throws an [ArgumentError] if displayOption is empty.<br>

  void setAmountTotal(double price, String displayOption){
    if(displayOption.isEmpty){
      throw ArgumentError("setAmountTotal : You must set displayOption.");
    }
    int foundIndex = getAmountTotalIndex();
    SheetItem item= SheetItem(id: "",title: "",dValue: price, sValue: displayOption, sheetItemType: SheetItemType.AMOUNT_TOTAL.name.toString());
    if (foundIndex > -1) {
      items?[foundIndex] = item;
    } else {
      items?.add(item);
    }
  }

  ///
  /// API to update item title.
  ///
  /// <b>[Parameters:]</b><br>
  /// [id] - Unique ID of item to update.<br>
  /// [title] - Title to be set.<br>
  ///
  /// <b>[Exceptions:]</b><br>
  /// Throws an [ArgumentError] if the ID is empty.<br>
  /// Throws an [ArgumentError] if there are no items associated with the ID.<br>
  ///

  void updateTitle(String id, String title){
    if (id.isEmpty) {
      throw ArgumentError("You must set itemId.");
    }
    int foundIndex = items!.indexWhere((items) => items.id == id);

    if (foundIndex > -1) {
      SheetItem item = SheetItem(id: id, title: title, dValue: items!.elementAt(foundIndex).dValue, sValue: items!.elementAt(foundIndex).sValue, sheetItemType:items![foundIndex].getSheetItemType());
      items?.insert(foundIndex,item);
      return;
    }
    throw ArgumentError("updateTitle : there are no items associated with the id.");
  }

  ///
  /// API to update price.<br>
  ///
  /// currencyCode + price will appear on custom payment sheet.<br>
  /// If price is set, then extraPrice is initialized empty value,<br>
  /// because extraPrice appear if extraPrice is not empty.<br>
  ///
  /// <b>[Parameters:]</b><br>
  /// [id] - Unique ID of item to update.<br>
  /// [price] - Price to be set.<br>
  ///
  /// <b>[Exceptions:]</b><br>
  /// Throws an [ArgumentError] if the ID is empty.<br>
  /// Throws an [ArgumentError] if there are no items associated with the ID.<br>
  ///

  void updateValue(String id, double price,{String? extraPrice}){

    if (id.isEmpty) {
      throw ArgumentError("You must set itemId.");
    }
    int foundIndex = _getItemIndex(id);
    if (foundIndex > -1) {
      if(extraPrice==null)
      {
        SheetItem item = SheetItem(id: id, title: items![foundIndex].title, dValue: price,  sValue: "", sheetItemType: items![foundIndex].getSheetItemType());
        items?[foundIndex] = item;
      }
      else
      {
        SheetItem item = SheetItem(id: id, title: items![foundIndex].title, dValue: price, sValue: extraPrice,  sheetItemType: items![foundIndex].getSheetItemType());
        items?[foundIndex] = item;
      }
      return;
    }
    throw ArgumentError("updateValue : there are no items associated with the id.");//popup
  }
}
