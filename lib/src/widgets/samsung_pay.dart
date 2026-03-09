import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:moyasar/moyasar.dart';
import 'package:samsung_pay_sdk_flutter/model/amount_box_control.dart';
import 'package:samsung_pay_sdk_flutter/model/custom_sheet.dart';
import 'package:samsung_pay_sdk_flutter/model/custom_sheet_payment_info.dart';
import 'package:samsung_pay_sdk_flutter/samsung_pay_sdk_flutter.dart';

/// Converts amount from minor units to major (e.g. 20001 -> 200.01 for SAR).
double _toMajorAmount(int amount, String currency) {
  switch (currency.toUpperCase()) {
    case 'KWD':
    case 'BHD':
    case 'OMR':
    case 'JOD':
      return amount / 1000;
    case 'JPY':
    case 'KRW':
      return amount.toDouble();
    default:
      return amount / 100;
  }
}

/// Extracts Samsung Pay token from payment credential.
/// For MADA/3DS (Saudi), the credential may be JSON with 3DS.data.
String _extractToken(String paymentCredential) {
  try {
    final parsed = jsonDecode(paymentCredential) as Map<String, dynamic>;
    final threeDs = parsed['3DS'];
    if (threeDs is Map && threeDs['data'] != null) {
      return threeDs['data'] as String;
    }
  } catch (_) {}
  return paymentCredential;
}

/// A widget that displays the Samsung Pay button.
///
/// Uses [samsung_pay_sdk_flutter] for native integration. The button is only
/// shown on Android Samsung devices when Samsung Pay is configured and ready.
///
/// Requires [PaymentConfig.samsungPay] to be set.
class SamsungPay extends StatefulWidget {
  /// Creates a Samsung Pay button widget.
  SamsungPay({
    super.key,
    required this.config,
    required this.onPaymentResult,
  }) : assert(
          config.samsungPay != null,
          'Samsung Pay requires samsungPay in PaymentConfig',
        );

  final PaymentConfig config;
  final Function onPaymentResult;

  @override
  State<SamsungPay> createState() => _SamsungPayState();
}

class _SamsungPayState extends State<SamsungPay> {
  bool _isReady = false;
  bool _isChecking = true;
  late SamsungPaySdkFlutter _samsungPay;

  @override
  void initState() {
    super.initState();
    _initSamsungPay();
  }

  void _initSamsungPay() {
    if (!Platform.isAndroid || widget.config.samsungPay == null) {
      setState(() {
        _isReady = false;
        _isChecking = false;
      });
      return;
    }

    final samsungConfig = widget.config.samsungPay!;
    _samsungPay = SamsungPaySdkFlutter(
      PartnerInfo(
        serviceId: samsungConfig.serviceId,
        data: {
          SpaySdk.PARTNER_SERVICE_TYPE: ServiceType.INAPP_PAYMENT.name,
        },
      ),
    );

    _samsungPay.getSamsungPayStatus(
      StatusListener(
        onSuccess: (status, bundle) {
          setState(() {
            _isReady = status.toString() == '2'; // SPAY_READY
            _isChecking = false;
          });
        },
        onFail: (errorCode, bundle) {
          setState(() {
            _isReady = false;
            _isChecking = false;
          });
        },
      ),
    );
  }

  List<Brand> _getBrandList() {
    final brands = <Brand>[];
    for (final net in widget.config.supportedNetworks) {
      switch (net.toJson()) {
        case 'visa':
          brands.add(Brand.VISA);
          break;
        case 'masterCard':
          brands.add(Brand.MASTERCARD);
          break;
        case 'amex':
          brands.add(Brand.AMERICANEXPRESS);
          break;
        case 'mada':
          brands.add(Brand.MADA);
          break;
      }
    }
    if (brands.isEmpty) {
      brands.addAll([Brand.VISA, Brand.MASTERCARD]);
    }
    return brands;
  }

  void _startPayment() async {
    final samsungConfig = widget.config.samsungPay!;
    final orderNumber = samsungConfig.orderNumber ??
        '${DateTime.now().millisecondsSinceEpoch}-${widget.config.amount}';

    final amountMajor =
        _toMajorAmount(widget.config.amount, widget.config.currency);

    final customSheet = CustomSheet();
    final amountControl =
        AmountBoxControl('moyasar_amount', widget.config.currency);
    amountControl.setAmountTotal(amountMajor, SpaySdk.FORMAT_TOTAL_PRICE_ONLY);
    customSheet.addControl(amountControl);

    final paymentInfo = CustomSheetPaymentInfo(
      merchantName: samsungConfig.merchantName,
      customSheet: customSheet,
      orderNumber: orderNumber,
    );
    paymentInfo.merchantId =
        widget.config.publishableApiKey.substring(0, 15.clamp(0, widget.config.publishableApiKey.length));
    paymentInfo.setMerchantCountryCode(widget.config.merchantCountryCode);
    paymentInfo.setAllowedCardBrands(_getBrandList());
    paymentInfo.setAddressInPaymentSheet(AddressInPaymentSheet.DO_NOT_SHOW);

    _samsungPay.startInAppPayWithCustomSheet(
      paymentInfo,
      CustomSheetTransactionInfoListener(
        onCardInfoUpdated: (cardInfo, sheet) {
          _samsungPay.updateSheet(sheet);
        },
        onSuccess: (info, paymentCredential, extraData) async {
          final token = _extractToken(paymentCredential);
          if (token.isEmpty) {
            widget.onPaymentResult(UnprocessableTokenError());
            return;
          }

          final source = SamsungPayPaymentRequestSource(
            samsungPayToken: token,
            manualPayment: samsungConfig.manual,
          );

          final paymentRequest = PaymentRequest(
            widget.config,
            source,
            additionalMetadata: {'samsungpay_order_id': orderNumber},
          );

          try {
            final result = await Moyasar.pay(
              apiKey: widget.config.publishableApiKey,
              paymentRequest: paymentRequest,
            );
            widget.onPaymentResult(result);
          } catch (e) {
            widget.onPaymentResult(NetworkError());
          }
        },
        onFail: (errorCode, bundle) {
          if (errorCode == '${SpaySdk.ERROR_USER_CANCELED}') {
            widget.onPaymentResult(PaymentCanceledError());
          } else {
            widget.onPaymentResult(UnprocessableTokenError());
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!Platform.isAndroid) {
      return const SizedBox.shrink();
    }

    // Hide until Samsung Pay status is ready; no loading indicator
    if (_isChecking || !_isReady || widget.config.samsungPay == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: _startPayment,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            'Samsung Pay',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
