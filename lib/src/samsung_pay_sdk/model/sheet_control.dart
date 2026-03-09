
import '../spay_core.dart';

///
/// This class is basic class for each component on custom payment sheet.
///

class SheetControl {
  Controltype controltype;
  String? controlId;

  ///@nodoc
  SheetControl({
    required this.controltype,
  });

  SheetControl._builder({
    required this.controltype,
    required this.controlId,
  });

  ///@nodoc
  /// API to set controlId. <br>
  ///
  /// <b>[Parameters:]</b><br>
  /// [controlId] Unique ID to be set.
  ///
  /// <b>[Exceptions:]</b><br>
  ///Throws an [ArgumentError] if controlId is invalid.

  void setControlId(String controlId) {
    if (controlId.isEmpty) {
      throw ArgumentError("setControlId : controlId is invalid.");
    }
    this.controlId = controlId;
  }

  ///
  /// API to get controlId. <br>
  ///
  /// Return The controlId of the SheetControl.
  ///

  String? getControlId(){
    return controlId;
  }

  ///
  /// API to get controltype. <br>
  ///
  /// Return The controltype of the SheetControl.
  ///
  ///
  Controltype getControltype() {
    return controltype;
  }

  //TODO
  ///@nodoc
  factory SheetControl.fromJson(Map<String, dynamic> json) => SheetControl._builder(
    controltype: json["controltype"],
    controlId: json["controlId"],
  );

  ///@nodoc
  Map<String, dynamic> toJson() => {
    "controltype": controltype.name,
    "controlId": controlId,
  };
}
