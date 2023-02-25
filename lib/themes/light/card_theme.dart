import 'package:flutter/material.dart';

class CustomCardThemeTheme {
  static final themeData = CardTheme(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: const BorderSide(
        color: Color.fromRGBO(247, 247, 247, 1),
        width: 2,
      ),
    ),
    color: const Color.fromRGBO(247, 247, 247, 1),
    elevation: 0,
  );
}
