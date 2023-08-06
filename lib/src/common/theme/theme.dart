import 'package:flutter/material.dart';

const kDefaultTextColor = Color(0xFF2B2D33);

final appTheme = ThemeData(
    brightness: Brightness.light,
    textTheme: const TextTheme(
      // H1
      headlineLarge: TextStyle(
        fontFamily: 'Ubuntu',
        fontSize: 32,
        height: .8,
        color: kDefaultTextColor,
      ),
      // H2
      headlineMedium: TextStyle(
        fontFamily: 'Ubuntu',
        fontSize: 22,
        height: .7,
        color: kDefaultTextColor,
      ),
      // B1
      titleLarge: TextStyle(
        fontFamily: 'Roboto',
        fontSize: 17,
        height: .7,
        color: kDefaultTextColor,
      ),
      // B2
      titleMedium: TextStyle(
        fontFamily: 'Roboto',
        fontSize: 15,
        height: .6,
        color: kDefaultTextColor,
      ),
      // B3
      titleSmall: TextStyle(
        fontFamily: 'Roboto',
        fontSize: 13,
        height: .7,
        color: kDefaultTextColor,
      ),
    ));
