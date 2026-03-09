
/// Address object managed by UserInfoCollection returned when calling API
///
class Address {
  static const String KEY_VERSION = "version";
  static const  String KEY_ADDRESSEE = "addressee";
  static const String KEY_ADDRESS_LINE1 = "addressLine1";
  static const String KEY_ADDRESS_LINE2 = "addressLine2";
  static const String KEY_CITY = "city";
  static const String KEY_STATE = "state";
  static const String KEY_COUNTRY_CODE = "countryCode";
  static const String KEY_POSTAL_CODE = "postalCode";
  static const String KEY_PHONE_NUMBER = "phoneNumber";
  static const String KEY_EXTRA_INFO = "extraAddressInfo";

  String? addressee;
  String? addressLine1;
  String? addressLine2;
  String? city;
  String? state;
  String? countryCode;
  String? postalCode;
  String? phoneNumber;
  Map<String,dynamic>? extraAddressInfo;
  String? email;

/// Constructor to create Address.<br>
///
  Address({
     this.addressee,
     this.addressLine1,
     this.addressLine2,
     this.city,
     this.state,
     this.countryCode,
     this.postalCode,
     this.phoneNumber,
    this.email,
    this.extraAddressInfo,
  });

  ///@nodoc
  factory Address.fromJson(Map<String, dynamic> json) =>
      Address(
        addressee: json["addressee"],
        addressLine1: json["addressLine1"],
        addressLine2: json["addressLine2"],
        city: json["city"],
        state: json["state"],
        countryCode: json["countryCode"],
        postalCode: json["postalCode"],
        phoneNumber: json["phoneNumber"],
        extraAddressInfo: json["extraAddressInfo"],
        email: json["email"],
      );

  ///@nodoc
  Map<String, dynamic> toJson(){
    Map<String, dynamic> addressJson = {};
    if(addressee != null) {
      addressJson["addressee"] = addressee;
    }
    if(addressLine1 != null) {
      addressJson["addressLine1"] = addressLine1;
    }
    if(addressLine2 != null) {
      addressJson["addressLine2"] = addressLine2;
    }
    if(city != null) {
      addressJson["city"] = city;
    }
    if(state != null) {
      addressJson["state"] = state;
    }
    if(countryCode != null) {
      addressJson["countryCode"] = countryCode;
    }
    if(postalCode != null) {
      addressJson["postalCode"] = postalCode;
    }
    if(phoneNumber != null) {
      addressJson["phoneNumber"] = phoneNumber;
    }
    if(extraAddressInfo != null) {
      addressJson["extraAddressInfo"] = extraAddressInfo;
    }
    if(email != null) {
      addressJson["email"] = email;
    }
    return addressJson;
  }
}
