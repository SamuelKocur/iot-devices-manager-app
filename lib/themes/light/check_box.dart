import 'package:flutter/material.dart';

class CustomCheckBoxTheme {
  static final themeData = CheckboxThemeData(
    fillColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
        if (states.contains(MaterialState.selected)) {
          return const Color.fromRGBO(42, 179, 129, 1);
        }
        return Colors.grey;
      },
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(3),
    ),
  );
}
