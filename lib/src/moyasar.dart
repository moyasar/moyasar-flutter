import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:moyasar/moyasar.dart';

import 'package:moyasar/src/models/payment_request.dart';

const version = "2.0.0";

class Moyasar {
  static const String apiUrl = 'https://api.moyasar.com/v1/payments';

  static Future<dynamic> pay(
      {required String apiKey, required PaymentRequest paymentRequest}) async {
    final headers = buildRequestHeaders(apiKey);
    final body = jsonEncode(paymentRequest.toJson());

    final res =
        await http.post(Uri.parse(apiUrl), headers: headers, body: body);

    dynamic jsonBody = jsonDecode(res.body);

    if (res.statusCode.toString().startsWith('4')) {
      String errorType = jsonBody['type'];

      if (errorType == 'authentication_error') {
        return AuthError(jsonBody['message']);
      }

      if (errorType == 'invalid_request_error') {
        if (jsonBody['errors'] is String) {
          return ValidationError.messageOnly(jsonBody['errors']);
        } else {
          return ValidationError(jsonBody['message'], jsonBody['errors']);
        }
      }
    }

    return PaymentResponse.fromJson(jsonBody, paymentRequest.source.type);
  }
}

Map<String, String> buildRequestHeaders(apiKey) {
  return {
    'Content-type': 'application/json',
    'Authorization': 'Basic ${base64Encode(utf8.encode(apiKey))}',
    'X-MOYASAR-LIB': 'moyasar-flutter-sdk',
    'X-FLUTTER-SDK-VERSION': version
  };
}
