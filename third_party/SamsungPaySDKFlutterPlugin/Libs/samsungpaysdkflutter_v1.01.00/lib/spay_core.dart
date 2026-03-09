import 'package:samsung_pay_sdk_flutter/model/wallet_card.dart';

///
/// This class allows to define Samsung Pay SDK information, common error codes, and constants.
///
class SpaySdk{
  ///
  ///This error indicates that requested operation is success with no error.
  ///
  static const int ERROR_NONE = 0;
  ///
  ///his error indicates that internal error has occurred while the requested operation is going on.
  ///
  static const int ERROR_SPAY_INTERNAL = -1;
  ///
  ///This error indicates that the given input is invalid.
  ///
  static const int ERROR_INVALID_INPUT = -2;
  ///
  /// This error indicates that requested operation is not supported in Samsung Pay.
  ///
  static const int ERROR_NOT_SUPPORTED = -3;
  ///
  /// This error indicates that given card ID is not found in Samsung Pay.
  ///
  static const int ERROR_NOT_FOUND = -4;
  ///
  /// This error indicates that requested operation is already done.<br>
  /// For example, adding a card to Samsung Wallet but the card is already added either via Samsung Wallet or issuer app.
  ///
  static const int ERROR_ALREADY_DONE = -5;
  ///
  ///This error indicates that requested operation is not allowed.<br>
  ///For example, partner app verification has failed in Samsung Pay server.
  ///
  static const int ERROR_NOT_ALLOWED = -6;
  ///
  ///This error indicates that user has cancelled before completing the requested operation.<br>
  ///For example, user taps the cancel or back key on the payment sheet.
  ///
  static const int ERROR_USER_CANCELED = -7;
  ///
  /// This error indicates that SDK API level is missing or invalid.<br>
  /// Partner must set valid API level in the AndroidManifest file. Minimum possible version is 1.4.<br>
  /// Also if the Partner set the values defined in higher API level, Samsung Pay will send this error to partner app.<br>
  /// This is returned as [EXTRA_ERROR_REASON] for [ERROR_PARTNER_INFO_INVALID] error.<br>
  ///
  /// Since API Level 1.4
  ///
  static const int ERROR_PARTNER_SDK_API_LEVEL = -10;
  ///
  /// This error indicates that the Service Type is invalid.<br>
  /// Partner must set valid Service Type in PartnerInfo when calling APIs.<br>
  /// This is returned as [EXTRA_ERROR_REASON] for [SPAY_NOT_READY] error.<br>
  ///
  /// Since API Level 1.4
  ///
  static const int ERROR_PARTNER_SERVICE_TYPE = -11;
  ///
  /// This error indicates that requested operation contains invalid parameter or invalid bundle key/value.
  ///
  /// Since API Level 2.3
  ///
  static const int ERROR_INVALID_PARAMETER = -12;
  ///
  ///This error indicates that Samsung Pay is unable to connect to the server since there is no network.<br>
  ///For example, partner app tries to verify with server while network is not connected.
  ///
  static const int ERROR_NO_NETWORK = -21;
  ///
  ///This error indicates that server did not respond to the Samsung Pay request.<br>
  ///
  static const int ERROR_SERVER_NO_RESPONSE = -22;
  ///
  ///This error indicates that partner information is invalid.<br>
  ///For example, partner app is using SDK version not allowed, invalid service type, wrong api level, and so on.
  ///
  ///Since API Level 2.5
  ///
  static const int ERROR_PARTNER_INFO_INVALID = -99;
  ///
  /// This error indicates that session initiation or service binding has failed.<br>
  /// For example, if the service connection with Samsung Pay was not successful.
  ///
  static const int ERROR_INITIATION_FAIL = -103;
  ///
  /// This error indicates that the card provisioning has failed.<br>
  ///
  /// Since API Level 1.2
  ///
  static const int ERROR_REGISTRATION_FAIL = -104;
  ///
  /// This error indicates that duplicate API called by Partner.<br>
  ///
  /// Since API Level 2.1
  ///
  static const int ERROR_DUPLICATED_SDK_API_CALLED = -105;
  ///
  /// This error indicates that the Samsung Pay SDK is not supported in particular region.<br>
  /// This is returned as [EXTRA_ERROR_REASON] for [ERROR_NOT_ALLOWED] error.<br>
  /// For example, if the device is from the country that Samsung Pay SDK is not supported,
  /// then the partner app verification will be failed.<br>
  ///
  static const int ERROR_SDK_NOT_SUPPORTED_FOR_THIS_REGION = -300;
  ///
  /// This error indicates that product ID is not registered with the Samsung Pay Developers.<br>
  /// This is returned as [EXTRA_ERROR_REASON] for [ERROR_NOT_ALLOWED] error.<br>
  /// For example, if invalid product ID was used in partner app,
  /// then the partner app verification will be failed.
  /// Deprecated use [ERROR_SERVICE_ID_INVALID] instead
  ///
  @Deprecated('Deprecated')
  static const int ERROR_PRODUCT_ID_INVALID = -301;
  ///
  /// This error indicates that service ID is not registered with the Samsung Pay Developers.<br>
  /// This is returned as [EXTRA_ERROR_REASON] for [ERROR_NOT_ALLOWED] error.<br>
  /// For example, if invalid service ID was used in partner app,
  /// then the partner app verification will be failed.
  ///
  /// Since API Level 2.5
  ///
  static const int ERROR_SERVICE_ID_INVALID = -301;
  ///
  /// This error indicates that SDK support is not available for partner's product in particular region.
  /// Deprecated use [ERROR_SERVICE_UNAVAILABLE_FOR_THIS_REGION] instead
  ///
  @Deprecated('Deprecated')
  static const int ERROR_PRODUCT_UNAVAILABLE_FOR_THIS_REGION = -302;
  ///
  /// This error indicates that SDK support is not available for partner's service in particular region.
  ///
  /// Since API Level 2.5
  ///
  static const int ERROR_SERVICE_UNAVAILABLE_FOR_THIS_REGION = -302;
  ///
  /// This error indicates that product and product ID does not match on the Samsung Pay Developers.<br>
  /// This is returned as [EXTRA_ERROR_REASON] for [ERROR_NOT_ALLOWED] error.<br>
  /// For example, if the registered partner app information is not matched with product ID,
  /// then the partner app verification will be failed.
  /// Deprecated use [ERROR_SERVICE_NOT_VERIFIED_WITH_PARTNER] instead
  ///
  @Deprecated('Deprecated')
  static const int ERROR_PRODUCT_NOT_VERIFIED_WITH_PARTNER = -303;
  ///
  /// This error indicates that service and service ID does not match on the Samsung Pay Developers.<br>
  /// This is returned as [EXTRA_ERROR_REASON] for [ERROR_NOT_ALLOWED] error.<br>
  /// For example, if the registered partner app information is not matched with service ID,
  /// then the partner app verification will be failed.
  ///
  /// Since API Level 2.5
  /// Deprecated use [ERROR_PARTNER_APP_SIGNATURE_MISMATCH] instead
  ///
  @Deprecated('Deprecated')
  static const int ERROR_SERVICE_NOT_VERIFIED_WITH_PARTNER = -303;
  ///
  /// This error indicates that the app signature is different from the one registered from Samsung Pay Developers.<br>
  /// This is returned as [EXTRA_ERROR_REASON] for [ERROR_NOT_ALLOWED] error.<br>
  /// For example, if different signature is used for signing apk, the partner app verification will be failed.<br>
  /// Checking signature logic will be activated in case debug mode is "N".
  ///
  /// Since API Level 2.9
  ///
  static const int ERROR_PARTNER_APP_SIGNATURE_MISMATCH = -303;
  ///
  /// This error indicates that product version is not supported by Samsung Pay.<br>
  /// This is returned as [EXTRA_ERROR_REASON] for [ERROR_NOT_ALLOWED] error.<br>
  /// For example, if the version is not registered,
  /// then the partner app verification will be failed.
  /// Deprecated use [ERROR_SERVICE_VERSION_NOT_SUPPORTED] instead
  ///
  @Deprecated('Deprecated')
  static const int ERROR_PRODUCT_VERSION_NOT_SUPPORTED = -304;
  ///
  /// This error indicates that service version is not supported by Samsung Pay.<br>
  /// This is returned as [EXTRA_ERROR_REASON] for [ERROR_NOT_ALLOWED] error.<br>
  /// For example, if the version is not registered,
  /// then the partner app verification will be failed.
  ///
  /// Since API Level 2.5
  /// Deprecated use [ERROR_PARTNER_APP_VERSION_NOT_SUPPORTED] instead
  ///
  @Deprecated('Deprecated')
  static const int ERROR_SERVICE_VERSION_NOT_SUPPORTED = -304;
  ///
  /// This error indicates that app version is not supported by Samsung Pay.<br>
  /// This is returned as [EXTRA_ERROR_REASON] for [ERROR_NOT_ALLOWED] error.<br>
  /// For example, if the version registered from developer portal is higher than current version(or no any version registered),
  /// then the partner app verification will be failed.<br>
  ///
  /// Since API Level 2.9
  ///
  static const int ERROR_PARTNER_APP_VERSION_NOT_SUPPORTED = -304;
  ///
  /// This error indicates that product version is removed/blocked by the Samsung Pay Developers.<br>
  /// This is returned as [EXTRA_ERROR_REASON] for [ERROR_NOT_ALLOWED] error.<br>
  /// For example, if the partner app is blocked,
  /// then the partner app verification will be failed.
  /// Deprecated use [ERROR_SERVICE_BLOCKED] instead
  ///
  @Deprecated('Deprecated')
  static const int ERROR_PRODUCT_BLOCKED = -305;
  ///
  /// This error indicates that service version is removed/blocked by the Samsung Pay Developers.<br>
  /// This is returned as [EXTRA_ERROR_REASON] for [ERROR_NOT_ALLOWED] error.<br>
  /// For example, if the partner app is blocked,
  /// then the partner app verification will be failed.
  ///
  /// Since API Level 2.5
  /// Deprecated use [ERROR_PARTNER_APP_BLOCKED] instead
  ///
  @Deprecated('Deprecated')
  static const int ERROR_SERVICE_BLOCKED = -305;
  ///
  /// This error indicates that partner app version is removed/blocked by the Samsung Pay Developers.<br>
  /// This is returned as [EXTRA_ERROR_REASON] for [ERROR_NOT_ALLOWED] error.<br>
  /// For example, if the partner app is blocked,
  /// then the partner app verification will be failed.
  ///
  /// Since API Level 2.9
  ///
  static const int ERROR_PARTNER_APP_BLOCKED = -305;
  ///
  /// This error indicates that user account is not registered for using debug mode on the Samsung Pay Developers.<br>
  /// This is returned as [EXTRA_ERROR_REASON] for [ERROR_NOT_ALLOWED] error.<br>
  /// For example, if the partner app is in debug mode but the Samsung Account is not registered for the debug-api-key,
  /// then the partner app verification will be failed.
  ///
  static const int ERROR_USER_NOT_REGISTERED_FOR_DEBUG = -306;
  ///
  /// This error indicates that product version is not approved for release by the Samsung Pay Developers.<br>
  /// This is returned as [EXTRA_ERROR_REASON] for [ERROR_NOT_ALLOWED] error.<br>
  /// For example, if the partner app is not registered for release mode,
  /// then the partner app verification will be failed.
  /// Deprecated use [ERROR_SERVICE_NOT_APPROVED_FOR_RELEASE]
  ///
  @Deprecated('Deprecated')
  static const int ERROR_PRODUCT_NOT_APPROVED_FOR_RELEASE = -307;
  ///
  /// This error indicates that service version is not approved for release by the Samsung Pay Developers.<br>
  /// This is returned as [EXTRA_ERROR_REASON] for [ERROR_NOT_ALLOWED] error.<br>
  /// For example, if the partner app is not registered for release mode,
  /// then the partner app verification will be failed.
  ///
  /// Since API Level 2.5
  ///
  static const int ERROR_SERVICE_NOT_APPROVED_FOR_RELEASE = -307;
  ///
  /// This error indicates that partner registration is not done on the Samsung Pay Developers.<br>
  /// This is returned as [EXTRA_ERROR_REASON] for [ERROR_NOT_ALLOWED] error.<br>
  /// For example, if the partner app is submitted but not approved,
  /// then the partner app verification will be failed.
  ///
  static const int ERROR_PARTNER_NOT_APPROVED = -308;
  ///
  /// This error indicates that the partner is not authorized for this request type such as payment or enrollment.<br>
  /// This is returned as [EXTRA_ERROR_REASON] for [ERROR_NOT_ALLOWED] error.<br>
  /// For example, if the merchant app calls enrollment API,
  /// then the partner app verification will be failed.
  ///
  static const int ERROR_UNAUTHORIZED_REQUEST_TYPE = -309;
  ///
  /// This error indicates that debug key is invalid or expired.<br>
  /// This is returned as [EXTRA_ERROR_REASON] for [ERROR_NOT_ALLOWED] error.<br>
  /// For example, if the partner app uses expired debug-api-key,
  /// then the partner app verification will be failed.
  ///
  static const int ERROR_EXPIRED_OR_INVALID_DEBUG_KEY = -310;
  ///
  /// This error indicates that server fails to proceed request due to unknown internal error.<br>
  /// This is returned as [EXTRA_ERROR_REASON] for [ERROR_SPAY_INTERNAL] error.<br>
  /// For example, if the server error occurred while the partner verification is going on,
  /// then the partner app verification will be failed.
  ///
  /// Since API Level 2.5
  ///
  static const int ERROR_SERVER_INTERNAL = -311;
  ///
  /// This error indicates that the device is not a Samsung device.<br>
  /// This is returned as [EXTRA_ERROR_REASON] for [SPAY_NOT_SUPPORTED] error.<br>
  ///
  ///
  static const int ERROR_DEVICE_NOT_SAMSUNG = -350;
  ///
  /// This error indicates that the Samsung Wallet application is not on the device.<br>
  /// This is returned as [EXTRA_ERROR_REASON] for [SPAY_NOT_SUPPORTED] error.<br>
  /// This could mean that the device does not support Samsung Pay.
  ///
  static const int ERROR_SPAY_PKG_NOT_FOUND = -351;
  ///
  /// This error indicates that SDK service is not available on this device.<br>
  /// This is returned as [EXTRA_ERROR_REASON] for [SPAY_NOT_SUPPORTED] error.<br>
  ///
  static const int ERROR_SPAY_SDK_SERVICE_NOT_AVAILABLE = -352;
  ///
  /// This error indicates that device integrity check has failed.<br>
  /// This is returned as [EXTRA_ERROR_REASON] for [SPAY_NOT_SUPPORTED] error.<br>
  ///
  static const int ERROR_DEVICE_INTEGRITY_CHECK_FAIL = -353;
  ///
  /// This error indicates that Samsung Wallet app integrity check has failed.<br>
  /// This is returned as [EXTRA_ERROR_REASON] for [SPAY_NOT_SUPPORTED] error.<br>
  ///
  static const int ERROR_SPAY_APP_INTEGRITY_CHECK_FAIL = -360;
  ///
  /// This error indicates that Android platform version check has failed.<br>
  /// For in-app Payment, the Samsung Pay SDK requires Android 6.0(M) (Android API level 23) or later versions of the Android OS.<br>
  /// This is returned as [EXTRA_ERROR_REASON] for [SPAY_NOT_SUPPORTED] error.<br>
  /// Since API Level 1.5
  ///
  static const int ERROR_ANDROID_PLATFORM_CHECK_FAIL = -361;
  ///
  /// This error indicates that some information by partner is shorter than expected.<br>
  /// This is returned as [EXTRA_ERROR_REASON] for [ERROR_NOT_ALLOWED] error.<br>
  /// For example, if the partner app does not deliver some information to Samsung Pay to get the wallet information,
  /// then Samsung Pay will send this error to partner app.<br>
  /// Also if the partner does not define issuer name on Samsung Pay Developers,
  /// then Samsung Pay will send this error to partner app.
  /// Deprecated use [ERROR_MISSING_INFORMATION] instead.
  ///
  @Deprecated('Deprecated')
  static const int ERROR_SHORT_INFORMATION = -354;
  ///
  /// This error indicates that some information of partner is missing.<br>
  /// This error code is returned as an [EXTRA_ERROR_REASON] of [ERROR_NOT_ALLOWED] error.<br>
  /// For example, if the partner app does not deliver a required information to Samsung Pay to get the wallet information,
  /// then Samsung Pay will send this error to partner app.<br>
  /// Also if the partner does not define the issuer name in Samsung Pay Developer portal,
  /// Samsung Pay will send this error to partner app.<br>
  ///
  static const int ERROR_MISSING_INFORMATION = -354;
  ///
  /// This error indicates that the Samsung Pay setup was not completed.<br>
  /// Partner app need to ask user to set up Samsung Wallet app. If user agrees, call [SamsungPaySdkFlutter.activateSamsungPay] API
  /// .<br>
  /// This is returned as [EXTRA_ERROR_REASON] for [SPAY_NOT_READY] error.<br>
  ///
  static const int ERROR_SPAY_SETUP_NOT_COMPLETED = -356;
  ///
  /// This error indicates that the Samsung Pay should be updated.<br>
  /// Partner app need to ask user to update Samsung Wallet app. If user agrees, call [goToUpdatePage()] API.<br>
  /// This is returned as [EXTRA_ERROR_REASON] for [SPAY_NOT_READY] error.<br>
  ///
  /// Since API Level 1.1
  ///
  static const int ERROR_SPAY_APP_NEED_TO_UPDATE = -357;
  ///
  /// This error indicates that the partner app should be updated.<br>
  /// This is returned as [EXTRA_ERROR_REASON] for [SPAY_NOT_READY] error.<br>
  ///
  /// Since API Level 1.1
  ///
  /// Deprecated use [ERROR_PARTNER_SDK_VERSION_NOT_ALLOWED] instead.
  ///
  @Deprecated('Deprecated')
  static const int ERROR_PARTNER_APP_NEED_TO_UPDATE = -358;
  ///
  /// This error indicates that the partner app is using Samsung Pay SDK not allowed.<br>
  /// This is returned as [EXTRA_ERROR_REASON] for [ERROR_PARTNER_INFO_INVALID] error.<br>
  ///
  /// Since API Level 2.5
  ///
  static const int ERROR_PARTNER_SDK_VERSION_NOT_ALLOWED = -358;
  ///
  /// This error indicates that Samsung Pay is unable to verify partner app at this moment.<br>
  /// This is returned as [EXTRA_ERROR_REASON] for [ERROR_NOT_ALLOWED] error.<br>
  /// For example, Samsung Pay tried to connect to the server and validate partner ID,
  /// but the device does not have the network connectivity.
  ///
  static const int ERROR_UNABLE_TO_VERIFY_CALLER = -359;
  ///
  /// This error indicates that device is locked due to FMM(Find My Mobile).<br>
  /// Partner app needs to ask user to unlock the Samsung Wallet app.
  /// If user agrees, call [activateSamsungPay()] to unlock the Samsung Pay app.<br>
  ///
  /// See [activateSamsungPay()]
  ///
  /// Since API Level 2.1
  ///
  static const int ERROR_SPAY_FMM_LOCK = -604;
  ///
  /// This error indicates that device is connected with an external display.<br>
  /// Due to security reason, Samsung Pay cannot be launched at this moment.<br>
  /// In this case, partner can guide user to disconnect any external display if connected.<br>
  ///
  /// Since API Level 2.7
  ///
  static const int ERROR_SPAY_CONNECTED_WITH_EXTERNAL_DISPLAY = -605;
  ///
  /// Samsung Pay is not supported on this device.<br>
  /// Usually, this status code is returned if the device is not compatible
  /// to run Samsung Pay or if the Samsung Pay app is not installed.
  ///
  /// Since API Level 1.1
  ///
  static const int SPAY_NOT_SUPPORTED = 0;
  ///
  /// Samsung Pay is not completely activated.<br>
  /// Usually, this status code is returned if the user did not complete
  /// the mandatory update or if the user is not signed in with the Samsung Account yet.<br>
  /// In this case, partner app can call [activateSamsungPay()] API
  /// to launch Samsung Pay or can call [goToUpdatePage()] API to update Samsung Wallet app.
  ///
  /// Since API Level 1.1
  ///
  static const int SPAY_NOT_READY = 1;
  ///
  /// Samsung Pay is activated and ready to use.<br>
  /// Usually, this status code is returned after user completes
  /// all the mandatory updates and is signed in.
  ///
  /// Since API Level 1.1
  ///
  static const int SPAY_READY = 2;
  ///
  /// Samsung Pay is not allowed temporally.<br>
  /// Refer extra reason delivered with [EXTRA_ERROR_REASON].<br>
  ///
  /// Since API Level 2.7
  ///
  static const int SPAY_NOT_ALLOWED_TEMPORALLY = 3;
  ///
  /// This code is returned if Samsung Pay has a registered transit card.<br>
  /// This is for Korean issuers only.
  ///
  /// Since API Level 2.8
  ///
  static const int SPAY_HAS_TRANSIT_CARD = 10;
  ///
  /// This code is returned if Samsung Pay doesn't have a registered transit card
  /// This is for Korean issuers only.
  ///
  /// Since API Level 2.8
  ///
  static const int SPAY_HAS_NO_TRANSIT_CARD = 11;
  ///
  ///Device type is phone.
  ///
  ///Since API Level 1.1
  ///
  static const String DEVICE_TYPE_PHONE = "phone";
  ///
  /// Device type is Gear.
  ///
  /// Since API Level 1.1
  ///
  static const String DEVICE_TYPE_GEAR = "gear";
  ///
  /// Key to represent the last four digits of digitalized Personal Identification Number (DPAN).
  ///
  /// Since API Level 1.1
  ///
  static const String EXTRA_LAST4_DPAN = "last4Dpan";
  ///
  /// Key to represent the last four digits of funding Personal Identification Number (FPAN).
  ///
  /// Since API Level 1.1
  ///
  static const String EXTRA_LAST4_FPAN = "last4Fpan";
  ///
  /// Key to represent name of the issuer.<br>
  /// This key can be used in the bundle for [PartnerInfo.PartnerInfo].
  ///
  /// Since API Level 1.1
  ///
  static const String EXTRA_ISSUER_NAME = "issuerName";
  ///
  /// Key to represent names of the issuer from OPM server.<br>
  ///
  /// Since API Level 1.1
  ///
  static const String EXTRA_ISSUER_NAMES = "issuerNames";
  ///
  /// Key to represent package name of the issuer app on Android.
  ///
  /// Since API Level 1.1
  ///
  static const String EXTRA_ISSUER_PKGNAME = "issuerPkgName";
  ///
  /// Key to represent name of the partner app.<br>
  /// This key can be used in the bundle for [PartnerInfo.PartnerInfo].
  ///
  /// Since API Level 2.6
  ///
  static const String EXTRA_PARTNER_NAME = "partnerName";
  ///
  /// Key to represent extra error reasons.
  ///
  /// Since API Level 1.1
  ///
  static const String EXTRA_ERROR_REASON = "errorReason";
  ///
  /// Key to represent extra error reason messages.
  ///
  /// Since API Level 2.9
  ///
  static const String EXTRA_ERROR_REASON_MESSAGE = "errorReasonMessage";
  ///
  /// Key to represent card type.<br>
  /// The possible values are: <br>
  /// [WalletCard.CARD_TYPE_CREDIT_DEBIT]<br>
  /// [WalletCard.CARD_TYPE_CREDIT]<br>
  /// [WalletCard.CARD_TYPE_DEBIT]<br>
  /// [WalletCard.CARD_TYPE_GIFT]<br>
  /// [WalletCard.CARD_TYPE_LOYALTY]<br>
  /// [WalletCard.CARD_TYPE_TRANSIT]<br>
  ///
  /// Since API Level 1.1
  ///
  static const String EXTRA_CARD_TYPE = "cardType";
  ///
  /// Key to represent card brand.<br>
  /// Since API Level 1.7
  ///
  static const String EXTRA_CARD_BRAND = "cardBrand";
  static const String EXTRA_PARTNER_BINDER = "binder";
  ///
  ///Card set as default card on Samsung Pay for payment.
  ///
  ///Since API Level 1.1
  ///
  static const String EXTRA_IS_DEFAULT_CARD = "defaultCard";
  ///
  /// Key to represent type of the device (Mobile or Gear). <br>
  /// The possible values are: <br>
  /// [SpaySdk.DEVICE_TYPE_PHONE]<br>
  /// [SpaySdk.DEVICE_TYPE_GEAR]<br>
  /// Since API Level 1.1
  ///
  static const String EXTRA_DEVICE_TYPE = "deviceType";
  ///
  /// Key to represent member ID of the issuer.<br>
  /// This is for Korean issuers only.
  ///
  /// Since API Level 1.1
  ///
  static const String EXTRA_MEMBER_ID = "memberID";
  ///
  /// Key to represent country code.<br>
  /// Device Country code(ISO 3166-1 alpha-2)
  ///
  /// Since API Level 1.1
  ///
  static const String EXTRA_COUNTRY_CODE = "countryCode";
  ///
  /// Key to represent the maximum registered card number has reached or not.
  ///
  /// Since API Level 1.1
  ///
  static const String EXTRA_DEVICE_CARD_LIMIT_REACHED = "deviceCardLimitReached";
  ///
  /// Key to represent the DSRP (Digital Secure Remote Payments) cryptogram type of Mastercard.
  ///
  /// Cryptogram type is supported by Mastercard only,
  /// can be put as an optional value in extraPaymentInfo of [CustomSheetPaymentInfo].
  ///
  /// Since API Level 2.4
  ///
  static const String EXTRA_CRYPTOGRAM_TYPE = "cryptogramType";
  ///
  /// Key to represent additional data.<br>
  ///
  /// Partner can use this key to put tagged data to a bundle before sending to Samsung Pay.<br>
  ///
  /// Since API Level 2.4
  ///
  static const String EXTRA_RESOLVED_1 = "extra_resolved_1";
  ///
  /// Key to represent additional data.<br>
  ///
  /// Partner can use this key to put tagged data to a bundle before sending to Samsung Pay.<br>
  ///
  /// Since API Level 2.4
  ///
  static const String EXTRA_RESOLVED_2 = "extra_resolved_2";
  ///
  /// Key to represent additional data.<br>
  ///
  /// Partner can use this key to put tagged data to a bundle before sending to Samsung Pay.<br>
  ///
  /// Since API Level 2.4
  ///
  static const String EXTRA_RESOLVED_3 = "extra_resolved_3";
  ///
  /// Key to represent additional data.<br>
  ///
  /// Partner can use this key to put tagged data to a bundle before sending to Samsung Pay.<br>
  ///
  /// Since API Level 2.4
  ///
  static const String EXTRA_RESOLVED_4 = "extra_resolved_4";
  ///
  /// Key to represent additional data.<br>
  ///
  /// Partner can use this key to put tagged data to a bundle before sending to Samsung Pay.<br>
  ///
  /// Since API Level 2.4
  ///
  static const String EXTRA_RESOLVED_5 = "extra_resolved_5";
  ///
  /// Key to represent additional data.<br>
  ///
  /// Partner can use this key to put tagged data to a bundle before sending to Samsung Pay.<br>
  ///
  /// Since API Level 2.4
  ///
  static const String EXTRA_RESOLVED_6 = "extra_resolved_6";
  ///
  /// Key to represent additional data.<br>
  ///
  /// Partner can use this key to put tagged data to a bundle before sending to Samsung Pay.<br>
  ///
  /// Since API Level 2.4
  ///
  static const String EXTRA_RESOLVED_7 = "extra_resolved_7";
  ///
  /// Key to represent request id.<br>
  ///
  /// When a request is failed, TR will send this key to partner app.
  /// Request ID would be helpful for debugging a failed request between partner and TR.
  ///
  /// Since API Level 2.5
  ///
  static const String EXTRA_REQUEST_ID = "extra_request_id";
  ///
  /// Key to represent the UCAF cryptogram type of Mastercard.
  ///
  /// UCAF cryptogram type is supported by Mastercard only,
  /// can be put as an optional value in extraPaymentInfo of [CustomSheetPaymentInfo].
  ///
  /// UCAF is a default cryptogram type if not specified in the extraPaymentInfo Bundle.
  ///
  /// Since API Level 2.4
  ///
  static const String CRYPTOGRAM_TYPE_UCAF = "UCAF";
  ///
  /// Key to represent the ICC cryptogram type of Mastercard.
  ///
  /// ICC cryptogram type is supported by Mastercard only,
  /// can be put as an optional value in extraPaymentInfo of [CustomSheetPaymentInfo].
  ///
  /// Since API Level 2.4
  ///
  static const String CRYPTOGRAM_TYPE_ICC = "ICC";
  ///
  /// Key to represent that a merchant supports combo card.<br>
  ///
  /// Partner can use this key to let customers to choose debit/credit in case of combo card. <br>
  /// It can be put as an optional value in extraPaymentInfo of [CustomSheetPaymentInfo].<br><br>
  ///
  /// The possible value is the boolean.
  ///
  /// Deprecated use [EXTRA_ACCEPT_COMBO_CARD] instead
  /// Since API Level 2.8
  ///
  static const String EXTRA_SUPPORT_COMBO_CARD = "supportComboCard";
  ///
  /// Key to represent that a merchant accepts combo card.<br>
  ///
  /// Partner can use this key to let customers to choose debit/credit in case of combo card. <br>
  /// It can be put as an optional value in extraPaymentInfo of [CustomSheetPaymentInfo].<br><br>
  ///
  /// The possible value is the boolean.
  ///
  /// Since API Level 2.9
  ///
  static const String EXTRA_ACCEPT_COMBO_CARD = "acceptComboCard";
  ///
  /// Key to represent that a partner requires CPF.<br>
  ///
  /// Partner can use this key to ask Samsung Pay to show CPF information in the payment sheet. <br>
  /// It can be put as an optional value in extraPaymentInfo of [CustomSheetPaymentInfo].<br><br>
  ///
  /// The possible value is the boolean.<br>
  /// This is for Brazil partners only.
  ///
  /// Since API Level 2.11
  ///
  static const String EXTRA_REQUIRE_CPF = "requireCpf";
  ///
  /// Key to get CPF holder name in extra payment data.<br>
  ///
  /// When Partner requests CPF by [EXTRA_REQUIRE_CPF] key, the Samsung Pay would
  /// bundle CPF information in the extraPaymentData parameter of
  /// [CustomSheetTransactionInfoListener.onSuccess]callback <br>
  ///
  ///
  /// Since API Level 2.11
  ///
  static const String EXTRA_CPF_HOLDER_NAME = "cpfHolderName";
  ///
  /// Key to get CPF number in extra payment data.<br>
  ///
  /// When Partner requests CPF by [EXTRA_REQUIRE_CPF] key, the Samsung Pay would
  /// bundle CPF information in the extraPaymentData parameter of
  /// [CustomSheetTransactionInfoListener.onSuccess]callback <br>
  ///
  ///
  /// Since API Level 2.11
  ///
  static const String EXTRA_CPF_NUMBER = "cpfNumber";
  ///
  /// Key to set/get merchant reference ID beyond marketplace app or service(i.e. Bixby).<br>
  ///
  /// When marketplace apps request In-App payment, they can set merchant reference ID so that Samsung Wallet app can get detail
  /// information about the merchant using the ID.
  ///
  /// Since API Level 2.11
  ///
  static const String EXTRA_MERCHANT_REF_ID = "merchantRefId";
  ///
  /// Key to represent wallet provider ID.<br>
  /// This ID can be assigned by TSP during on-boarding process.
  ///
  /// Since API Level 1.2
  ///
  static const String WALLET_PROVIDER_ID = "walletProviderId";
  ///
  /// Key to represent user's wallet ID.
  ///
  /// Since API Level 1.2
  ///
  static const String WALLET_USER_ID = "walletUserId";
  ///
  /// Key to represent unique device ID.
  ///
  /// Since API Level 1.2
  ///
  static const String DEVICE_ID = "deviceId";
  ///
  /// Key to represent unique device management ID.
  ///
  /// Since API Level 1.2
  ///
  static const String WALLET_DM_ID = "walletDMId";
  ///
  /// Key to represent unique Service Type.<br>
  /// This key must be set in the bundle for [PartnerInfo.PartnerInfo].
  ///
  /// Since API Level 1.4
  ///
  static const String PARTNER_SERVICE_TYPE = "PartnerServiceType";

