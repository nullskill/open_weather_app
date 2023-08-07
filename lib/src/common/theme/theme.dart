import 'package:flutter/material.dart';

const kPrimaryTextColor = Color(0xFF2B2D33);
const kSecondaryTextColor = Color(0xFF8799A5);
const kTertiaryTextColor = Color(0xFFE4E6EC);
const kActiveTextColor = Color(0xFF0700FF);
const kCursorTextColor = Color(0xFFFF585D);
const kGradientColor = Color(0xFF0700FF);

final appTheme = ThemeData(
  brightness: Brightness.light,

  /// Text styles
  textTheme: const TextTheme(
    // H1
    headlineLarge: TextStyle(
      fontFamily: 'Ubuntu',
      fontSize: 32,
      color: kPrimaryTextColor,
    ),
    // H2
    headlineMedium: TextStyle(
      fontFamily: 'Ubuntu',
      fontSize: 22,
      color: kPrimaryTextColor,
    ),
    // B1
    titleLarge: TextStyle(
      fontFamily: 'Roboto',
      fontSize: 17,
      color: kPrimaryTextColor,
    ),
    // B2
    titleMedium: TextStyle(
      fontFamily: 'Roboto',
      fontSize: 15,
      color: kPrimaryTextColor,
    ),
    // B3
    titleSmall: TextStyle(
      fontFamily: 'Roboto',
      fontSize: 13,
      color: kPrimaryTextColor,
    ),
  ),

  /// TextField
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: kCursorTextColor,
  ),

  /// InputDecorationTheme
  inputDecorationTheme: const InputDecorationTheme(
    labelStyle: TextStyle(color: kSecondaryTextColor),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: kTertiaryTextColor,
      ),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: kActiveTextColor,
        width: 2,
      ),
    ),
  ),
);
