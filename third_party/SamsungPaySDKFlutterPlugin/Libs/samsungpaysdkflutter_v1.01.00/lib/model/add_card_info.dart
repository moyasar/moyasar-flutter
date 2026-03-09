
import 'dart:convert';

import 'package:samsung_pay_sdk_flutter/model/wallet_card.dart';
import 'package:samsung_pay_sdk_flutter/samsung_pay_sdk_flutter.dart';

/// This class provides card information for enrollment.
///

class AddCardInfo{
  ///  Key to represent encrypted blob from issuer on cardDetail bundle.
  ///

  static const String EXTRA_PROVISION_PAYLOAD = "provisionPayload";
  ///  Key to represent issuer bin range.
  ///

  static const String EXTRA_ISSUER_ID = "issuerId";
  ///  Indicates that the card tokenization provider is VISA.
  ///

  static const String PROVIDER_VISA = "VI";
  ///  Indicates that the card tokenization provider is MASTERCARD.
  ///

  static const String PROVIDER_MASTERCARD = "MC";
  ///  Indicates that the card tokenization provider is AMEX.
  ///

  static const String PROVIDER_AMEX = "AX";
  ///  Indicates that the card tokenization provider is DISCOVER.
  ///

  static const String PROVIDER_DISCOVER = "DS";
  ///  Indicates that the card tokenization provider is GEMALTO.
  ///  Use 'PROVIDER_GEMALTO' instead.
  ///

  static const String PROVIDER_GTO = "GTO";
  ///  Indicates that the card tokenization provider is PLCC.
  ///

  static const String PROVIDER_PLCC = "PL";
  ///  Indicates that the card tokenization provider is GIFT.
  ///

  static const String PROVIDER_GIFT = "GI";
  ///  Indicates that the card tokenization provider is LOYALTY.
  ///

  static const String PROVIDER_LOYALTY = "LO";
  ///  Indicates that the card tokenization provider is PayPal.
  ///

  static const String PROVIDER_PAYPAL = "PP";
  ///  Indicates that the card tokenization provider is GEMALTO.
  ///

  static const String PROVIDER_GEMALTO = "GT";
  ///  Indicates that the card tokenization provider is NAPAS.
  ///

  static const String PROVIDER_NAPAS = "NP";
  ///  Indicates that the card tokenization provider is MIR.
  ///

  static const String PROVIDER_MIR = "MI";
  ///  Indicates that the card tokenization provider is PagoBANCOMAT.
  ///

  static const String PROVIDER_PAGOBANCOMAT = "PB";
  ///  Key to represent a Samsung Pay Card for push provisioning.<br>
  ///  If the key value is true, the current push provisioning card will have a Samsung Pay Card type in Samsung Wallet application.<br>
  ///  This is only for specific issuer in UK.
  ///

  static const String EXTRA_SAMSUNG_PAY_CARD = "extra_samsung_pay_card";
  ///  Indicates that the card tokenization provider is VaccinePass.<br>
  ///  refer addCard(AddCardInfo, AddCardListener) in detail.<br>
  /// <br>
  ///
  ///<br/><font color="blue">
  ///    <b>Json Object Specification</b><br>
  ///</font>
  ///
  /// Mandatory fields: version, cardId, type, cardArt, qrData, decoding, chunks, chunk,
  /// provider.name, patient.name, vaccine.product, vaccine.date, performer
  ///

  static const String PROVIDER_VACCINE_PASS = "VaccinePass";
  ///  Key to send extra transit card data to Samsung Pay for Russia Virtual Troika project.<br>
  ///  The format of the data should be JSON string object.
  ///

  static const String EXTRA_KEY_MOSCOW_TRANSIT = "extra_transit_card_data";

  static final List<String> allowedCardTypes = [
    WalletCard.CARD_TYPE_CREDIT_DEBIT,
    WalletCard.CARD_TYPE_CREDIT,
    WalletCard.CARD_TYPE_DEBIT,
    WalletCard.CARD_TYPE_VACCINE_PASS
  ];

  String? cardType;// CREDIT, DEBIT, GIFT, LOYALTY
  ///for PROVIDER_PAYPAL, PROVIDER_GEMALTO, PROVIDER_NAPAS, PROVIDER_MIR
  ///

  String? tokenizationProvider;
  ///for EXTRA_SAMSUNG_PAY_CARD
  ///

  Map<String, dynamic>? cardDetail;

  /// Constructor to create AddCardInfo instance. <br>
  ///
  /// <b>[Parameters:]</b><br>
  /// [cardType] Card type to add.
  ///
  /// [tokenizationProvider] Tokenization provider of the card.
  ///
  /// [cardDetail] Card detail which partner wants to pass to Samsung Pay.
  ///
  /// <b>[Exceptions:]</b><br>
  /// Throws an [ArgumentError] if not allowed card type is used. Or cardDetail does not contain [EXTRA_PROVISION_PAYLOAD]. <br>
  /// Throws an [ArgumentError] if tokenizationProvider or cardDetail is empty. <br>
  ///

  AddCardInfo(String cardType, String tokenizationProvider,  Map<String, dynamic> cardDetail){
    _verifyCardTypeAllowed(cardType);
   if(tokenizationProvider.isEmpty || cardDetail.isEmpty){
     throw ArgumentError("Input parameter must be set");
   }
    _verifyProvisionPayload(tokenizationProvider, cardDetail);
   this.cardType = cardType;
   this.tokenizationProvider = tokenizationProvider;
   this.cardDetail = cardDetail;
  }

  void _verifyCardTypeAllowed (String cardType) {
    if (!allowedCardTypes.contains(cardType)) {
      throw ArgumentError("Not allowed card type is used : $cardType");
    }
  }

  void _verifyProvisionPayload(String tokenizationProvider,  Map<String, dynamic> bundle) {
    String payload = "";
    if (bundle[EXTRA_PROVISION_PAYLOAD] == null) {
      throw ArgumentError("Provision payload must be provided");
    }
    else {
      payload= bundle[EXTRA_PROVISION_PAYLOAD];
    }
    if (tokenizationProvider == AddCardInfo.PROVIDER_MASTERCARD) {
      try {
        base64.decode(payload);
      } catch ( e) {
        throw ArgumentError("In case of Mastercard, payload should be Base64 encoded. Please double check it");
      }
    }
  }


  AddCardInfo._builder({
  required this.cardType,
  required this.tokenizationProvider,
  required this.cardDetail,
  });

  ///@nodoc
  factory AddCardInfo.fromJson(Map<String, dynamic> json) => AddCardInfo._builder(
  cardType: json["cardType"],
  tokenizationProvider: json["tokenizationProvider"],
  cardDetail: json["cardDetail"],
  );

  ///@nodoc
  Map<String, dynamic> toJson() => {
  "cardType": cardType,
  "tokenizationProvider": tokenizationProvider,
  "cardDetail": cardDetail,
  };
}