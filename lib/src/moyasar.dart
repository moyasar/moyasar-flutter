import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:moyasar/moyasar.dart';

const version = '2.0.8';

/// Payment service.
///
/// Use only when you need to customize the UI.
class Moyasar {
  static const String apiUrl = 'https://api.moyasar.com/v1/payments';

  static Future<dynamic> pay(
      {required String apiKey, required PaymentRequest paymentRequest}) async {
    final headers = buildRequestHeaders(apiKey);
    final body = jsonEncode(paymentRequest.toJson());

    final res = await http
        .post(Uri.parse(apiUrl), headers: headers, body: body)
        .onError((error, stackTrace) =>
            http.Response(jsonEncode({'type': NetworkError.type}), 400))
        .timeout(const Duration(seconds: 45),
            onTimeout: () =>
                http.Response(jsonEncode({'type': TimeoutError.type}), 408));

    dynamic jsonBody = jsonDecode(res.body);

    if (res.statusCode.toString().startsWith('2')) {
      return PaymentResponse.fromJson(jsonBody, paymentRequest.source.type);
    }

    if (res.statusCode.toString().startsWith('5')) {
      return ApiError(jsonBody['message']);
    }

    if (res.statusCode.toString().startsWith('4')) {
      String errorType = jsonBody['type'];

      switch (errorType) {
        case 'authentication_error':
          return AuthError(jsonBody['message']);
        case 'network_error':
          return NetworkError();
        case 'timeout_error':
          return TimeoutError();
        default:
          if (jsonBody['errors'] is String) {
            return ValidationError.messageOnly(jsonBody['errors']);
          }

          return ValidationError(jsonBody['message'], jsonBody['errors']);
      }
    }

    return UnspecifiedError(jsonBody?.toString() ?? "");
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