  ///
  /// Key to represent unique SDK API Level which Partner use.
  ///
  /// Since API Level 1.4
  ///
  static const String PARTNER_SDK_API_LEVEL = "PartnerSdkApiLevel";

  /// Key to represent request card filter list.<br>
  /// Partner can use this key to put filter into bundle for requestCardInfo
  ///
  /// Since API Level 2.7
  static const String EXTRA_KEY_CARD_BRAND_FILTER = "card_brand_filter";
  /// This table shows the status codes used commonly.<br>
  ///
  /// <table>
  ///     <tr style="border:1px solid black;">
  ///         <th style="border:1px solid black;">Status</th>
  ///         <th style="border:1px solid black;">Bundle Keys</th>
  ///         <th style="border:1px solid black;">Bundle Values</th>
  ///     </tr>
  ///     <tr style="border:1px solid black;">
  ///         <td style="border:1px solid black;" rowspan="6">[SPAY_NOT_SUPPORTED] (0)</td>
  ///         <td style="border:1px solid black;" rowspan="6">[EXTRA_ERROR_REASON]</td>
  ///         <td style="border:1px solid black;">[ERROR_DEVICE_NOT_SAMSUNG] (-350)</td>
  ///     </tr>
  ///     <tr style="border:1px solid black;">
  ///         <td style="border:1px solid black;">[ERROR_SPAY_PKG_NOT_FOUND] (-351)</td>
  ///     </tr>
  ///     <tr style="border:1px solid black;">
  ///         <td style="border:1px solid black;">[ERROR_SPAY_SDK_SERVICE_NOT_AVAILABLE] (-352)</td>
  ///     </tr>
  ///     <tr style="border:1px solid black;">
  ///         <td style="border:1px solid black;">[ERROR_DEVICE_INTEGRITY_CHECK_FAIL] (-353)</td>
  ///     </tr>
  ///     <tr style="border:1px solid black;">
  ///         <td style="border:1px solid black;">[ERROR_SPAY_APP_INTEGRITY_CHECK_FAIL] (-360)</td>
  ///     </tr>
  ///     <tr style="border:1px solid black;">
  ///         <td style="border:1px solid black;">[ERROR_ANDROID_PLATFORM_CHECK_FAIL] (-361)</td>
  ///     </tr>
  ///     <tr style="border:1px solid black;">
  ///         <td style="border:1px solid black;" rowspan="2">[SPAY_NOT_READY] (1)</td>
  ///         <td style="border:1px solid black;" rowspan="2">[EXTRA_ERROR_REASON]</td>
  ///         <td style="border:1px solid black;">[ERROR_SPAY_SETUP_NOT_COMPLETED] (-356)</td>
  ///     </tr>
  ///     <tr style="border:1px solid black;">
  ///         <td style="border:1px solid black;">[ERROR_SPAY_APP_NEED_TO_UPDATE] (-357)</td>
  ///     </tr>
  ///     <tr style="border:1px solid black;">
  ///         <td style="border:1px solid black;" rowspan="2">[ERROR_SPAY_INTERNAL] (-1)</td>
  ///         <td style="border:1px solid black;">[EXTRA_ERROR_REASON]</td>
  ///         <td style="border:1px solid black;">[ERROR_SERVER_INTERNAL] (-311)</td>
  ///     </tr>
  ///     </tr>
  ///         <td style="border:1px solid black;">N/A</td>
  ///         <td style="border:1px solid black;">N/A</td>
  ///     </tr>
  ///     <tr style="border:1px solid black;">
  ///         <td style="border:1px solid black;" rowspan="14">[ERROR_NOT_ALLOWED] (-6)</td>
  ///         <td style="border:1px solid black;" rowspan="14">[EXTRA_ERROR_REASON]</td>
  ///         <td style="border:1px solid black;">[ERROR_INVALID_PARAMETER] (-12)</td>
  ///     </tr>
  ///     <tr style="border:1px solid black;">
  ///         <td style="border:1px solid black;">[ERROR_SDK_NOT_SUPPORTED_FOR_THIS_REGION] (-300)</td>
  ///     </tr>
  ///     <tr style="border:1px solid black;">
  ///         <td style="border:1px solid black;">[ERROR_SERVICE_ID_INVALID] (-301)</td>
  ///     </tr>
  ///     <tr style="border:1px solid black;">
  ///         <td style="border:1px solid black;">[ERROR_SERVICE_UNAVAILABLE_FOR_THIS_REGION] (-302)</td>
  ///     </tr>
  ///     <tr style="border:1px solid black;">
  ///         <td style="border:1px solid black;">[ERROR_PARTNER_APP_SIGNATURE_MISMATCH] (-303)</td>
  ///     </tr>
  ///     <tr style="border:1px solid black;">
  ///         <td style="border:1px solid black;">[ERROR_PARTNER_APP_VERSION_NOT_SUPPORTED] (-304)</td>
  ///     </tr>
  ///     <tr style="border:1px solid black;">
  ///         <td style="border:1px solid black;">[ERROR_PARTNER_APP_BLOCKED] (-305)</td>
  ///     </tr>
  ///     <tr style="border:1px solid black;">
  ///         <td style="border:1px solid black;">[ERROR_USER_NOT_REGISTERED_FOR_DEBUG] (-306)</td>
  ///     </tr>
  ///     <tr style="border:1px solid black;">
  ///         <td style="border:1px solid black;">[ERROR_SERVICE_NOT_APPROVED_FOR_RELEASE] (-307)</td>
  ///     </tr>
  ///     <tr style="border:1px solid black;">
  ///         <td style="border:1px solid black;">[ERROR_PARTNER_NOT_APPROVED] (-308)</td>
  ///     </tr>
  ///     <tr style="border:1px solid black;">
  ///         <td style="border:1px solid black;">[ERROR_UNAUTHORIZED_REQUEST_TYPE] (-309)</td>
  ///     </tr>
  ///     <tr style="border:1px solid black;">
  ///         <td style="border:1px solid black;">[ERROR_EXPIRED_OR_INVALID_DEBUG_KEY] (-310)</td>
  ///     </tr>
  ///     <tr style="border:1px solid black;">
  ///         <td style="border:1px solid black;">[ERROR_MISSING_INFORMATION] (-354)</td>
  ///     </tr>
  ///     <tr style="border:1px solid black;">
  ///         <td style="border:1px solid black;">[ERROR_UNABLE_TO_VERIFY_CALLER] (-359)</td>
  ///     </tr>
  ///     <tr style="border:1px solid black;">
  ///         <td style="border:1px solid black;">[ERROR_INVALID_PARAMETER] (-12)</td>
  ///         <td style="border:1px solid black;">N/A</td>
  ///         <td style="border:1px solid black;">N/A</td>
  ///     </tr>
  ///     <tr style="border:1px solid black;">
  ///         <td style="border:1px solid black;">[ERROR_NO_NETWORK] (-21)</td>
  ///         <td style="border:1px solid black;">N/A</td>
  ///         <td style="border:1px solid black;">N/A</td>
  ///     </tr>
  ///     <tr style="border:1px solid black;">
  ///         <td style="border:1px solid black;">[ERROR_SERVER_NO_RESPONSE] (-22)</td>
  ///         <td style="border:1px solid black;">N/A</td>
  ///         <td style="border:1px solid black;">N/A</td>
  ///     </tr>
  ///     <tr style="border:1px solid black;">
  ///         <td style="border:1px solid black;" rowspan="3">[ERROR_PARTNER_INFO_INVALID] (-99)</td>
  ///         <td style="border:1px solid black;" rowspan="3">[EXTRA_ERROR_REASON]</td>
  ///         <td style="border:1px solid black;">[ERROR_PARTNER_SDK_API_LEVEL] (-10)</td>
  ///     </tr>
  ///     <tr style="border:1px solid black;">
  ///         <td style="border:1px solid black;">[ERROR_PARTNER_SERVICE_TYPE] (-11)</td>
  ///     </tr>
  ///     <tr style="border:1px solid black;">
  ///         <td style="border:1px solid black;">[ERROR_PARTNER_SDK_VERSION_NOT_ALLOWED] (-358)</td>
  ///     </tr>
  ///     <tr style="border:1px solid black;">
  ///         <td style="border:1px solid black;">[ERROR_INITIATION_FAIL] (-103)</td>
  ///         <td style="border:1px solid black;">N/A</td>
  ///         <td style="border:1px solid black;">N/A</td>
  ///     </tr>
  ///     <tr style="border:1px solid black;">
  ///         <td style="border:1px solid black;">[SPAY_NOT_ALLOWED_TEMPORALLY] (3)</td>
  ///         <td style="border:1px solid black;">[EXTRA_ERROR_REASON]</td>
  ///         <td style="border:1px solid black;">[ERROR_SPAY_CONNECTED_WITH_EXTERNAL_DISPLAY] (-605)</td>
  ///     </tr>
  ///     <tr style="border:1px solid black;">
  ///         <td style="border:1px solid black;">[ERROR_SPAY_FMM_LOCK] (-604)</td>
  ///         <td style="border:1px solid black;">N/A</td>
  ///         <td style="border:1px solid black;">N/A</td>
  ///     </tr>
  ///  </table>
  /// <br>

