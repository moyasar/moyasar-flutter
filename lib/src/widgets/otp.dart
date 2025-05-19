import 'package:flutter/material.dart';
import 'package:moyasar/src/models/sources/otp/otp_request_source.dart';

import '../../moyasar.dart';

class OtpComponent extends StatefulWidget {
  OtpComponent(
      {super.key,
      required this.transactionUrl,
      required this.onPaymentResult,
      this.locale = const Localization.en()})
      : textDirection =
            locale.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr;

  @override
  _OtpComponentState createState() => _OtpComponentState();

  final String transactionUrl;
  final Function onPaymentResult;
  final Localization locale;
  final TextDirection textDirection;
}

class _OtpComponentState extends State<OtpComponent> {
  final _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    _otpController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
    _otpController.removeListener(_validateForm);
  }

  void _validateForm() {
    final isValid = _otpController.text.length == 6;
    if (isValid != _isFormValid) {
      setState(() {
        _isFormValid = isValid;
      });
    }
  }

  void closeKeyboard() => FocusManager.instance.primaryFocus?.unfocus();

  void _sendOtp() async {
    setState(() => _isSubmitting = true);
    closeKeyboard();

    final otpRequest = OtpRequestSource(otpValue: _otpController.text);

    final result = await Moyasar.verifyOTP(
        transactionURL: widget.transactionUrl, otpRequest: otpRequest);
    setState(() => _isSubmitting = false);

    if (result is! PaymentResponse ||
        result.status != PaymentStatus.initiated) {
      widget.onPaymentResult(result);
    }

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Text(
                  widget.locale.oneTimePassword,
                  style: const TextStyle(fontSize: 16),
                ),
                const Spacer(),
              ],
            ),
            const SizedBox(height: 30),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextFormField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                textAlign: TextAlign.start,
                style: const TextStyle(
                  fontSize: 24,
                  letterSpacing: 10,
                ),
                buildCounter:
                    (context, {required currentLength, required isFocused, maxLength}) =>
                null,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return widget.locale.pleaseEnterOtp;
                  }
                  if (value.length != 6) {
                    return widget.locale.otpValidation;
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'XXXXXX',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade400,
                    letterSpacing: 8,
                    fontSize: 16,
                  ),

                  // ↓ Make this field more compact:
                  isDense: true, // ← reduces default vertical space
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8, // ← shrink this from 15 to around 8
                  ),

                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _sendOtp();
                  }
                },
                style: ButtonStyle(
                  minimumSize:
                  const WidgetStatePropertyAll<Size>(Size.fromHeight(55)),
                  backgroundColor: WidgetStatePropertyAll<Color>(
                    _isFormValid ? purpleColor : lightPurpleColor,
                  ),
                ),
                child: _isSubmitting
                    ? const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                )
                    : Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Text(
                    widget.locale.confirm,
                    style:
                    const TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}

Color purpleColor = Color(0xFF470793);
Color lightPurpleColor = Color(0xFFE3D3F6);
