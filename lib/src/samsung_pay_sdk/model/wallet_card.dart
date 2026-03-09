


/// This class provides card information related to the card management operations.
///

class WalletCard{
  /// Card is fully registered on Samsung Pay and current state is "active".
  ///

  static const String ACTIVE = "ACTIVE";
  /// Card is deleted from Samsung Pay.
  ///

  static const String DISPOSED = "DISPOSED";
  /// Card is registered on Samsung Pay, but its current status is "expired".<br>
  /// This might occur if the card or token expiration time has reached and Samsung Pay
  /// has not renewed it.
  ///

  static const String EXPIRED = "EXPIRED";
  /// Card is not fully registered on Samsung Pay and current state is just "enrolled".
  ///
  /// @nodoc

  static const String PENDING_ENROLLED = "ENROLLED";
  /// Card is not fully registered on Samsung Pay and current state is "pending provision".<br>
  /// Usually, this state returns when the user has not completed the secondary authentication(IDV).
  ///

  static const String PENDING_PROVISION = "PENDING_PROVISION";
  /// Card is registered on Samsung Pay and current state is "suspended".<br>
  /// Suspend can be triggered by issuer, card network, or the user.
  ///

  static const String SUSPENDED = "SUSPENDED";
  /// Card is registered on Samsung Pay but not activated yet.<br>
  /// A notification of card activation is expected to be pushed to Samsung Pay in a moment.
  ///

  static const String PENDING_ACTIVATION = "PENDING_ACTIVATION";
  ///  Indicates that the key for card type.
  ///

  static const String CARD_TYPE = "CARD_TYPE";
  ///  Indicates that the card type is either credit or debit. This is a valid type for  AddCardInfo#setCardType(String)
  ///

  static const String CARD_TYPE_CREDIT_DEBIT = "PAYMENT";
  ///  Indicates that the card type is gift card.
  ///

  static const String CARD_TYPE_GIFT = "GIFT";
  ///  Indicates that the card type is loyalty card.
  ///

  static const String CARD_TYPE_LOYALTY = "LOYALTY";
  ///  Indicates that the card type is credit card. This is a valid type for AddCardInfo#setCardType(String)
  ///

  static const String CARD_TYPE_CREDIT = "CREDIT";
  ///  Indicates that the card type is debit card. This is a valid type for AddCardInfo#setCardType(String)
  ///

  static const String CARD_TYPE_DEBIT = "DEBIT";
  ///  Indicates that the card type is transit card.
  ///

  static const String CARD_TYPE_TRANSIT = "TRANSIT";
  ///  Indicates that the card type is vaccine pass. <br>
  ///

  static const String CARD_TYPE_VACCINE_PASS = "VACCINE_PASS";

  String cardBrand;
  String cardId;
  CardInfo cardInfo;
  String cardStatus;

  ///@nodoc
  /// Constructor to create WalletCard.<br>
  ///
  ///<b>[Parameters:]</b><br>
  /// [cardId] Unique ID to refer a card in Samsung Wallet.<br>
  /// [cardStatus] Current card status.<br>
  /// [cardBrand] Supported card brand.<br>
  /// [cardInfo] constructing CardInfo object which is passed to Samsung Wallet from merchant. Check the [CardInfo] class. <br>
  WalletCard( {
    required this.cardId,
    required this.cardStatus,
    required this.cardBrand,
    required this.cardInfo
  });

  ///@nodoc
  factory WalletCard.fromJson(Map<String, dynamic> json) => WalletCard(
    cardBrand: json["cardBrand"],
    cardId: json["cardId"],
    cardInfo: CardInfo.fromJson(json["cardInfo"]),
    cardStatus: json["cardStatus"],
  );

  ///@nodoc
  Map<String, dynamic> toJson() => {
    "cardBrand": cardBrand,
    "cardId": cardId,
    "cardInfo": cardInfo.toJson(),
    "cardStatus": cardStatus,
  };
}

/// This class provides card information such as card brand.
/// Supported card brands are as follows:<br><br>
/// - AMERICAN EXPRESS, MASTERCARD, VISA <br>
/// - CHINA UNIONPAY (For China)<br><br>
///


class CardInfo {
  String? app2AppPayload;
  String? cardType;
  String? deviceType;
  String? issuerName;
  String? app2AppIntent;
  String? last4Dpan;
  String? last4Fpan;

  ///Constructor

  CardInfo({
    required this.app2AppPayload,
    required this.cardType,
    required this.deviceType,
    required this.issuerName,
    required this.app2AppIntent,
    required this.last4Dpan,
    required this.last4Fpan,
  });

  ///@nodoc
  factory CardInfo.fromJson(Map<String, dynamic> json) {
    return CardInfo(
      app2AppPayload: json["app2AppPayload"],
      cardType: json["cardType"],
      deviceType: json["deviceType"],
      issuerName: json["issuerName"],
      app2AppIntent: json["app2AppIntent"],
      last4Dpan: json["last4Dpan"],
      last4Fpan: json["last4Fpan"],
    );
  }

  ///@nodoc
  Map<String, dynamic> toJson() => {
    "app2AppPayload": app2AppPayload,
    "cardType": cardType,
    "deviceType": deviceType,
    "issuerName": issuerName,
    "app2AppIntent": app2AppIntent,
    "last4Dpan": last4Dpan,
    "last4Fpan": last4Fpan,
  };
}
