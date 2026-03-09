import 'package:moyasar/src/samsung_pay_sdk/model/sheet_control.dart';
import 'package:moyasar/src/samsung_pay_sdk/model/sheet_item.dart';
import 'package:moyasar/src/samsung_pay_sdk/spay_core.dart';

/// This class provides PlainTextControl on custom payment sheet.<br>
/// This control is used for displaying 2-line text with title or 1-line text without title.
///

class PlainTextControl extends SheetControl{
  SheetItem? sheetItem;

  PlainTextControl(String controlId) : super(controltype: Controltype.PLAINTEXT){
    setControlId(controlId);
  }

  /// Constructor to create PlainTextControl.<br>
  ///
  /// <b>[Parameters:]</b><br>
  /// [controlId]
  ///      Unique ID to represent the PlainTextControl.
  ///      This ID is used to compare and identify the other SheetControls.
  ///

  PlainTextControl._builder(String controlId, SheetItem sheetItem) : super(controltype: Controltype.PLAINTEXT)
  {
    setControlId(controlId);
    this.sheetItem = sheetItem;
  }

  /// API to set the title and text.
  ///
  /// <b>[Parameters:]</b><br>
  /// [title] Title to set.
  /// [text] Text to set.
  ///
  ///

  void setText(String title , String text)
  {
    sheetItem = SheetItem(id: "", title: title, sValue: text);
  }

  /// API to get text.
  ///
  /// Return Text to display.
  ///

  String? getText() {
    if (sheetItem == null) {
      return null;
    } else {
      return sheetItem?.getSValue();
    }
  }

  /// API to get title.
  ///
  /// Return Title for PlainTextControl.
  ///
  ///

  String? getTitle() {
    if (sheetItem == null) {
      return null;
    } else {
      return sheetItem?.getTitle();
    }
  }

  ///@nodoc
  SheetItem? getItem() {
    return sheetItem;
  }

  ///@nodoc
  factory PlainTextControl.fromJson(Map<String, dynamic> json) =>  PlainTextControl._builder(
    json["controlId"],
    SheetItem.fromJson(json["sheetItem"]),
  );

  ///@nodoc
  @override
  Map<String, dynamic> toJson(){
    Map<String, dynamic> data = super.toJson();
    data.addAll({
      "sheetItem": sheetItem?.toJson(),
    });
    return data;
  }
}
