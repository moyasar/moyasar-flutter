import 'package:flutter/material.dart';

import '../../moyasar.dart';

class OtpComponent extends StatefulWidget {
  OtpComponent(
      {super.key,
      required this.transactionUrl,
      required this.onPaymentResult,
      this.locale = const Localization.en()})
      : textDirection =
            locale.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr;

  final String transactionUrl;
  final Function onPaymentResult;
  final Localization locale;
  final TextDirection textDirection;

  @override
  State<OtpComponent> createState() => _OtpComponentState();
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
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _otpController.text.isNotEmpty && !_isFormValid
                  ? widget.locale.otpValidation
                  : widget.locale.oneTimePassword,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _otpController.text.isNotEmpty && !_isFormValid
                    ? Colors.red
                    : Colors.black,
              ),
              textDirection: widget.textDirection,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              maxLength: 10, // allow 4–10 digits
              textAlign: TextAlign.start,
              style: const TextStyle(
                fontSize: 20,
                letterSpacing: 10,
              ),
              buildCounter: (context,
                      {required currentLength,
                      required isFocused,
                      maxLength}) =>
                  null,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return widget.locale.pleaseEnterOtp;
                }
                if (value.length < 4 || value.length > 10) {
                  return widget.locale.otpValidation;
                }
                return null;
              },
              decoration: InputDecoration(
                hintText: 'XXXXXX',
                hintStyle: const TextStyle(
                  color: Colors.grey,
                  letterSpacing: 8,
                  fontSize: 20,
                ),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  borderSide: BorderSide(color: purpleColor, width: 1.5),
                ),
              ),

              onChanged: (value) {
                setState(() {
                  _isFormValid = value.isNotEmpty &&
                      value.length >= 4 &&
                      value.length <= 10;
                });
              },
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isFormValid
                    ? () {
                        if (_formKey.currentState!.validate()) {
                          _sendOtp();
                        }
                      }
                    : null,
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
                          style: const TextStyle(
                              fontSize: 18, color: Colors.white),
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
