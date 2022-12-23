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
    buffer.write(date[i]);
    int nonZeroIndex = i + 1;
    if (nonZeroIndex == 2 && nonZeroIndex != date.length) {
      buffer.write(' / ');
    }
  }

  return buffer.toString();
}

String getFormattedCardNumber(String number) {
  final company = CardUtils.getCardCompanyFromNumber(number);

  var buffer = StringBuffer();

  if (company == CardCompany.amex) {
    for (int i = 0; i < number.length; i++) {
      buffer.write(number[i]);
      int nonZeroIndex = i + 1;
      if ((nonZeroIndex == 4 || nonZeroIndex == 11) &&
          nonZeroIndex != number.length) {
        buffer.write('  ');
      }
    }
  } else {
    for (int i = 0; i < number.length; i++) {
      buffer.write(number[i]);
      int nonZeroIndex = i + 1;
      if (nonZeroIndex % 4 == 0 && nonZeroIndex != number.length) {
        buffer.write('  ');
      }
    }
  }
  return buffer.toString();
}
