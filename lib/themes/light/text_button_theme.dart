import 'package:flutter/material.dart';

class CustomTextButtonTheme extends TextButtonThemeData {
  CustomTextButtonTheme() : super(
    style: TextButton.styleFrom(
      primary: Colors.black,
      textStyle: const TextStyle(
        color: Colors.black,
        fontSize: 16,
        letterSpacing: 0.25,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}
