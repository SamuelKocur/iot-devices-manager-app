import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iot_devices_manager_app/common/date_format.dart';
import 'package:iot_devices_manager_app/models/requests/filter_data.dart';
import 'package:iot_devices_manager_app/models/responses/filter_data.dart';

import 'auth.dart';

class DataWarehouse with ChangeNotifier {
  static const dataWarehouseUrl = '$baseApiUrl/data-warehouse';
  Map<String, String> requestHeaders;

  DataWarehouse(this.requestHeaders);

  void update(Map<String, String> paRequestHeaders) {
    requestHeaders = paRequestHeaders;
  }

  Future<FilterResponse> filterData(FilterDataRequest request, FilterResponse filterProvider) async {
    final url = Uri.parse('$dataWarehouseUrl/filter/');
    try {
      final response = await http.post(
        url,
        headers: requestHeaders,
        body: json.encode(request.toJson()),
      );
      final responseData = (jsonDecode(response.body) ?? <String, dynamic>{}) as Map<String, dynamic>;
      if (response.statusCode == 200) {
        final FilterResponse filterResponse = FilterResponse.fromJson(responseData);
        filterProvider
          ..dateFormat = filterResponse.dateFormat
          ..data = filterResponse.data;
        notifyListeners();
        return filterProvider;
      } else {
        return FilterResponse(dateFormat: DateFormatter.dateGraphFormat, data: []);
      }
    } catch (error) {
      rethrow;
    }
  }
}
