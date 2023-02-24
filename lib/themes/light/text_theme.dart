import 'package:flutter/material.dart';

class CustomTextTheme {
  static final themeData = ThemeData.light().textTheme.copyWith(
        headline1: const TextStyle(
          // headline in auth screens
          color: Colors.black,
          fontSize: 28,
          fontWeight: FontWeight.w600,
        ),
        headline5: const TextStyle(
          // title in app bar
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        headline6: const TextStyle(
          // Cards, tiles title
          fontSize: 16,
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
        bodyText1: const TextStyle(
          // smaller grey letters
          color: Color.fromRGBO(74, 72, 99, 1),
          fontSize: 14,
        ),
        bodyText2: const TextStyle(
          fontSize: 16,
          color: Colors.black,
        ),
      );
}

class DeviceCardTextStyle {
  static const data = TextStyle(
    color: Colors.black,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.25,
  );
}

class TextInDetailsScreen {
  static const data = TextStyle(
    color: Color.fromRGBO(74, 72, 99, 1),
    fontSize: 18,
    fontWeight: FontWeight.w500,
  );
}
