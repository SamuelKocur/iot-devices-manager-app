import 'package:flutter/material.dart';

class CustomElevatedButtonTheme extends ElevatedButtonThemeData {
  CustomElevatedButtonTheme() : super(
    style: ButtonStyle(
      elevation: MaterialStateProperty.all<double>(0),
      backgroundColor: MaterialStateProperty.all<Color>(
        const Color.fromRGBO(42, 179, 129, 1),
      ),
      foregroundColor: MaterialStateProperty.all<Color>(
        Colors.black,
      ),
      alignment: Alignment.center,
      padding: MaterialStateProperty.all<EdgeInsets>(
        const EdgeInsets.symmetric(
          vertical: 12,
        ),
      ),
      textStyle: MaterialStateProperty.all<TextStyle>(
        const TextStyle(
          fontSize: 16,
          letterSpacing: 0.25,
          fontWeight: FontWeight.w600,
        ),
      ),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
    ),
  );
}
