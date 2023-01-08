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

  const Localization.en(
      {this.languageCode = 'en',
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
      this.pay = 'Pay'});

  const Localization.ar(
      {this.languageCode = 'ar',
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
      this.pay = 'ادفع'});
}
