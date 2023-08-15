/// Required configuration to extend the Credit Card payment feature.
class CreditCardConfig {
  ///  An option to save (tokenize) the card after a successful payment.
  bool saveCard;
  bool manual;

  CreditCardConfig({required this.saveCard, required this.manual});
}
