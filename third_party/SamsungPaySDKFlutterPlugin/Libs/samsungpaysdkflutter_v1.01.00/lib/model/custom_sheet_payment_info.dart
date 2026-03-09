
import 'dart:convert';
import 'package:samsung_pay_sdk_flutter/model/payment_card_info.dart';
import 'package:samsung_pay_sdk_flutter/model/sheet_control.dart';
import 'package:samsung_pay_sdk_flutter/samsung_pay_listener.dart';
import 'package:samsung_pay_sdk_flutter/spay_core.dart';
import 'address.dart';
import 'address_control.dart';
import 'amount_box_control.dart';
import 'custom_sheet.dart';

/// This class provides APIs to fetch Payment information details with custom payment sheet information.<br>
/// That is, transaction details set by the merchant app.
///

class CustomSheetPaymentInfo {
  String? merchantId;
  String merchantName;
  String? orderNumber;
  AddressInPaymentSheet? addressInPaymentSheet;
  List<Brand>? allowedCardBrand;
  PaymentCardInfo? cardInfo;
  bool? isCardHolderNameRequired;
  bool? isRecurring;
  String? merchantCountryCode;
  CustomSheet customSheet;
  Map<String,dynamic>? extraPaymentInfo;


  CustomSheetPaymentInfo({
    required this.merchantName,
    required this.customSheet,
    this.orderNumber
  });

  /// API to set the address display option for payment sheet.
  ///
  /// <b>[Parameters:]</b><br>
  /// [addressInPaymentSheet] Address UI to display on the payment sheet.
  /// Return CustomSheetPaymentInfo Builder.
  ///

  void setAddressInPaymentSheet(AddressInPaymentSheet addressInPaymentSheet){
    this.addressInPaymentSheet = addressInPaymentSheet;
  }

  /// API to set the card brands list supported by merchant.
  ///
  /// <b>[Parameters:]</b><br>
  /// [brands] Card brands supported by merchant for payment.
  ///

  void setAllowedCardBrands(List<Brand> brands){
    allowedCardBrand = brands;
  }

  /// API to set the flag if merchant wants to display card holder's name. <br>
  ///
  /// Set to 'true' if card holder's name should be displayed with card information on the payment sheet.<br>
  /// If issuer does not provide card holder's name, it will not be displayed.
  ///
  /// <b>[Parameters:]</b><br>
  /// [isCardHolderNameRequired] True, if merchant wants to display card holder's name on the payment sheet.
  ///

  void setCardHolderNameEnabled(bool isCardHolderNameRequired){
    this.isCardHolderNameRequired = isCardHolderNameRequired;
  }

  /// API to set customSheet.<br>
  ///
  /// <b>[Parameters:]</b><br>
  /// [customSheet] CustomSheet configured by merchant.
  ///

  void setCustomSheet(CustomSheet customSheet){
    this.customSheet = customSheet;
  }

  /// API to set the extra payment information data.
  ///
  /// <b>[Parameters:]</b><br>
  /// [extraPaymentInfo] Extra PaymentInfo data.
  ///

  void setExtraPaymentInfo(Map<String,dynamic> extraPaymentInfo){
    this.extraPaymentInfo = extraPaymentInfo;
  }

  /// API to set the merchant country code. <br>
  /// This API internally verifies and sets two-letter merchant country code, if it is a valid country code.
  ///
  /// <b>[Parameters:]</b><br>
  /// [merchantCountryCode] Country code, where merchant is operating.
  ///
  /// <b>[Exceptions:]</b><br>
  /// Throws an [ArgumentError] if merchantCountryCode is invalid.<br>
  ///

  void setMerchantCountryCode(String merchantCountryCode){
    this.merchantCountryCode = merchantCountryCode;
  }

  /// API to set the merchant reference ID.
  ///
  /// <b>[Parameters:]</b><br>
  /// [merchantId] Merchant reference ID which can be used for merchant's own purpose.<br>
  ///         For example, if merchant uses a Payment Gateway which requires Payment Gateway User ID,
  ///         then merchantId field can be set with a Payment Gateway User ID.<br>
  ///

  void setMerchantId(String merchantId){
    this.merchantId = merchantId;
  }

  /// API to set the merchant name.
  ///
  /// <b>[Parameters:]</b><br>
  /// [merchantName] Merchant name.
  ///

  void setMerchantName(String merchantName){
    this.merchantName = merchantName;
  }

