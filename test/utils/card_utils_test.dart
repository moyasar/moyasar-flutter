import 'package:flutter_test/flutter_test.dart';
import 'package:moyasar/moyasar.dart';
import 'package:moyasar/src/utils/card_utils.dart';

void main() {
  test("should validate name.", () {
    var locale = const Localization.en();
    String? message = "";

    const empty = "";
    message = CardUtils.validateName(empty, locale);
    expect(message, locale.nameRequired);

    const noSecondName = "Faisal";
    message = CardUtils.validateName(noSecondName, locale);
    expect(message, locale.bothNamesRequired);

    const valid = "Faisal Alghurayri";
    message = CardUtils.validateName(valid, locale);
    expect(message, null);
  });

  test("should validate card number.", () {
    var locale = const Localization.en();
    String? message = "";

    const empty = "";
    message = CardUtils.validateCardNum(empty, locale);
    expect(message, locale.cardNumberRequired);

    const tooShort = "4111111";
    message = CardUtils.validateCardNum(tooShort, locale);
    expect(message, locale.invalidCardNumber);

    const invalidLuhn = "4111111111111112";
    message = CardUtils.validateCardNum(invalidLuhn, locale);
    expect(message, locale.invalidCardNumber);

    const valid = "4111111111111111";
    message = CardUtils.validateCardNum(valid, locale);
    expect(message, null);
  });

  test("should validate expiry date.", () {
    var locale = const Localization.en();
    String? message = "";

    const empty = "";
    message = CardUtils.validateDate(empty, locale);
    expect(message, locale.expiryRequired);

    const incompleteDate = "1";
    message = CardUtils.validateDate(incompleteDate, locale);
    expect(message, locale.invalidExpiry);

    const incorrectMonth = "13/30";
    message = CardUtils.validateDate(incorrectMonth, locale);
    expect(message, locale.invalidExpiry);

    const expired = "10/20";
    message = CardUtils.validateDate(expired, locale);
    expect(message, locale.expiredCard);

    const valid = "10/30";
    message = CardUtils.validateDate(valid, locale);
    expect(message, null);
  });

  test("should validate CVC.", () {
    var locale = const Localization.en();
    String? message = "";

    const empty = "";
    message = CardUtils.validateCVC(empty, locale);
    expect(message, locale.cvcRequired);

    const tooShort = "12";
    message = CardUtils.validateCVC(tooShort, locale);
    expect(message, locale.invalidCvc);

    const tooLong = "12345";
    message = CardUtils.validateCVC(tooLong, locale);
    expect(message, locale.invalidCvc);

    const validThree = "123";
    message = CardUtils.validateCVC(validThree, locale);
    expect(message, null);

    const validFour = "1234";
    message = CardUtils.validateCVC(validFour, locale);
    expect(message, null);
  });
}
