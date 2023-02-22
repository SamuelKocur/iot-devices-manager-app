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

class SelectedTagTheme extends ElevatedButtonThemeData {
  SelectedTagTheme() : super(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(
        const Color.fromRGBO(42, 179, 129, 1),
      ),
      padding: MaterialStateProperty.all<EdgeInsets>(
        const EdgeInsets.symmetric(
          vertical: 0,
        ),
      ),
      textStyle: MaterialStateProperty.all<TextStyle>(
        const TextStyle(
          fontSize: 14,
          letterSpacing: 0.25,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );
}

class UnselectedTagTheme extends ElevatedButtonThemeData {
  UnselectedTagTheme() : super(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(
        const Color.fromRGBO(42, 179, 129, 0.2),
      ),
      padding: MaterialStateProperty.all<EdgeInsets>(
        const EdgeInsets.symmetric(
          vertical: 0,
        ),
      ),
      textStyle: MaterialStateProperty.all<TextStyle>(
        const TextStyle(
          fontSize: 14,
          letterSpacing: 0.25,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
  );
}

class WhiteButtonTheme extends ElevatedButtonThemeData {
  WhiteButtonTheme() : super(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(
        const Color.fromRGBO(255, 255, 255, 1),
      ),
      padding: MaterialStateProperty.all<EdgeInsets>(
        const EdgeInsets.symmetric(
          vertical: 0,
        ),
      ),
      textStyle: MaterialStateProperty.all<TextStyle>(
        const TextStyle(
          fontSize: 16,
          letterSpacing: 0.25,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
  );
}
