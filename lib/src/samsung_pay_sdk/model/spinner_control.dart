import 'dart:convert';
import 'package:moyasar/src/samsung_pay_sdk/model/sheet_control.dart';
import 'package:moyasar/src/samsung_pay_sdk/model/sheet_item.dart';
import '../samsung_pay_listener.dart';
import '../spay_core.dart';


/// This class provides SpinnerControl on custom payment sheet.<br>
/// SpinnerControl is used for displaying spinner option on custom payment sheet.<br>
/// <br>
///

class SpinnerControl extends SheetControl{
  List<SheetItem>? items = [];
  String? selectedItemId;
  SheetUpdatedListener? sheetUpdatedListener;

  /// Constructor to create SpinnerControl.<br>
  ///
  ///<b>[Parameters:]</b><br>
  /// [controlId] Unique ID to represent the SpinnerControl. This ID is used to compare with other SheetControls.
  ///
  /// [title] Spinner title to display.
  ///
  /// [sheetItemType] sheetItemType to display.<br>
  ///       The possible values are:<br>
  ///      [SheetItemType.SHIPPING_METHOD_SPINNER]<br>
  ///      [SheetItemType.INSTALLMENT_SPINNER]<br>
  ///      <br>
  ///
  /// <b>[Exceptions:]</b><br>
  /// Throws an [ArgumentError] if title is empty.
  /// Throws an [ArgumentError] if controlId is null or empty.<br>
  ///                            Thrown if sheetItemType is not [SheetItemType.SHIPPING_METHOD_SPINNER] or
  ///                            [SheetItemType.INSTALLMENT_SPINNER].
  ///

  SpinnerControl(String controlId, String title, String sheetItemType) : super(controltype: Controltype.SPINNER){
    setControlId(controlId);
    if (title.isEmpty) {
      throw ArgumentError("SpinnerControl : You must set title.");
    } else if ((sheetItemType != SheetItemType.SHIPPING_METHOD_SPINNER.name) && (sheetItemType != SheetItemType.INSTALLMENT_SPINNER.name)){
      throw ArgumentError("SpinnerControl : sheetItemType must be either SHIPPING_METHOD_SPINNER or INSTALLMENT_SPINNER.");
    }
    SheetItem sheetItem = SheetItem(id: "", title: title, sheetItemType: sheetItemType);
    items?.add(sheetItem);
  }

  ///@nodoc
  SpinnerControl._builder(String controlId, List<SheetItem>? itemList, String? selectedItemId)  : super(controltype: Controltype.SPINNER)
  {
    setControlId(controlId);
    for (var element in itemList!) {
      items?.add(element);
    }
    setSelectedItemId(selectedItemId!);
  }

  ///@nodoc
  factory SpinnerControl.fromJson(Map<String, dynamic> json) => SpinnerControl._builder(
    json["controlId"],
    List<SheetItem>.from(json["items"].map((x) => SheetItem.fromJson(jsonDecode(x.toString())))),
    json["selectedItemId"],
  );

  ///@nodoc
  SheetUpdatedListener? getSheetUpdatedListener() {
    return sheetUpdatedListener;
  }

  ///
  /// API to register a callback which is invoked when SpinnerControl is updated.<br>
  /// <br>
  /// [SheetUpdatedListener.onResult(String, CustomSheet)] is invoked when
  /// SpinnerControl is updated.
  ///
  /// <b>[Parameters:]</b><br>
  /// [sheetUpdatedListener] The callback that will run.
  ///

  void setSheetUpdatedListener(SheetUpdatedListener sheetUpdatedListener) {
    this.sheetUpdatedListener = sheetUpdatedListener;
  }

  ///
  /// API to get spinner title.
  ///
  /// Return Title for SpinnerControl.
  ///
  String? getTitle() {
    return items?.elementAt(0).getTitle();
  }

  ///
  /// API to set spinner title.
  ///
  /// <b>[Parameters:]</b><br>
  /// [title] Spinner title for SpinnerControl.
  ///
  /// <b>[Exceptions:]</b><br>
  /// Throws an [ArgumentError] if spinnerTitle is empty.
  ///
  void setTitle(String title) {
    if (title.isEmpty) {
      throw ArgumentError("setTitle : You must set spinner title");
    }
    SheetItem sheetItem = SheetItem(id: "", title: title, sheetItemType: items?.elementAt(0).getSheetItemType());
    items?.insert(0, sheetItem);
  }

