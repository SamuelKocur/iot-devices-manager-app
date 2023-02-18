import 'package:flutter/material.dart';

import 'auth.dart';

class Devices with ChangeNotifier {
  static const recipesUrl = '$baseUrl/recipes/';
  Map<String, String> requestHeaders;

  Devices(this.requestHeaders);

  void update(Map<String, String> paRequestHeaders) {
    requestHeaders = paRequestHeaders;
  }
}
