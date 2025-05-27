/// The Credit Card form supports the English (default) and the Arabic language.
class Localization {
  final String languageCode;

  final String nameOnCard;
  final String nameRequired;
  final String bothNamesRequired;

  final String cardNumber;
  final String cardNumberRequired;
  final String invalidCardNumber;
  final String unsupportedNetwork;

  final String expiry;
  final String expiryRequired;
  final String invalidExpiry;
  final String expiredCard;

  final String cvc;
  final String cvcRequired;
  final String invalidCvc;

  final String pay;

  final String saveCardNotice;
  final String cardInformation;

  final String mobileNumber;
  final String invalidPhoneNumber;

  final String oneTimePassword;

  final String confirm;
  final String pleaseEnterOtp;
  final String otpValidation;

  const Localization.en({
    this.languageCode = 'en',
    this.nameOnCard = 'Name on Card',
    this.nameRequired = 'Name is required',
    this.bothNamesRequired = 'Both first and last names are required',
    this.cardNumber = 'Card Number',
    this.cardNumberRequired = 'Card number is required',
    this.invalidCardNumber = 'Invalid card number',
    this.unsupportedNetwork = 'Unsupported network',
    this.expiry = 'Expiry',
    this.expiryRequired = 'Expiry is required',
    this.invalidExpiry = 'Invalid expiry',
    this.expiredCard = 'Expired card',
    this.cvc = 'CVC',
    this.cvcRequired = 'Security code is required',
    this.invalidCvc = 'Invalid security code',
    this.pay = 'Pay',
    this.saveCardNotice = 'Your card data will be saved upon submit.',
    this.cardInformation = 'Card information',
    this.mobileNumber = 'Mobile Number',
    this.invalidPhoneNumber = 'Invalid phone number',
    this.oneTimePassword = 'One-Time Password',
    this.confirm = 'Confirm',
    this.pleaseEnterOtp = 'Please enter the OTP',
    this.otpValidation = 'OTP must be 4 digits',
  });

  const Localization.ar({
    this.languageCode = 'ar',
    this.nameOnCard = 'الاسم على البطاقة',
    this.nameRequired = 'الاسم مطلوب',
    this.bothNamesRequired = 'الاسم الأول والثاني مطلوب',
    this.cardNumber = 'رقم البطاقة',
    this.cardNumberRequired = 'رقم البطاقة مطلوب',
    this.invalidCardNumber = 'رقم البطاقة غير صحيح',
    this.unsupportedNetwork = 'شبكة غير مدعومة',
    this.expiry = 'تاريخ الانتهاء',
    this.expiryRequired = 'تاريخ الإنتهاء مطلوب',
    this.invalidExpiry = 'تاريخ الإنتهاء غير صحيح',
    this.expiredCard = 'بطاقة منتهية',
    this.cvc = 'رمز التحقق',
    this.cvcRequired = 'رمز التحقق مطلوب',
    this.invalidCvc = 'رمز التحقق غير صحيح',
    this.pay = 'ادفع',
    this.saveCardNotice = 'سيتم حفظ بيانات البطاقة عند إتمام العملية.',
    this.cardInformation = 'معلومات بطاقة الإئتمان',
    this.mobileNumber = 'رقم الجوال',
    this.invalidPhoneNumber = 'رقم الجوال غير صحيح',
    this.oneTimePassword = 'رمز التحقق',
    this.confirm = 'تأكيد',
    this.pleaseEnterOtp = 'يرجى إدخال رمز التحقق',
    this.otpValidation = 'يجب أن يتكون رمز التحقق من 4 أرقام',
  });
}
