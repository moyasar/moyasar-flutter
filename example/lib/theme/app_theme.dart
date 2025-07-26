// lib/core/themes/app_theme.dart

import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme._();

  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: kBackgroundColor,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    scaffoldBackgroundColor: kBackgroundColor,
    appBarTheme: AppBarTheme(
      backgroundColor: kBackgroundColor,
      foregroundColor: kLightTextColor,
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: kLightSecondaryColor),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(kBackgroundColor),
            foregroundColor: WidgetStatePropertyAll(kLightPrimaryColor))),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: kBackgroundColor,
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: Colors.black54, width: 3.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4.0),
        borderSide: BorderSide(color: kLightTextColor),
      ),
    ),
    fontFamily: 'ElMessiri',
    colorScheme: ColorScheme.light(
        primary: kLightParticlesColor,
        secondary: kLightSecondaryColor,
        surface: kBackgroundColor,
        onPrimary: kLightPrimaryColor),
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: kDarkPrimaryColor,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    scaffoldBackgroundColor: kDarkBackgroundColor,
    appBarTheme: AppBarTheme(
      backgroundColor: kDarkBackgroundColor,
      foregroundColor: kDarkTextColor,
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: kDarkTextColor),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(kDarkAccentColor),
            foregroundColor: WidgetStatePropertyAll(kDarkTextColor))),
    inputDecorationTheme: InputDecorationTheme(
        fillColor: kDarkBackgroundColor,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Colors.white30, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.0),
          borderSide: BorderSide(color: kDarkAccentColor),
        )),
    fontFamily: 'ElMessiri',
    colorScheme: ColorScheme.dark(
        primary: kDarkBackgroundColor,
        secondary: kBackgroundColor,
        surface: kDarkPrimaryColor,
        onPrimary: kDarkAccentColor),
  );
}

Color kLightBackgroundColor = const Color(0xffffffff);
Color kBackgroundColor = const Color(0xFFFFFFFF);
Color kLightPrimaryColor =
    Colors.blueGrey.shade600; //const Color.fromARGB(255, 118, 101, 179);
Color kLightSecondaryColor = const Color(0xff040415);
Color kLightParticlesColor = const Color(0x44948282);
const Color kLightTextColor = Colors.black;

Color kDarkBackgroundColor = const Color(0xFF1A2127);
Color kDarkPrimaryColor = const Color(0xFF1A2127);
Color kDarkAccentColor = Colors.blueGrey.shade600;
Color kDarkParticlesColor = const Color(0x441C2A3D);
Color kDarkTextColor = Colors.white;