  static const String COMMON_STATUS_TABLE = "common_error_table";

  ///
  /// key to represent web checkout API level
  ///
  /// Since API Level 2.8
  ///
  static const String WEB_CHECKOUT_API_LEVEL = "WEB_CHECKOUT_API_LEVEL";
  static const String EXTRA_SHIPPING_METHOD = "shippingMethod";
  static const String FORMAT_TOTAL_PRICE_ONLY = "_price_only_";
  static const String FORMAT_TOTAL_ESTIMATED_AMOUNT = "Total (Estimated amount)";
  static const String FORMAT_TOTAL_ESTIMATED_CHARGE = "Total (Estimated charge)";
  static const String FORMAT_TOTAL_ESTIMATED_FARE = "Total (Estimated fare)";
  static const String FORMAT_TOTAL_FREE_TEXT_ONLY = "Free";
  static const String FORMAT_TOTAL_AMOUNT_PENDING = "Total (Amount pending)";
  static const String FORMAT_TOTAL_AMOUNT_PENDING_TEXT_ONLY = "Amount pending";
  static const String FORMAT_TOTAL_PENDING = "Total (Pending)";
  static const String FORMAT_TOTAL_PENDING_TEXT_ONLY = "Pending";
  static const String FORMAT_TOTAL_UP_TO_AMOUNT = "Total (Up to amount)";

