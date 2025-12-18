import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moyasar/moyasar.dart';


class STCPaymentComponent extends StatefulWidget {
  STCPaymentComponent(
      {super.key,
      required this.config,
      required this.onPaymentResult,
      this.locale = const Localization.en()})
      : textDirection =
            locale.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr;

  final Function onPaymentResult;
  final PaymentConfig config;
  final Localization locale;
  final TextDirection textDirection;

  @override
  State<STCPaymentComponent> createState() => _STCPaymentFormState();
}

class _STCPaymentFormState extends State<STCPaymentComponent> {
  final TextEditingController _controller = TextEditingController();
  bool _isValid = false;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_handleTextChanges);
  }

  @override
  void dispose() {
    _controller.removeListener(_handleTextChanges);
    _controller.dispose();
    super.dispose();
  }

  void _handleTextChanges() {
    // Store the current text and cursor position
    final text = _controller.text;
    final cursorPosition = _controller.selection.start;

    // Skip if cursor position is invalid
    if (cursorPosition == -1) return;

    // Get just the digits from the text
    final digitsOnly = text.replaceAll(RegExp(r'[^\d]'), '');

    // CASE 1: Handle empty field - ensure it's completely empty with no prefix
    if (digitsOnly.isEmpty) {
      if (text.isNotEmpty) {
        _controller.removeListener(_handleTextChanges);
        _controller.value = const TextEditingValue(
          text: '',
          selection: TextSelection.collapsed(offset: 0),
        );
        _controller.addListener(_handleTextChanges);
      }

      setState(() {
        _isValid = false;
      });
      return;
    }

    // CASE 2: Special handling for when user is typing "0" or "05"
    if (digitsOnly == "0") {
      // Allow user to enter a single "0" without forcing prefix yet
      if (text != "0") {
        _controller.removeListener(_handleTextChanges);
        _controller.value = const TextEditingValue(
          text: '0',
          selection: TextSelection.collapsed(offset: 1),
        );
        _controller.addListener(_handleTextChanges);
      }

      setState(() {
        _isValid = false;
      });
      return;
    }

    // CASE 3: Special case for entering or deleting from "05"
    if (digitsOnly == "05") {
      if (text != "05") {
        _controller.removeListener(_handleTextChanges);
        _controller.value = const TextEditingValue(
          text: '05',
          selection: TextSelection.collapsed(offset: 2),
        );
        _controller.addListener(_handleTextChanges);
      }

      // If user is trying to delete from "05", clear it completely
      if (text.length > digitsOnly.length && cursorPosition <= 2) {
        _controller.removeListener(_handleTextChanges);
        _controller.value = const TextEditingValue(
          text: '',
          selection: TextSelection.collapsed(offset: 0),
        );
        _controller.addListener(_handleTextChanges);

        setState(() {
          _isValid = false;
        });
      } else {
        setState(() {
          _isValid = false;
        });
      }
      return;
    }

    // CASE 4: Normal phone number with prefix
    bool hasPrefix = digitsOnly.startsWith('05') && digitsOnly.length >= 2;

    // Ensure we don't exceed 10 digits total
    String processedDigits;
    if (hasPrefix) {
      // Already has prefix, just limit to 10 digits
      processedDigits = digitsOnly.substring(0, min(digitsOnly.length, 10));
    } else {
      // No prefix yet, add "05" and limit remaining digits
      processedDigits =
          '05${digitsOnly.substring(0, min(digitsOnly.length, 8))}';
      hasPrefix = true; // Now we have a prefix
    }

    // Format the phone number
    String formatted;

    // Apply the format: 05x xxx xxxx
    if (processedDigits.length <= 3) {
      formatted = processedDigits;
    } else if (processedDigits.length <= 6) {
      formatted =
          '${processedDigits.substring(0, 3)} ${processedDigits.substring(3)}';
    } else {
      formatted =
          '${processedDigits.substring(0, 3)} ${processedDigits.substring(3, 6)} ${processedDigits.substring(6)}';
    }

    // Only update if the text has changed
    if (text != formatted) {
      // Calculate new cursor position
      int newCursorPosition;

      // Special case: if we just added the prefix, put cursor at the end
      if (!text.startsWith('05') && formatted.startsWith('05')) {
        newCursorPosition = formatted.length;
      } else {
        // Try to maintain cursor position relative to digit count
        int oldDigitsBeforeCursor = 0;
        for (int i = 0; i < cursorPosition && i < text.length; i++) {
          if (text[i].contains(RegExp(r'\d'))) {
            oldDigitsBeforeCursor++;
          }
        }

        // Find position in new text with same digit count
        newCursorPosition = 0;
        int digitCount = 0;
        for (int i = 0; i < formatted.length; i++) {
          if (formatted[i].contains(RegExp(r'\d'))) {
            digitCount++;
          }
          if (digitCount >= oldDigitsBeforeCursor) {
            newCursorPosition = i + 1;
            break;
          }
        }

        // If we were at the end before, stay at the end
        if (cursorPosition >= text.length) {
          newCursorPosition = formatted.length;
        }
      }

      // Update text while avoiding listener recursion
      _controller.removeListener(_handleTextChanges);
      _controller.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(
            offset: min(newCursorPosition, formatted.length)),
      );
      _controller.addListener(_handleTextChanges);
    }

    // Update state
    setState(() {
      _isValid = processedDigits.length == 10;
    });
  }

  String getAmount(int amount) {
    final formattedAmount = (amount / 100).toStringAsFixed(2);
    return formattedAmount;
  }

  void _payWithSTC() async {
    setState(() => _isSubmitting = true);
    closeKeyboard();

    final paymentRequest = PaymentRequest(
        widget.config, StcRequestSource(mobile: _controller.text));

    final result = await Moyasar.pay(
        apiKey: widget.config.publishableApiKey,
        paymentRequest: paymentRequest);
    setState(() => _isSubmitting = false);

    if (result is! PaymentResponse ||
        result.status != PaymentStatus.initiated) {
      widget.onPaymentResult(result);
      return;
    }

    final String transactionUrl =
        (result.source as StcResponseSource).transactionUrl ?? "";

    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Scaffold(
                  appBar: AppBar(),
                  body: OtpComponent(
                    transactionUrl: transactionUrl,
                    onPaymentResult: widget.onPaymentResult,
                  ),
                )),
      );
    }
  }

  void closeKeyboard() => FocusManager.instance.primaryFocus?.unfocus();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Spacer(),

            // ↓ Show error in this label if invalid, otherwise show the normal title
            Text(
              _controller.text.isNotEmpty && !_isValid
                  ? widget.locale.invalidPhoneNumber
                  : widget.locale.mobileNumber,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _controller.text.isNotEmpty && !_isValid
                    ? Colors.red // error color
                    : Colors.black, // normal color
              ),
              textDirection: widget.textDirection,
            ),

            const SizedBox(height: 12),

            // TextField without the old errorText under it
            TextField(
              controller: _controller,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[\d ]')),
                LengthLimitingTextInputFormatter(12), // 05x xxx xxxx = 12 chars
              ],
              decoration: InputDecoration(
                hintText: '05x xxx xxxx',
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 20,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12.0,
                  horizontal: 16.0,
                ),
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
                // ▼ Removed the old errorText here
                // errorText: _controller.text.isNotEmpty && !_isValid
                //     ? widget.locale.invalidPhoneNumber
                //     : null,
              ),
              style: const TextStyle(fontSize: 20),
              onChanged: (_) {
                // ensure label updates when user types
                setState(() {});
              },
            ),

            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ButtonStyle(
                  minimumSize: const WidgetStatePropertyAll<Size>(
                    Size.fromHeight(55),
                  ),
                  backgroundColor: WidgetStatePropertyAll<Color>(
                    _isValid ? purpleColor : lightPurpleColor,
                  ),
                ),
                onPressed: _isValid
                    ? () {
                        _payWithSTC();
                      }
                    : null,
                child: _isSubmitting
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Spacer(),
                          Text(
                            '${widget.locale.pay} ',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            textDirection: widget.textDirection,
                          ),
                          SizedBox(
                            width: 16,
                            child: Image.asset(
                              'assets/images/saudiriyal.png',
                              color: Colors.white,
                              package: 'moyasar',
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            getAmount(widget.config.amount),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            textDirection: widget.textDirection,
                          ),
                          const Spacer(),
                        ],
                      ),
              ),
            ),

            const SizedBox(height: 24),
            Spacer(),
          ],
        ),
      ),
    );
  }
}

Color purpleColor = Color(0xFF470793);
Color lightPurpleColor = Color(0xFFE3D3F6);
