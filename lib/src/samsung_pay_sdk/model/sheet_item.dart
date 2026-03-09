import 'package:moyasar/src/samsung_pay_sdk/spay_core.dart';

///
/// This class provides basic data APIs for SheetControl<br>
///

class SheetItem {
  String? id;
  String? title;
  String? sValue;
  double? dValue;
  String? sheetItemType;
  Map<String,dynamic>? extraValue;

  ///@nodoc
  SheetItem({
    this.id,
    this.title,
    this.sValue,
    this.dValue,
    this.sheetItemType,
    this.extraValue,
  });

  /// API to get SheetItemType
  ///
  /// Return SheetItemType
  ///      SheetItemType is used for distinguish SheetControls in detail.
  ///      The possible values are :<br>
  ///      [SheetItemType.BILLING_ADDRESS]<br>
  ///      [SheetItemType.SHIPPING_ADDRESS]<br>
  ///

  String? getSheetItemType()
  {
    return sheetItemType;
  }

  ///@nodoc
  Map<String,dynamic>? getExtraValue() {
    return extraValue;
  }

  /// API to get item ID
  ///
  /// Return ID of the item
  ///

  String? getId() {
    return id;
  }

  /// API to get item title
  ///
  /// Return Title of the item
  ///

  String? getTitle() {
    return title;
  }

  /// API to get item String value
  ///
  /// Return String value of the item
  ///

  String? getSValue() {
    return sValue;
  }

  /// API to get item double value
  ///
  /// Return Double value of the item
  ///

  double? getDValue() {
    return dValue;
  }

  ///@nodoc
  factory SheetItem.fromJson(Map<String, dynamic> json) => SheetItem(
    id: json["id"],
    title: json["title"],
    sValue: json["sValue"],
    dValue: json["dValue"],
    sheetItemType: json["sheetItemType"],
    extraValue: json["extraValue"],
  );

  ///@nodoc
  Map<String, dynamic> toJson() {
    Map<String,dynamic> sheetItemJson= {};
    if(id != null && id!.isNotEmpty) {
      sheetItemJson["id"]= id;
    }
    if(title != null) {
      sheetItemJson["title"] = title;
    }
    if(sValue != null && sValue!.isNotEmpty) {
      sheetItemJson["sValue"] = sValue;
    }
    if(dValue != null) {
      sheetItemJson["dValue"] = dValue;
    }
    if(sheetItemType != null) {
      sheetItemJson["sheetItemType"] = sheetItemType;
    }
    if(extraValue != null) {
      sheetItemJson["extraValue"] = extraValue;
    }
    return sheetItemJson;
  }
}