  static const int DISPLAY_OPTION_ADDRESSEE = 1;
  static const int DISPLAY_OPTION_ADDRESS = 1 << 1;
  static const int DISPLAY_OPTION_PHONE_NUMBER = 1 << 2;
  static const int DISPLAY_OPTION_EMAIL = 1 << 3;

  static const int ERROR_SHIPPING_ADDRESS_INVALID = -201;
  static const int ERROR_SHIPPING_ADDRESS_UNABLE_TO_SHIP = -202;
  static const int ERROR_SHIPPING_ADDRESS_NOT_EXIST = -203;
  static const int ERROR_BILLING_ADDRESS_INVALID = -204;
  static const int ERROR_BILLING_ADDRESS_NOT_EXIST = -205;
  static const int CUSTOM_MESSAGE = -220;

}

///
/// This enumeration provides Service Types.<br>
/// Partners must set their Service Type in the PartnerInfo when they call any APIs.
///
/// Since API Level 1.4
///
///
enum ServiceType {
  ///
  /// Service type for using Online in-app payment service.
  /// Since API Level 1.4
  ///
  INAPP_PAYMENT,
  ///
  /// Service type for using Issuer service.
  /// Since API Level 1.4
  ///
  APP2APP,
  ///
  /// Service type for using Web payment service.
  /// Since API Level 1.4
  ///
  WEB_PAYMENT,
  ///
  /// Service type for using W3C payment service.
  /// Since API Level 1.4
  ///
  W3C,
  ///
  /// Service type for using Mobile web payment service.
  /// Since API Level 1.4
  ///
  MOBILEWEB_PAYMENT,
  ///
  /// Service type for using Samsung Pay internal service.
  /// Since API Level 1.4
  ///
  INTERNAL_APK
}

