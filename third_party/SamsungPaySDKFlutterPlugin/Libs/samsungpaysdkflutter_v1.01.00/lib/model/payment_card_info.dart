import 'dart:convert';

import 'package:samsung_pay_sdk_flutter/samsung_pay_sdk_flutter.dart';

///
/// This class provides card information related to payment operations.<br>
///
/// See [requestCardInfo(PaymentCardInfo paymentCardInfo, CardInfoListener cardInfoListener)]<br>
///

class PaymentCardInfo {
  Brand? brand;
  String? cardId;
  Map<String, dynamic>? cardMetaData;
  List<Brand>? requestFilter=[];


  /// Constructor to create PaymentCardInfo.<br>
  PaymentCardInfo();

  ///@nodoc
  factory PaymentCardInfo.fromJson(Map<String, dynamic> json){
    late Brand brandFromJson;
    if(json["brand"].toString() == Brand.VISA.name) {
      brandFromJson = Brand.VISA;
    } else if(json["brand"].toString() == Brand.MASTERCARD.name)
      brandFromJson= Brand.MASTERCARD;
    else if(json["brand"].toString() == Brand.AMERICANEXPRESS.name)
      brandFromJson = Brand.AMERICANEXPRESS;
    else if(json["brand"].toString() == Brand.CHINAUNIONPAY.name)
      brandFromJson = Brand.CHINAUNIONPAY;
    else if(json["brand"].toString() == Brand.DISCOVER.name)
      brandFromJson = Brand.DISCOVER;
    else if(json["brand"].toString() == Brand.ECI.name)
      brandFromJson = Brand.ECI;
    else if(json["brand"].toString() == Brand.PAGOBANCOMAT.name)
      brandFromJson = Brand.PAGOBANCOMAT;
    else if(json["brand"].toString() == Brand.OCTOPUS.name)
      brandFromJson = Brand.OCTOPUS;
    else if(json["brand"].toString() == Brand.MADA.name)
      brandFromJson = Brand.MADA;

    PaymentCardInfo paymentCardInfo = PaymentCardInfo();
    paymentCardInfo.brand = brandFromJson;
    paymentCardInfo.cardId = json["cardId"].toString();
    paymentCardInfo.cardMetaData = json["cardMetaData"];
    return paymentCardInfo;
  }

  ///@nodoc
  Map<String, dynamic> toJson(){
    Map<String, dynamic> data={};
    data.addAll({
      "brandList": requestFilter!.map((e) => e.name).toList(),
    });
    return data;
  }

  /// Add requested brand filter
  void addBrand(Brand brand){
    requestFilter?.add(brand);
  }
}