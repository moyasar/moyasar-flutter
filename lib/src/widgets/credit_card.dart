import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moyasar/moyasar.dart';
import 'package:moyasar/src/utils/card_utils.dart';
import 'package:moyasar/src/utils/input_formatters.dart';
import 'package:moyasar/src/utils/card_network_utils.dart';
import 'package:moyasar/src/widgets/network_icons.dart';
import 'package:moyasar/src/widgets/three_d_s_webview.dart';

/// The widget that shows the Credit Card form and manages the 3DS step.
class CreditCard extends StatefulWidget {
  CreditCard(
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
  State<CreditCard> createState() => _CreditCardState();
}

class _CreditCardState extends State<CreditCard> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _cardData = CardFormModel();

  AutovalidateMode _autoValidateMode = AutovalidateMode.onUserInteraction;

  bool _isSubmitting = false;
  bool _tokenizeCard = false;
  bool _manualPayment = false;

  // Network detection state
  CardNetwork? _detectedNetwork;
  bool _unsupportedNetwork = false;

  // Error state for each field
  String? _nameError;
  String? _cardNumberError;
  String? _expiryError;
  String? _cvcError;

  // Track if fields have been filled
  bool _nameFieldFilled = false;
  bool _cardNumberFieldFilled = false;
  bool _expiryFieldFilled = false;
  bool _cvcFieldFilled = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _tokenizeCard = widget.config.creditCard?.saveCard ?? false;
      _manualPayment = widget.config.creditCard?.manual ?? false;
    });
  }

  // Check if button should be enabled
  bool get _isButtonEnabled {
    // Check if all fields are filled and there are no errors
    bool allFieldsFilled = _nameFieldFilled &&
        _cardNumberFieldFilled &&
        _expiryFieldFilled &&
        _cvcFieldFilled;

    bool noErrors = _nameError == null &&
        _cardNumberError == null &&
        _expiryError == null &&
        _cvcError == null;

    return allFieldsFilled && noErrors && !_isSubmitting;
  }

  void _saveForm() async {
    if (!_isButtonEnabled) return;

    closeKeyboard();

    bool isValidForm =
        _formKey.currentState != null && _formKey.currentState!.validate();

    if (!isValidForm) {
      setState(() => _autoValidateMode = AutovalidateMode.onUserInteraction);
      return;
    }

    _formKey.currentState?.save();

    final source = CardPaymentRequestSource(
        creditCardData: _cardData,
        tokenizeCard: _tokenizeCard,
        manualPayment: _manualPayment);
    final paymentRequest = PaymentRequest(widget.config, source);

    setState(() => _isSubmitting = true);

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
        (result.source as CardPaymentResponseSource).transactionUrl;

    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
            fullscreenDialog: true,
            maintainState: false,
            builder: (context) => ThreeDSWebView(
                transactionUrl: transactionUrl,
                on3dsDone: (String status, String message) async {
                  if (status == PaymentStatus.paid.name) {
                    result.status = PaymentStatus.paid;
                  } else if (status == PaymentStatus.authorized.name) {
                    result.status = PaymentStatus.authorized;
                  } else {
                    result.status = PaymentStatus.failed;
                    (result.source as CardPaymentResponseSource).message =
                        message;
                  }
                  Navigator.pop(context);
                  widget.onPaymentResult(result);
                })),
      );
    }
  }

  // Validate name on change
  void _validateName(String? value) {
    setState(() {
      _nameError = CardUtils.validateName(value, widget.locale);
      _nameFieldFilled = value != null && value.trim().isNotEmpty;
    });
  }

  // Validate card number on change
  void _validateCardNumber(String? value) {
    setState(() {
      _cardNumberError = CardUtils.validateCardNum(value, widget.locale);
      _cardNumberFieldFilled =
          value != null && value.replaceAll(' ', '').length >= 13;

      if (value != null && value.isNotEmpty) {
        final cleaned = value.replaceAll(RegExp(r'\D'), '');

        if (cleaned.length >= 4) {
          final detected = detectNetwork(cleaned);

          if (detected != CardNetwork.unknown) {
            _detectedNetwork = detected;

            final supported = widget.config.supportedNetworks.map((e) => e.name).toSet();
            final detectedName = detected.name;

            if (!supported.contains(detectedName)) {
              _unsupportedNetwork = true;
              _cardNumberError = widget.locale.unsupportedNetwork;
            } else {
              _unsupportedNetwork = false;
            }
          } else {
            _detectedNetwork = null;
            _unsupportedNetwork = false;
          }
        } else {
          _detectedNetwork = null;
          _unsupportedNetwork = false;
        }
      } else {
        _detectedNetwork = null;
        _unsupportedNetwork = false;
      }
    });
  }

  // Validate expiry date on change
  void _validateExpiry(String? value) {
    setState(() {
      final cleanValue = value?.replaceAll('\u200E', '') ?? '';
      _expiryError = CardUtils.validateDate(cleanValue, widget.locale);
      _expiryFieldFilled = cleanValue.length >= 5; // MM/YY format
    });
  }

  // Validate CVC on change
  void _validateCVC(String? value) {
    setState(() {
      _cvcError = CardUtils.validateCVC(value, widget.locale);
      _cvcFieldFilled = value != null && value.length >= 3;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      autovalidateMode: _autoValidateMode,
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(_nameError ?? widget.locale.nameOnCard,
              textAlign: widget.textDirection == TextDirection.rtl
                  ? TextAlign.right
                  : TextAlign.left,
              style: TextStyle(
                fontFamily: 'Aeonik',
                fontWeight: FontWeight.w500, // Medium weight
                fontSize: 16,
                color: _nameError != null ? Colors.red : Colors.black,
              )),
          SizedBox(
            height: 8,
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            child: CardFormField(
              inputDecoration: buildInputDecoration(
                  hintText: widget.locale.nameOnCard,
                  hideBorder: true,
                  hintTextDirection: widget.textDirection),
              keyboardType: TextInputType.text,
              onChanged: _validateName,
              onSaved: (value) => _cardData.name = value ?? '',
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp('[a-zA-Z. ]')),
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Text(
              _cardNumberError ??
                  _expiryError ??
                  _cvcError ??
                  widget.locale.cardInformation,
              textAlign: widget.textDirection == TextDirection.rtl
                  ? TextAlign.right
                  : TextAlign.left,
              style: TextStyle(
                fontFamily: 'Aeonik',
                fontWeight: FontWeight.w500, // Medium weight
                fontSize: 16,
                color: (_cardNumberError != null ||
                    _expiryError != null ||
                    _cvcError != null)
                    ? Colors.red
                    : Colors.black,
              )),
          SizedBox(
            height: 8,
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            child: Column(
              crossAxisAlignment: widget.textDirection == TextDirection.rtl
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                CardFormField(
                  inputDecoration: buildInputDecoration(
                      hintText: widget.locale.cardNumber,
                      hintTextDirection: widget.textDirection,
                      hideBorder: true,
                      addNetworkIcons: true,
                      config: widget.config,
                      detectedNetwork: _detectedNetwork,
                      unsupportedNetwork: _unsupportedNetwork),
                  onChanged: _validateCardNumber,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(16),
                    CardNumberInputFormatter(),
                  ],
                  onSaved: (value) =>
                  _cardData.number = CardUtils.getCleanedNumber(value!),
                ),
                const Divider(height: 2),
                Row(
                  textDirection: widget.textDirection,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: widget.textDirection == TextDirection.rtl
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          CardFormField(
                            inputDecoration: buildInputDecoration(
                              hintText: '${widget.locale.expiry} (MM / YY)',
                              hintTextDirection: widget.textDirection,
                              hideBorder: true,
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(4),
                              CardMonthInputFormatter(),
                            ],
                            onChanged: _validateExpiry,
                            onSaved: (value) {
                              List<String> expireDate = CardUtils.getExpiryDate(
                                  value!.replaceAll('\u200E', ''));
                              _cardData.month =
                                  expireDate.first.replaceAll('\u200E', '');
                              _cardData.year =
                                  expireDate[1].replaceAll('\u200E', '');
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 48,
                      child: VerticalDivider(
                        color: Colors.grey,
                        thickness: 1,
                        width: 2,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: widget.textDirection == TextDirection.rtl
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          CardFormField(
                            inputDecoration: buildInputDecoration(
                              hintText: widget.locale.cvc,
                              hintTextDirection: widget.textDirection,
                              hideBorder: true,
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(4),
                            ],
                            onChanged: _validateCVC,
                            onSaved: (value) => _cardData.cvc = value ?? '',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: SizedBox(
              child: ElevatedButton(
                style: ButtonStyle(
                  minimumSize:
                  const WidgetStatePropertyAll<Size>(Size.fromHeight(52)),
                  backgroundColor: WidgetStatePropertyAll<Color>(
                    _isButtonEnabled ? blueColor : lightBlueColor,
                  ),
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
                onPressed: _isButtonEnabled ? _saveForm : null,
                child: _isSubmitting
                    ? const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                )
                    : Directionality(
                  textDirection: widget.textDirection,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    textDirection: widget.textDirection,
                    children: [
                      Spacer(),
                      Text(
                        '${widget.locale.pay} ',
                        style: const TextStyle(
                          fontFamily: 'Aeonik',
                          color: Colors.white,
                          fontWeight: FontWeight.w500, // Medium weight
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
                          )),
                      const SizedBox(width: 4),
                      Text(
                        getAmount(widget.config.amount),
                        style: const TextStyle(
                          fontFamily: 'Aeonik',
                          color: Colors.white,
                          fontWeight: FontWeight.w500, // Medium weight
                          fontSize: 16,
                        ),
                        textDirection: widget.textDirection,
                      ),
                      Spacer(),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          Image.asset(
            'assets/images/moyasarlogo.png',
            package: 'moyasar',
            height: 20, // You can adjust the height as needed
          ),
          SaveCardNotice(
            tokenizeCard: _tokenizeCard,
            locale: widget.locale,
            textDirection: widget.textDirection,
          ),
        ],
      ),
    );
  }
}

class SaveCardNotice extends StatelessWidget {
  const SaveCardNotice({
    super.key,
    required this.tokenizeCard,
    required this.locale,
    required this.textDirection,
  });

  final bool tokenizeCard;
  final Localization locale;
  final TextDirection textDirection;

  @override
  Widget build(BuildContext context) {
    final isRTL = textDirection == TextDirection.rtl;

    return tokenizeCard
        ? Padding(
        padding: const EdgeInsets.all(8.0),
        child: Directionality(
          textDirection: textDirection,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            textDirection: textDirection,
            children: [
              Icon(
                Icons.info,
                color: blueColor,
              ),
              SizedBox(width: 5),
              Flexible(
                child: Text(
                  locale.saveCardNotice,
                  style: TextStyle(fontFamily: 'Aeonik', color: blueColor, fontWeight: FontWeight.w500),
                  textDirection: textDirection,
                  textAlign: isRTL ? TextAlign.right : TextAlign.left,
                ),
              ),
            ],
          ),
        ))
        : const SizedBox.shrink();
  }
}

class CardFormField extends StatelessWidget {
  final void Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final void Function(String?)? onChanged;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final InputDecoration? inputDecoration;

  const CardFormField(
      {super.key,
        required this.onSaved,
        this.validator,
        this.onChanged,
        this.inputDecoration,
        this.keyboardType = TextInputType.number,
        this.textInputAction = TextInputAction.next,
        this.inputFormatters});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: TextFormField(
        style: const TextStyle(fontFamily: 'Aeonik'), // Font for input text
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        decoration: inputDecoration,
        validator: validator,
        onSaved: onSaved,
        onChanged: onChanged,
        inputFormatters: inputFormatters,
        textDirection: inputDecoration?.hintTextDirection,
        textAlign: inputDecoration?.hintTextDirection == TextDirection.rtl
            ? TextAlign.right
            : TextAlign.left,
      ),
    );
  }
}

String showAmount(int amount, String currency, Localization locale) {
  final formattedAmount = (amount / 100).toStringAsFixed(2);
  return '${locale.pay} $currency $formattedAmount';
}

String getAmount(int amount) {
  final formattedAmount = (amount / 100).toStringAsFixed(2);
  return formattedAmount;
}

InputDecoration buildInputDecoration(
    {required String hintText,
      required TextDirection hintTextDirection,
      bool addNetworkIcons = false,
      bool hideBorder = false,
      PaymentConfig? config,
      CardNetwork? detectedNetwork,
      bool unsupportedNetwork = false}) {
  Widget? iconWidget;
  if (addNetworkIcons && config != null) {
    if (detectedNetwork != null) {
      final supported = config.supportedNetworks.map((e) => e.name).toSet();
      final detectedName = detectedNetwork.name;
      if (supported.contains(detectedName)) {
        // Show only the detected network icon when it's supported
        iconWidget = NetworkIcons(
          config: PaymentConfig(
            publishableApiKey: config.publishableApiKey,
            amount: config.amount,
            currency: config.currency,
            description: config.description,
            supportedNetworks: [PaymentNetwork.values.firstWhere((e) => e.name == detectedName)],
          ),
          textDirection: hintTextDirection,
        );
      } else {
        // Show all configured networks when detected network is not supported
        iconWidget = NetworkIcons(
          config: config,
          textDirection: hintTextDirection,
        );
      }
    } else {
      // Show all configured networks when no network is detected or there are errors
      iconWidget = NetworkIcons(
        config: config,
        textDirection: hintTextDirection,
      );
    }
  }

  final isRTL = hintTextDirection == TextDirection.rtl;

  return InputDecoration(
    suffixIcon: isRTL ? null : iconWidget,
    prefixIcon: isRTL ? iconWidget : null,
    hintText: hintText,
    hintStyle: const TextStyle(fontFamily: 'Aeonik', color: Color(0xFF9E9E9E)), // Font for hint text
    border: hideBorder ? InputBorder.none : defaultEnabledBorder,
    isDense: true,
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    hintTextDirection: hintTextDirection,
  );
}

void closeKeyboard() => FocusManager.instance.primaryFocus?.unfocus();

BorderRadius defaultBorderRadius = const BorderRadius.all(Radius.circular(8));

OutlineInputBorder defaultEnabledBorder = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.grey[400]!),
    borderRadius: defaultBorderRadius);

OutlineInputBorder defaultFocusedBorder = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.grey[600]!),
    borderRadius: defaultBorderRadius);

OutlineInputBorder defaultErrorBorder = OutlineInputBorder(
    borderSide: const BorderSide(color: Colors.red),
    borderRadius: defaultBorderRadius);

Color blueColor = const Color(0xFF768DFF); // Updated color
Color lightBlueColor = const Color(0xFF768DFF).withValues(alpha: 0.3);