  /// API to set the order number.
  /// <b>[Parameters:]</b><br>
  /// [orderNumber] Order number sent by merchant for records.<br>
  /// The allowed characters are [A-Z][a-z][0-9,-] & up to 36 characters.<br>
  /// This field is mandatory for VISA.
  ///

  void setOrderNumber(String orderNumber){
    this.orderNumber = orderNumber;
  }

  /// API to set the card brand for payment transaction.<br>
  /// This API can be used with setPaymentCardLast4DPAN(String) or <br>
  /// setPaymentCardLast4FPAN(String) API method
  /// to designate specific card for the transaction.<br>
  ///
  /// <b>[Parameters:]</b><br>
  /// [cardBrand] Card brand.
  ///

  void setPaymentCardBrand(Brand cardBrand){
    _nullCheckExtraPaymentInfo();
    extraPaymentInfo![SpaySdk.EXTRA_CARD_BRAND] = cardBrand.name;
  }

  /// API to set the last 4 digits of DPAN for payment transaction.<br>
  /// This API can be used with setPaymentCardBrand(SpaySdk.Brand) API method
  /// to designate specific card for the transaction.<br>
  ///
  /// <b>[Parameters:]</b><br>
  /// [last4digits] The last 4 digits of DPAN for payment transaction.
  ///

  void setPaymentCardLast4DPAN(String last4digits){
    _nullCheckExtraPaymentInfo();
    extraPaymentInfo![SpaySdk.EXTRA_LAST4_DPAN] = last4digits;
  }

  /// API to set the last 4 digits of FPAN for payment transaction.<br>
  /// This API can be used with setPaymentCardBrand(SpaySdk.Brand) API method
  /// to designate specific card for the transaction.<br>
  ///
  /// <b>[Parameters:]</b><br>
  /// [last4digits] The last 4 digits of FPAN for payment transaction.
  ///

  void setPaymentCardLast4FPAN(String last4digits){
    _nullCheckExtraPaymentInfo();
    extraPaymentInfo![SpaySdk.EXTRA_LAST4_FPAN] = last4digits;
  }

  /// API to set the shipping method for payment transaction.<br>
  ///
  /// <b>[Parameters:]</b><br>
  /// [shippingMethod] Shipping method.
  ///

  void setPaymentShippingMethod(String shippingMethod){
    _nullCheckExtraPaymentInfo();
    extraPaymentInfo![SpaySdk.EXTRA_SHIPPING_METHOD] = shippingMethod;
  }

  /// API to set if payment is recurring.
  ///
  /// <b>[Parameters:]</b><br>
  /// [isRecurring] True, if payment is recurring.
  ///

  void setRecurringEnabled(bool isRecurring){
    this.isRecurring = isRecurring;
  }

  ///@nodoc
  void _nullCheckExtraPaymentInfo(){
    if (extraPaymentInfo == null) {
      extraPaymentInfo = {};
    }
  }

  /// API to return the country code, where merchant is operating.
  /// Return Country code for region where merchant is operating.
  ///

  String? getMerchantCountryCode() {
    return merchantCountryCode;
  }

  /// API to return the merchant reference ID.
  ///
  /// Return Merchant reference ID which can be used for merchant's own purpose.<br>
  ///         For example, if merchant uses a Payment Gateway which requires Payment Gateway User ID,
  ///         then merchantId field can be set with a Payment Gateway User ID.<br>
  ///
  ///

  String? getMerchantId() {
    return merchantId;
  }

  /// API to return the merchant name.
  /// Return Merchant name.
  ///

  String getMerchantName() {
    return merchantName;
  }

  /// API to return the order number for transaction.
  /// Return Order number which is sent by merchant for records.
  ///

  String? getOrderNumber() {
    return orderNumber;
  }

  /// API to return the card brand which was used in the current transaction.<br>
  /// Partner can get this information if needed. They can use this for their own purpose.<br>
  /// This API method can be used in
  /// [CustomSheetTransactionInfoListener.onSuccess(CustomSheetPaymentInfo, String, Bundle)] callback only.<br>
  ///
  /// This api is available only with US Samsung Wallet app.<br>
  /// Return Card brand which was used in the current transaction.
  ///

  Brand? getPaymentCardBrand(){
    _nullCheckExtraPaymentInfo();
    return extraPaymentInfo![SpaySdk.EXTRA_CARD_BRAND];
  }