///
/// This enumeration provides SDK supported card brands such as
/// AMERICAN EXPRESS, MASTERCARD, VISA, DISCOVER, CHINA UNIONPAY, OCTOPUS, ECI and PAGOBANCOMAT.<br>
///
/// Since API Level 1.1
///
enum Brand {
  ///Card brand for AMERICAN EXPRESS.
  AMERICANEXPRESS,
  /// Card brand for MASTERCARD.
  MASTERCARD,
  /// Card brand for VISA.
  VISA,
  /// Card brand for DISCOVER.
  DISCOVER,
  /// Card brand for CHINA UNIONPAY.
  CHINAUNIONPAY,
  /// Card brand is unknown.
  UNKNOWN_CARD,
  /// Card brand for HK OCTOPUS.
  OCTOPUS,
  ///
  /// Card brand for Spain ECI.
  ///
  /// Since API Level 2.8
  ///
  ECI,
  ///
  /// Card brand for Italy PagoBancomat.
  ///
  /// Since API Level 2.11
  ///
  PAGOBANCOMAT,
  ///
  /// Card brand for Saudi Arabia MADA.
  ///
  MADA
}

///
/// This enumeration provides types of address UI on the payment sheet, based on merchant requirement.
///
enum AddressInPaymentSheet {
  ///
  /// Shipping and billing address are not required for payment.
  /// Do not display address on the payment sheet.
  ///
  DO_NOT_SHOW,
  ///
  /// Merchant requires billing address from Samsung Wallet for payment.<br>
  /// Show only billing address list on the payment sheet. User could select one on the payment sheet.
  ///
  NEED_BILLING_SPAY,
  ///
  /// Merchant requires shipping address from Samsung Wallet for payment. <br>
  /// Show only shipping address list on the payment sheet. User could select one on the payment sheet.
  ///
  NEED_SHIPPING_SPAY,
  ///
  /// Merchant will send the shipping address for payment.<br>
  /// Show only shipping address shared by merchant as fixed value on the payment sheet. Unlike
  /// [AddressInPaymentSheet.NEED_BILLING_SPAY] or [AddressInPaymentSheet.NEED_SHIPPING_SPAY], user will not be
  /// able to change the shipping address on the payment sheet.
  ///
  SEND_SHIPPING,
  ///
  /// Merchant requires billing address from Samsung Wallet and sends the shipping address for payment.<br>
  /// Show both billing and shipping address on the payment sheet. Unlike
  /// [AddressInPaymentSheet.NEED_BILLING_SPAY] or [AddressInPaymentSheet.NEED_SHIPPING_SPAY], user will not
  /// be able to change the shipping address on the payment sheet.
  ///
  NEED_BILLING_SEND_SHIPPING,
  ///
  /// Merchant requires billing and shipping address from Samsung Wallet for payment.<br>
  /// Show both address lists on the payment sheet. User could select billing and shipping address from the list on the
  /// payment sheet.
  ///
  NEED_BILLING_AND_SHIPPING
}
///
/// This enumeration provides SDK supported SheetControl type such as<br>
/// PLAINTEXT, AMOUNTBOX, ADDRESS and SPINNER.<br>
///


