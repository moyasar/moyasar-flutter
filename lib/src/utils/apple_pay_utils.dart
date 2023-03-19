import 'dart:convert';

import 'package:flutter/services.dart';

const paymentConfigFile = "assets/default_payment_profile_apple_pay.json";

class ApplePayUtils {
  static Future<String> getMerchantName() async {
    final String config = await rootBundle.loadString(paymentConfigFile);
    return await json.decode(config)["data"]["displayName"];
  }
}