  /// API to return the last 4 digits of DPAN which was used in the current transaction.<br>
  /// Partner can get this information if needed. They can use this for their own purpose.<br>
  /// This API method can be used in
  /// [CustomSheetTransactionInfoListener.onSuccess(CustomSheetPaymentInfo, String, Bundle)] callback only.<br>
  ///
  /// This api is available only with US Samsung Wallet app.<br>
  /// Return The last 4 digits of DPAN which was used in the current transaction.
  ///

  String? getPaymentCardLast4DPAN() {
    _nullCheckExtraPaymentInfo();
    return extraPaymentInfo![SpaySdk.EXTRA_LAST4_DPAN];
  }

  /// API to return the last 4 digits of FPAN which was used in the current transaction.<br>
  /// Partner can get this information if needed. They can use this for their own purpose.<br>
  /// This API method can be used in
  /// [CustomSheetTransactionInfoListener.onSuccess(CustomSheetPaymentInfo, String, Bundle)] callback only.<br>
  ///
  /// This api is available only with US Samsung Wallet app.<br>
  /// Return The last 4 digits of FPAN which was used in the current transaction.
  ///

  String? getPaymentCardLast4FPAN() {
    _nullCheckExtraPaymentInfo();
    return extraPaymentInfo![SpaySdk.EXTRA_LAST4_FPAN];
  }

  /// API to return the ISO currency code which was used in the current transaction.<br>
  /// Partner can get this information if needed. They can use this for their own purpose.<br>
  /// This API method can be used in
  /// [CustomSheetTransactionInfoListener.onSuccess(CustomSheetPaymentInfo, String, Bundle)] callback only.<br>
  ///
  /// This api is available only with US Samsung Wallet app.<br>
  /// Return Currency code which was used in the current transaction.
  ///

  String? getPaymentCurrencyCode() {
    for (SheetControl sheet in customSheet.getSheetControls()!) {
      if (sheet.controltype == Controltype.AMOUNTBOX) {
        AmountBoxControl amountBoxControl = sheet as AmountBoxControl;
        return amountBoxControl.currencyCode;
      }
    }
      return "";
  }

  /// API to return the shipping/delivery address which was used in the current transaction.<br>
  /// Partner can get this information if needed. They can use this for their own purpose.<br>
  /// This API method can be used in
  /// [CustomSheetTransactionInfoListener.onSuccess(CustomSheetPaymentInfo, String, Bundle)] callback only.<br>
  ///
  /// This api is available only with US Samsung Wallet app.<br>
  /// Return Shipping address which was used in the current transaction.
  ///

  Address? getPaymentShippingAddress() {
    for (SheetControl sheet in customSheet.getSheetControls()!) {
      if (sheet.controltype == Controltype.ADDRESS) {
        AddressControl addressControl = sheet as AddressControl;
        if (addressControl.getAddressType() == SheetItemType.SHIPPING_ADDRESS) {
          return addressControl.getAddress();
        }
      }
    }
      return null;
  }

  /// API to return the shipping method which was used in the current transaction.<br>
  /// Partner can get this information if needed. They can use this for their own purpose.<br>
  /// This API method can be used in
  /// [CustomSheetTransactionInfoListener.onSuccess(CustomSheetPaymentInfo, String, Bundle)] callback only.<br>
  ///
  /// This api is available only with US Samsung Wallet app.<br>
  /// Return Shipping method which was used in the current transaction.
  ///

  String getPaymentShippingMethod() {
    _nullCheckExtraPaymentInfo();
    return extraPaymentInfo![SpaySdk.EXTRA_SHIPPING_METHOD];
  }

