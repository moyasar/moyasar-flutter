import 'package:flutter/material.dart';

import '../utils/moyasar_text_styles.dart';

/// Visual customization for the [CreditCard] widget.
///
/// Every value is optional and defaults to the SDK's built-in look, so
/// omitting the theme keeps the previous appearance unchanged. Pass a theme to
/// blend the form into the host app — most importantly to support a dark mode,
/// which the built-in light-only defaults cannot express:
///
/// ```dart
/// CreditCard(
///   config: config,
///   onPaymentResult: onPaymentResult,
///   theme: CreditCardTheme(
///     backgroundColor: myTheme.background,
///     fieldColor: myTheme.surface,
///     labelColor: myTheme.headingText,
///     buttonColor: myTheme.primary,
///     noticeColor: myTheme.descriptionText,
///     fontFamily: 'MyAppFont',
///   ),
/// )
/// ```
@immutable
class CreditCardTheme {
  const CreditCardTheme({
    this.backgroundColor,
    this.fieldColor = Colors.white,
    this.fieldShadowColor = Colors.black26,
    this.labelColor = Colors.black,
    this.inputTextColor,
    this.hintColor = const Color(0xFF9E9E9E),
    this.errorColor = Colors.red,
    this.buttonColor = defaultAccentColor,
    this.disabledButtonColor,
    this.buttonTextColor = Colors.white,
    this.noticeColor = defaultAccentColor,
    this.fontFamily = MoyasarStyles.fontFamily,
  });

  /// The SDK's default accent, used for the pay button and the save-card
  /// notice when no override is supplied.
  static const Color defaultAccentColor = Color(0xFF768DFF);

  /// Painted behind the whole form. When null nothing is painted and the
  /// surrounding widget's background shows through.
  final Color? backgroundColor;

  /// Fill color of the boxes wrapping the input fields.
  final Color fieldColor;

  /// Drop-shadow color of those boxes.
  final Color fieldShadowColor;

  /// Color of the field labels ("Name on card", "Card information").
  final Color labelColor;

  /// Color of the text the user types. Defaults to [labelColor].
  final Color? inputTextColor;

  /// Color of the placeholder text inside the fields.
  final Color hintColor;

  /// Color labels turn when their field fails validation.
  final Color errorColor;

  /// Background of the pay button while it is enabled.
  final Color buttonColor;

  /// Background of the pay button while it is disabled. Defaults to
  /// [buttonColor] at 30% opacity.
  final Color? disabledButtonColor;

  /// Color of the pay button's label, amount and progress indicator.
  final Color buttonTextColor;

  /// Color of the save-card notice icon and text.
  final Color noticeColor;

  /// Font family applied across the form. Defaults to the font bundled with
  /// the SDK; set it to use the host app's font instead.
  final String fontFamily;

  Color get resolvedInputTextColor => inputTextColor ?? labelColor;

  Color get resolvedDisabledButtonColor =>
      disabledButtonColor ?? buttonColor.withValues(alpha: 0.3);

  /// Color for a label that is showing [error] when non-null.
  Color labelColorFor(Object? error) =>
      error != null ? errorColor : labelColor;

  CreditCardTheme copyWith({
    Color? backgroundColor,
    Color? fieldColor,
    Color? fieldShadowColor,
    Color? labelColor,
    Color? inputTextColor,
    Color? hintColor,
    Color? errorColor,
    Color? buttonColor,
    Color? disabledButtonColor,
    Color? buttonTextColor,
    Color? noticeColor,
    String? fontFamily,
  }) {
    return CreditCardTheme(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      fieldColor: fieldColor ?? this.fieldColor,
      fieldShadowColor: fieldShadowColor ?? this.fieldShadowColor,
      labelColor: labelColor ?? this.labelColor,
      inputTextColor: inputTextColor ?? this.inputTextColor,
      hintColor: hintColor ?? this.hintColor,
      errorColor: errorColor ?? this.errorColor,
      buttonColor: buttonColor ?? this.buttonColor,
      disabledButtonColor: disabledButtonColor ?? this.disabledButtonColor,
      buttonTextColor: buttonTextColor ?? this.buttonTextColor,
      noticeColor: noticeColor ?? this.noticeColor,
      fontFamily: fontFamily ?? this.fontFamily,
    );
  }
}
