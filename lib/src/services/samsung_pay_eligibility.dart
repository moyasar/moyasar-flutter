import 'dart:async';
import 'dart:io';

import 'package:moyasar/src/models/payment_config.dart';
import 'package:moyasar/src/samsung_pay_sdk/model/partner_info.dart';
import 'package:moyasar/src/samsung_pay_sdk/samsung_pay_listener.dart';
import 'package:moyasar/src/samsung_pay_sdk/samsung_pay_sdk_flutter.dart';

/// High-level helper API to proactively check Samsung Pay readiness.
///
/// Use this when you need an explicit pre-check for custom UX flows. The
/// [SamsungPay] widget already performs this check internally and hides itself
/// when Samsung Pay is unavailable or not ready.
class SamsungPayEligibility {
  static const String _readyStatusCode = '2';

  /// Returns whether Samsung Pay is eligible for showing payment UX now.
  static Future<bool> isEligible(
    PaymentConfig config, {
    Duration timeout = const Duration(seconds: 10),
  }) async {
    final result = await check(config, timeout: timeout);
    return result.isEligible;
  }

  /// Performs a detailed readiness check and returns diagnostic information.
  static Future<SamsungPayEligibilityResult> check(
    PaymentConfig config, {
    Duration timeout = const Duration(seconds: 10),
  }) async {
    if (!Platform.isAndroid) {
      return const SamsungPayEligibilityResult(
        isEligible: false,
        reason: SamsungPayEligibilityReason.notAndroid,
      );
    }

    final samsungConfig = config.samsungPay;
    if (samsungConfig == null) {
      return const SamsungPayEligibilityResult(
        isEligible: false,
        reason: SamsungPayEligibilityReason.missingSamsungPayConfig,
      );
    }

    final completer = Completer<SamsungPayEligibilityResult>();

    try {
      final samsungPay = SamsungPaySdkFlutter(
        PartnerInfo(
          serviceId: samsungConfig.serviceId,
          data: {
            SpaySdk.PARTNER_SERVICE_TYPE: ServiceType.INAPP_PAYMENT.name,
          },
        ),
      );

      samsungPay.getSamsungPayStatus(
        StatusListener(
          onSuccess: (status, bundle) {
            if (completer.isCompleted) {
              return;
            }

            final isReady = status == _readyStatusCode;
            completer.complete(
              SamsungPayEligibilityResult(
                isEligible: isReady,
                reason: isReady
                    ? SamsungPayEligibilityReason.ready
                    : SamsungPayEligibilityReason.notReady,
                statusCode: status,
                details: Map<String, dynamic>.from(bundle),
              ),
            );
          },
          onFail: (errorCode, bundle) {
            if (completer.isCompleted) {
              return;
            }

            completer.complete(
              SamsungPayEligibilityResult(
                isEligible: false,
                reason: SamsungPayEligibilityReason.sdkError,
                errorCode: errorCode,
                details: Map<String, dynamic>.from(bundle),
              ),
            );
          },
        ),
      );

      return await completer.future.timeout(
        timeout,
        onTimeout: () => const SamsungPayEligibilityResult(
          isEligible: false,
          reason: SamsungPayEligibilityReason.timeout,
        ),
      );
    } catch (_) {
      return const SamsungPayEligibilityResult(
        isEligible: false,
        reason: SamsungPayEligibilityReason.unknown,
      );
    }
  }
}

/// Detailed outcome for Samsung Pay readiness checks.
class SamsungPayEligibilityResult {
  final bool isEligible;
  final SamsungPayEligibilityReason reason;

  /// Samsung Pay status code from success callback (e.g. 2 for ready).
  final String? statusCode;

  /// Error code from failure callback.
  final String? errorCode;

  /// Additional native diagnostic data.
  final Map<String, dynamic> details;

  const SamsungPayEligibilityResult({
    required this.isEligible,
    required this.reason,
    this.statusCode,
    this.errorCode,
    this.details = const <String, dynamic>{},
  });

  int? get statusCodeAsInt {
    final code = statusCode;
    return code == null ? null : int.tryParse(code);
  }

  int? get errorCodeAsInt {
    final code = errorCode;
    return code == null ? null : int.tryParse(code);
  }
}

enum SamsungPayEligibilityReason {
  ready,
  notAndroid,
  missingSamsungPayConfig,
  notReady,
  sdkError,
  timeout,
  unknown,
}