  ///@nodoc
  factory CustomSheetPaymentInfo.fromJson(Map<String, dynamic> json, SheetUpdatedListener? sheetUpdatedListener){
    CustomSheet customSheet = CustomSheet();
    customSheet = CustomSheet.fromJson(json["customSheet"], sheetUpdatedListener);
    CustomSheetPaymentInfo customSheetPaymentInfo = CustomSheetPaymentInfo(merchantName: json["merchantName"].toString(), customSheet: customSheet);
    customSheetPaymentInfo.merchantId = json["merchantId"].toString();
    customSheetPaymentInfo.orderNumber = json["orderNumber"].toString();
    if(json["addressInPaymentSheet"] == AddressInPaymentSheet.DO_NOT_SHOW.name) {
      customSheetPaymentInfo.addressInPaymentSheet = AddressInPaymentSheet.DO_NOT_SHOW;
    } else if(json["addressInPaymentSheet"] == AddressInPaymentSheet.NEED_BILLING_AND_SHIPPING.name)
      customSheetPaymentInfo.addressInPaymentSheet = AddressInPaymentSheet.NEED_BILLING_AND_SHIPPING;
    else if(json["addressInPaymentSheet"] == AddressInPaymentSheet.NEED_BILLING_SEND_SHIPPING.name)
      customSheetPaymentInfo.addressInPaymentSheet == AddressInPaymentSheet.NEED_BILLING_SEND_SHIPPING;
    else if(json["addressInPaymentSheet"] == AddressInPaymentSheet.NEED_BILLING_SPAY.name)
      customSheetPaymentInfo.addressInPaymentSheet == AddressInPaymentSheet.NEED_BILLING_SPAY;
    else if(json["addressInPaymentSheet"] == AddressInPaymentSheet.NEED_SHIPPING_SPAY.name)
      customSheetPaymentInfo.addressInPaymentSheet == AddressInPaymentSheet.NEED_SHIPPING_SPAY;
    else if(json["addressInPaymentSheet"] == AddressInPaymentSheet.SEND_SHIPPING.name)
      customSheetPaymentInfo.addressInPaymentSheet == AddressInPaymentSheet.SEND_SHIPPING;

    List<Brand> brandlist =[];
    if(json["allowedCardBrand"] == null){
      customSheetPaymentInfo.allowedCardBrand =  brandlist;
    }
    else{
      for(var brand in json["allowedCardBrand"]){
        if(brand == Brand.VISA.name) {
          brandlist.add(Brand.VISA);
        } else if(brand == Brand.MASTERCARD.name)
          brandlist.add(Brand.MASTERCARD);
        else if(brand == Brand.AMERICANEXPRESS.name)
          brandlist.add(Brand.AMERICANEXPRESS);
        else if(brand == Brand.CHINAUNIONPAY.name)
          brandlist.add(Brand.CHINAUNIONPAY);
        else if(brand == Brand.DISCOVER.name)
          brandlist.add(Brand.DISCOVER);
        else if(brand == Brand.ECI.name)
          brandlist.add(Brand.ECI);
        else if(brand == Brand.PAGOBANCOMAT.name)
          brandlist.add(Brand.PAGOBANCOMAT);
        else if(brand == Brand.OCTOPUS.name)
          brandlist.add(Brand.OCTOPUS);
        else if(brand == Brand.MADA.name)
          brandlist.add(Brand.MADA);
      }
      customSheetPaymentInfo.allowedCardBrand =  brandlist;
    }
    customSheetPaymentInfo.isCardHolderNameRequired = json["isCardHolderNameRequired"];
    customSheetPaymentInfo.isRecurring = json["isRecurring"];
    customSheetPaymentInfo.merchantCountryCode = json["merchantCountryCode"].toString();
    customSheetPaymentInfo.extraPaymentInfo = json["extraPaymentInfo"];
    if(json["cardInfo"] != null) {
      customSheetPaymentInfo.cardInfo = PaymentCardInfo.fromJson(json["cardInfo"]);
    }

    return customSheetPaymentInfo;
  }

  ///@nodoc
  Map<String, dynamic> toJson() {
    Map<String,dynamic> customSheetPaymentInfoJson={};
    if(merchantId!= null) {
      customSheetPaymentInfoJson["merchantId"] = merchantId;
    }
    customSheetPaymentInfoJson["merchantName"] = merchantName;
    if(orderNumber != null){
      customSheetPaymentInfoJson["orderNumber"] = orderNumber;
    }
    if(addressInPaymentSheet?.name != null) {
      customSheetPaymentInfoJson["addressInPaymentSheet"] = addressInPaymentSheet?.name;
    }
    if(allowedCardBrand != null){
      customSheetPaymentInfoJson["allowedCardBrand"] = allowedCardBrand?.map((x) => x.name).toList();
    }
    if(isCardHolderNameRequired!= null) {
      customSheetPaymentInfoJson["isCardHolderNameRequired"] = isCardHolderNameRequired;
    }
    if(isRecurring != null) {
      customSheetPaymentInfoJson["isRecurring"] = isRecurring;
    }
    if(merchantCountryCode!= null) {
      customSheetPaymentInfoJson["merchantCountryCode"] = merchantCountryCode;
    }
    customSheetPaymentInfoJson["customSheet"] = customSheet.toJson();
    if(extraPaymentInfo != null){
      customSheetPaymentInfoJson["extraPaymentInfo"] = extraPaymentInfo;
    }
    return customSheetPaymentInfoJson;
  }
}