  ///
  /// API to get the ID of selected item.
  ///
  /// Return Selected item ID.
  ///
  String? getSelectedItemId() {
    return selectedItemId;
  }

  ///
  /// API to set selected item with ID.
  ///
  /// <b>[Exceptions:]</b><br>
  /// Throws an [ArgumentError] if there is no item associated with the ID.
  ///

  void setSelectedItemId(String id) {
    if (!existItem(id)) {
      throw ArgumentError("setSelectedItemId : There is no item associated with the ID.");
    }
    selectedItemId = id;
  }

  /// @nodoc
  ///
  /// API to get spinner item list.
  ///
  /// Return Spinner title + item list.
  ///

  List<SheetItem>? getItems() {
    return items;
  }

  ///
  /// API to add item (add item in a specific location, this is optional).
  ///
  /// <b>[Parameters:]</b><br>
  /// [id] Unique ID to be set.
  /// [itemText] String to be set.
  /// [location] Location to be displayed in AmountBoxControl on custom payment sheet. For this case you need to call the method by using key: value format (location: 2).<br>
  ///
  /// <b>[Exceptions:]</b><br>
  /// Throws an [ArgumentError] if the ID or value is null.
  /// Throws an [ArgumentError] if the same ID is used in Items.
  ///

  void addItem(String id, String itemText,{int? location}) {
    location ??= items!.length -1;
    if (existItem(id)) {
      throw ArgumentError("addItem : same ID is used.");
    } else if (itemText.isEmpty) {
      throw ArgumentError("addItem : You must set value.");
    } else if (location < 0 || location > (items?.length)!-1) {
      throw ArgumentError("addItem : location is abnormal.");
    }
    SheetItem sheetItem = SheetItem(id: id,sValue: itemText);
    items?.insert(location+1, sheetItem);
  }

  ///
  /// API to remove item.
  ///
  /// <b>[Parameters:]</b><br>
  /// [id] ID to be removed.
  ///
  /// <b>[Exceptions:]</b><br>
  /// Throws an [ArgumentError] if the ID is empty.
  /// Throws an [ArgumentError] if there is no item associated with the ID.
  ///

  void removeItem(String id) {
    int index;
    if (id.isEmpty) {
      throw ArgumentError("removeItem : You must set id.");
    } else if ((index = _getIndex(0, id)) < 0) {
      throw ArgumentError("removeItem : There is no item associated with the ID.");
    }
    items?.removeAt(index);
  }

  ///
  /// API to update item text.
  ///
  /// <b>[Parameters:]</b><br>
  /// [id] ID to update.
  /// [text] Item String to update.
  ///
  /// <b>[Exceptions:]</b><br>
  /// Throws an [ArgumentError] if the ID is empty.
  /// Throws an [ArgumentError] if there is no item associated with the ID.
  ///

  void updateItem(String id, String text) {
    if (id.isEmpty) {
      throw  ArgumentError("updateItem : You must set ID.");
    } else if (text.isEmpty) {
      throw  ArgumentError("addItem : You must set value.");
    }
    int foundIndex = _getIndex(0, id);
    if (foundIndex > -1) {
      SheetItem sheetItem = SheetItem(id: id,sValue: text);
      items![foundIndex] = sheetItem;
      return;
    }
    throw  ArgumentError("updateItem : There is no item associated with the ID.");
  }

  ///
  /// API to check the item is existing or not.
  ///
  /// <b>[Parameters:]</b><br>
  /// [id] ID to be checked item.
  ///
  /// Return 'true', if there is item.
  ///
  /// <b>[Exceptions:]</b><br>
  /// Throws an [ArgumentError] if the ID is empty.
  ///

  bool existItem(String id) {
    if (id.isEmpty) {
      throw ArgumentError("existItem : You must set ID.");
    }
    if (_getIndex(0, id) > -1) {
      return true;
    } else {
      return false;
    }
  }

  ///@nodoc
  int _getIndex(int startIndex, String id) {
    for(startIndex; startIndex<items!.length;startIndex++){
      if (id == items?[startIndex].getId()) {
        return startIndex;
      }
    }
    return -1;
  }

  ///@nodoc
  @override
  Map<String, dynamic> toJson(){
    Map<String, dynamic> data = super.toJson();
    data.addAll({
      "items": items!.map((e)=>e.toJson()).toList(),
      "selectedItemId": selectedItemId,
    });
    return data;
  }
}
