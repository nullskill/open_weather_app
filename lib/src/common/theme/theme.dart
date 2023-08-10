import 'package:flutter/material.dart';

const kPrimaryTextColor = Color(0xFF2B2D33);
const kSecondaryTextColor = Color(0xFF8799A5);
const kTertiaryTextColor = Color(0xFFE4E6EC);
const kActiveTextColor = Color(0xFF0700FF);
const kCursorTextColor = Color(0xFFFF585D);
const kGradientColor = Color(0xFF0700FF);
const kWhiteColor = Colors.white;

final lightTheme = ThemeData(
  brightness: Brightness.light,

  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: kGradientColor,
  ),

  /// TextField
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: kCursorTextColor,
  ),

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

final darkTheme = lightTheme.copyWith(
  brightness: Brightness.light,

  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: kWhiteColor,
  ),

  /// TextField
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: kCursorTextColor,
  ),

  /// Text styles
  textTheme: TextTheme(
    // H1
    headlineLarge: lightTheme.textTheme.headlineLarge?.copyWith(
      color: kWhiteColor,
    ),
    // H2
    headlineMedium: lightTheme.textTheme.headlineMedium?.copyWith(
      color: kWhiteColor,
    ),
    // B1
    titleLarge: lightTheme.textTheme.titleLarge?.copyWith(
      color: kWhiteColor,
    ),
    // B2
    titleMedium: lightTheme.textTheme.titleMedium?.copyWith(
      color: kWhiteColor,
    ),
    // B3
    titleSmall: lightTheme.textTheme.titleSmall?.copyWith(
      color: kWhiteColor,
    ),
  ),
);
