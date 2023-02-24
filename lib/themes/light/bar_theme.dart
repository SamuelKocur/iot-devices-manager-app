import 'package:flutter/material.dart';

class CustomAppBarTheme {
  static const themeData = AppBarTheme(
    backgroundColor: Colors.white,
    foregroundColor: Colors.black,
    elevation: 0.5,
    titleTextStyle: TextStyle(
      color: Colors.black,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    )
  );
}

class CustomTabBarTheme {
  static const themeData = TabBarTheme(
    labelColor: Colors.black,
    labelStyle: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    ),
    unselectedLabelColor: Colors.grey,
    indicator: UnderlineTabIndicator(
      borderSide: BorderSide(color: Colors.black),
    ),
    indicatorSize: TabBarIndicatorSize.tab,
    labelPadding: EdgeInsets.all(5),
  );
}
