import 'package:flutter/material.dart';

class CustomInputDecorationTheme {
  static final themeData = InputDecorationTheme(
    filled: true,
    fillColor: const Color.fromRGBO(245, 245, 245, 1),
    contentPadding: const EdgeInsets.all(8),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide.none,
    ),
  );
}