enum SheetItemType {
  ///@nodoc
  /// It is used for designating amount item in AmountBoxControl.
  ///
  AMOUNT_ITEM,
  ///@nodoc
  /// It is used for designating amount total in AmountBoxControl.
  ///
  AMOUNT_TOTAL,
  ///
  /// It is used for designating billing address in AddressControl.
  ///
  BILLING_ADDRESS,
  ///
  /// It is used for designating shipping address in AddressControl.
  ///
  SHIPPING_ADDRESS,
  ///
  /// It is used for designating shipping method in SpinnerControl.<br>
  /// User will be able to change shipping method only when
  /// [AddressInPaymentSheet.NEED_SHIPPING_SPAY] or
  /// [AddressInPaymentSheet.NEED_BILLING_AND_SHIPPING] is set when building a
  /// [CustomSheetPaymentInfo]
  ///
  SHIPPING_METHOD_SPINNER,
  ///
  /// It is used for designating installment in SpinnerControl.<br>
  /// This is for Korean issuers only.
  ///

  INSTALLMENT_SPINNER,
  ZIP_ONLY_ADDRESS;
}

///
/// This enumeration provides SDK supported SheetControl type such as<br>
/// [PLAINTEXT], [AMOUNTBOX], [ADDRESS] and [SPINNER].<br>
///
enum Controltype{
  ///
  /// Controltype for PlainText Component.
  ///
  PLAINTEXT,
  ///
  /// Controltype for AmountBox Component.<br>
  ///  There must be one AMOUNTBOX type in SheetControls.
  ///
  AMOUNTBOX,
  ///
  /// Controltype for Address(shipping / billing) Component.
  ///
  ADDRESS,
  ///
  /// Controltype for Spinner Component.
  ///
  SPINNER;
}