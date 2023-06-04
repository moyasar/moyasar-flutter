/// Required configuration to extend the Credit Card payment feature.
class CreditCardConfig {
  ///  An option to save (tokenize) the card after a successful payment.
  bool saveCard;

  CreditCardConfig({required this.saveCard});
}
