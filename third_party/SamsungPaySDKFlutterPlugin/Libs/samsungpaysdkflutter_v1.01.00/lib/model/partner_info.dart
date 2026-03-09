


import 'package:samsung_pay_sdk_flutter/samsung_pay_sdk_flutter.dart';

///
/// This class holds the partner information.
/// Any third party application using the Samsung Pay SDK is considered as partner app.<br>
/// The third party application can be an issuer app (bank app), merchant app, and so on.
///

class PartnerInfo{
  String serviceId;
  Map<String,dynamic> data;

  /// Constructor to create Partner Information.<br>
  ///
  /// <b>[Parameters:]</b><br>
  /// [serviceId]
  ///      Unique ID to represent the service. Partner should on-board
  ///      with Samsung Pay Developers to receive this ID.
  /// [data]
  ///      Extra data which partner wants to pass to Samsung Pay.<br>
  ///      If partner app integrates SDK v1.4.00 or higher, Service Type must be set in data bundle.<br>
  ///      Refer to the usage sample below.
  ///
  /// Extra data bundle key-value pairs are defined as follows:<br><br>
  /// <table>
  ///     <tr style="border:1px solid black;">
  ///         <th style="border:1px solid black;">Keys</th>
  ///         <th style="border:1px solid black;">Values</th>
  ///     </tr>
  ///     <tr style="border:1px solid black;">
  ///         <td style="border:1px solid black;">[SpaySdk.EXTRA_ISSUER_NAME]</td>
  ///         <td style="border:1px solid black;">String issuerName (issuerCode for Korean issuers)<br>
  ///          Issuer: mandatory. Merchant: not required.</td>
  ///     </tr>
  ///     <tr style="border:1px solid black;">
  ///         <td style="border:1px solid black;">[SpaySdk.PARTNER_SERVICE_TYPE]</td>
  ///         <td style="border:1px solid black;">String SamsungPay.ServiceType.ABC.toString()<br>
  ///           This value is mandatory because it will be used to verify if the service type is allowed or not.</td>
  ///     </tr>
  /// </table>
  ///

  PartnerInfo({
    required this.serviceId,
    required this.data,
  });

  ///@nodoc
  factory PartnerInfo.fromJson(Map<String, dynamic> json) => PartnerInfo(
    serviceId: json["ServiceId"],
    data: json["data"],
  );

  ///@nodoc
  Map<String, dynamic>? toJson() => {
    "ServiceId": serviceId,
    "data": data,
  };
}
