import 'package:moyasar/src/models/sources/card/card_company.dart';

/// Credit Card data.
///
/// Use only when you need to customize the UI.
class CardFormModel {
  CardCompany? company;
  String number;
  String name;
  String month;
  String year;
  String cvc;

  CardFormModel(
      {this.company,
      this.number = '',
      this.name = '',
      this.month = '',
      this.year = '',
      this.cvc = ''});
}
