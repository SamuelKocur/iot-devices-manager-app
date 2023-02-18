import 'package:flutter/material.dart';

class CustomTextTheme {
  static final themeData = ThemeData.light().textTheme.copyWith(
        headline1: const TextStyle(
          color: Colors.black,
          fontSize: 28,
          fontWeight: FontWeight.w600,
        ),
        bodyText1: const TextStyle(
          color: Color.fromRGBO(74, 72, 99, 1),
          fontSize: 14,
        ),
        bodyText2: const TextStyle(
          fontSize: 16,
          color: Colors.black,
        ),
      );
}
