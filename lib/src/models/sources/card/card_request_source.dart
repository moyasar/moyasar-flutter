import 'package:moyasar/src/models/card_form_model.dart';
import 'package:moyasar/src/models/payment_type.dart';
import 'package:moyasar/src/models/sources/card/card_company.dart';
import 'package:moyasar/src/models/sources/payment_request_source.dart';
import 'package:moyasar/src/utils/card_utils.dart';

class CardPaymentRequestSource implements PaymentRequestSource {
  @override
  PaymentType type = PaymentType.creditcard;

  late CardCompany company;
  late String name;
  late String number;
  late String cvc;
  late String month;
  late String year;

  CardPaymentRequestSource(CardFormModel creditCardData) {
    company = CardUtils.getCardCompanyFromNumber(creditCardData.number);
    name = creditCardData.name;
    number = creditCardData.number;
    cvc = creditCardData.cvc;
    month = creditCardData.month;
    year = creditCardData.year;
  }

  @override
  Map<String, dynamic> toJson() => {
        'type': type.name,
        'company': company.name,
        'name': name,
        'number': number,
        'cvc': cvc,
        'month': month,
        'year': year,
      };
}
