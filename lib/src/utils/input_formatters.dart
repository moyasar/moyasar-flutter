import 'package:flutter/services.dart';
import 'package:moyasar/src/models/sources/card/card_company.dart';
import 'package:moyasar/src/utils/card_utils.dart';

class CardMonthInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(oldValue, newValue) {
    final formattedDate = getFormattedExpiryDate(newValue.text);

    return newValue.copyWith(
        text: formattedDate,
        selection: TextSelection.collapsed(offset: formattedDate.length));
  }
}

class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(oldValue, newValue) {
    final formattedCardNumber = getFormattedCardNumber(newValue.text);

    return newValue.copyWith(
        text: formattedCardNumber,
        selection: TextSelection.collapsed(offset: formattedCardNumber.length));
  }
}

String getFormattedExpiryDate(String date) {
  var buffer = StringBuffer();

  for (int i = 0; i < date.length; i++) {
    buffer.write("\u200E${date[i]}");
    int nonZeroIndex = i + 1;
    if (nonZeroIndex == 2 && nonZeroIndex != date.length) {
      buffer.write(' / ');
    }
  }

  return "\u200E$buffer";
}

String getFormattedCardNumber(String number) {
  final company = CardUtils.getCardCompanyFromNumber(number);
  final buffer = StringBuffer();

  if (company == CardCompany.amex) {
    // AMEX: 4-6-5 groups (15 digits)
    for (int i = 0; i < number.length; i++) {
      buffer.write("\u200E${number[i]}");
      final nonZeroIndex = i + 1;
      if ((nonZeroIndex == 4 || nonZeroIndex == 11) &&
          nonZeroIndex != number.length) {
        buffer.write(' ');
      }
    }
  } else {
    // Standard (16 digits) and UnionPay (19 digits): groups of 4
    final maxLength = company == CardCompany.unionPay ? 19 : 16;
    final truncated =
        number.length > maxLength ? number.substring(0, maxLength) : number;
    for (int i = 0; i < truncated.length; i++) {
      buffer.write("\u200E${truncated[i]}");
      final nonZeroIndex = i + 1;
      if (nonZeroIndex % 4 == 0 && nonZeroIndex != truncated.length) {
        buffer.write(' ');
      }
    }
  }
  return "\u200E$buffer";
}
