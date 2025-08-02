import 'package:moyasar/src/models/payment_config.dart';

class MadaUtil {
  static final instance = MadaUtil();
  final List<String> madaRanges = [
    "22337902","22337986","22402030","242030","403024","40545400","406136","406996","40719700","40739500","407520","409201","410621","410685","410834","412565","417633","419593","420132","421141","422817","422818","422819","428331","428671","428672","428673","431361","432328","434107","439954","440533","440647","440795","442463","445564","446393","446404","446672","45488707","455036","455708","457865","457997","458456","462220","468540","468541","468542","468543","474491","483010","483011","483012","484783","486094","486095","486096","489318","489319","49098000","492464","504300","513213","515079","516138","520058","521076","52166100","524130","524514","524940","529415","529741","530060","531196","535825","535989","536023","537767","53973776","543085","543357","549760","554180","555610","558563","588845","588848","588850","589206","604906","636120","968201","968202","968203","968204","968205","968206","968207","968208","968209","968211"
  ];

  bool inMadaRange(String number) {
    for (final range in madaRanges) {
      if (number.startsWith(range)) return true;
    }
    return false;
  }
}

enum CardNetwork { amex, visa, mada, masterCard, unknown }

/// Check if a string contains only numeric characters
bool isNumeric(String str) {
  return str.isNotEmpty && !RegExp(r'\D').hasMatch(str);
}

/// Luhn algorithm validation for card numbers
bool isValidLuhnNumber(String number) {
  final cleanNumber = number.replaceAll(' ', '');
  if (!isNumeric(cleanNumber)) {
    return false;
  }
  
  final doubleSum = [0, 2, 4, 6, 8, 1, 3, 5, 7, 9];
  var sum = 0;
  
  for (int i = cleanNumber.length - 1; i >= 0; i--) {
    final digit = int.parse(cleanNumber[i]);
    final index = cleanNumber.length - 1 - i;
    sum += index % 2 == 0 ? digit : doubleSum[digit];
  }
  
  return sum % 10 == 0;
}

/// Get card network based on number and supported networks (matches Swift logic)
CardNetwork getCardNetwork(String number, List<PaymentNetwork> supportedNetworks) {
  final clean = number.replaceAll(' ', '');
  
  // Convert PaymentNetwork to CardNetwork for comparison
  final supportedCardNetworks = supportedNetworks.map((network) {
    switch (network) {
      case PaymentNetwork.amex:
        return CardNetwork.amex;
      case PaymentNetwork.visa:
        return CardNetwork.visa;
      case PaymentNetwork.mada:
        return CardNetwork.mada;
      case PaymentNetwork.masterCard:
        return CardNetwork.masterCard;
    }
  }).toList();
  
  // Regex patterns matching Swift implementation
  final amexRangeRegex = RegExp(r'^3[47]');
  final visaRangeRegex = RegExp(r'^4');
  final masterCardRangeRegex = RegExp(r'^(?:5[1-5][0-9]{2}|222[1-9]|22[3-9][0-9]|2[3-6][0-9]{2}|27[01][0-9]|2720)');
  
  // Check if the number matches known card types and if it's in supported networks
  if (amexRangeRegex.hasMatch(clean) && supportedCardNetworks.contains(CardNetwork.amex)) {
    return CardNetwork.amex;
  } else if (MadaUtil.instance.inMadaRange(clean) && supportedCardNetworks.contains(CardNetwork.mada)) {
    return CardNetwork.mada;
  } else if (visaRangeRegex.hasMatch(clean) && supportedCardNetworks.contains(CardNetwork.visa)) {
    return CardNetwork.visa;
  } else if (masterCardRangeRegex.hasMatch(clean) && supportedCardNetworks.contains(CardNetwork.masterCard)) {
    return CardNetwork.masterCard;
  } else {
    return CardNetwork.unknown;
  }
}

/// Legacy function for backward compatibility
CardNetwork detectNetwork(String number) {
  final clean = number.replaceAll(RegExp(r'\D'), '');
  if (clean.isEmpty) return CardNetwork.unknown;
  
  // Check Mada first to avoid conflicts with Visa/MasterCard
  if (MadaUtil.instance.inMadaRange(clean)) return CardNetwork.mada;
  
  // Then check other networks
  if (clean.startsWith('34') || clean.startsWith('37')) return CardNetwork.amex;
  if (clean.startsWith('4')) return CardNetwork.visa;
  if (clean.startsWith('5')) return CardNetwork.masterCard;
  
  return CardNetwork.unknown;
}

class CreditCardFormatter {
  static String formatCardNumber(String number) {
    final cleaned = number.replaceAll(RegExp(r'\D'), '');
    if (cleaned.startsWith('34') || cleaned.startsWith('37')) {
      return _formatAMEXCardNumber(cleaned);
    }
    return _formatOtherCardNumber(cleaned);
  }

  static String _formatAMEXCardNumber(String number) {
    final segments = [4, 6, 5];
    var formatted = '';
    var start = 0;
    for (final length in segments) {
      if (start >= number.length) break;
      final end = (start + length > number.length) ? number.length : start + length;
      formatted += number.substring(start, end);
      if (end < number.length) formatted += ' ';
      start = end;
    }
    return formatted;
  }

  static String _formatOtherCardNumber(String number) {
    final maxLength = 16;
    final truncated = number.length > maxLength ? number.substring(0, maxLength) : number;
    final buffer = StringBuffer();
    for (var i = 0; i < truncated.length; i++) {
      if (i > 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(truncated[i]);
    }
    return buffer.toString();
  }
} 