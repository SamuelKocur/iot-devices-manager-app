import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iot_devices_manager_app/providers/iot.dart';

import '../models/responses/iot.dart';
import 'auth.dart';

class Locations with ChangeNotifier {
  static const locationsUrl = '$baseUrl/locations';
  final IoTDevices ioTDevicesProvider;

  Map<String, String> requestHeaders;
  List<Location> _locations = [];
  late LocationDetail _locationDetail;

  Locations(this.requestHeaders, this.ioTDevicesProvider);

  void update(Map<String, String> paRequestHeaders) {
    requestHeaders = paRequestHeaders;
  }

  List<Location> get locations {
    return [..._locations];
  }

  LocationDetail get locationDetail {
    return _locationDetail;
  }

  Future<void> fetchAndSetLocations() async {
    final url = Uri.parse('$locationsUrl/');
    try {
      final response = await http.get(url, headers: requestHeaders);
      final responseData = (jsonDecode(response.body) ?? <String, dynamic>{})  as Map<String, dynamic>;
      if (response.statusCode == 200) {
        final List<Location> loadedLocations = List<Location>.from(responseData["locations"].map((location) => Location.fromJson(location)));
        _locations = loadedLocations;
        notifyListeners();
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> getLocationById(int locationId) async {
    final url = Uri.parse('$locationsUrl/$locationId/');
    try {
      final response = await http.get(url, headers: requestHeaders);
      final responseData = (jsonDecode(response.body) ?? <String, dynamic>{})  as Map<String, dynamic>;
      if (response.statusCode == 200) {
        LocationDetail locationDetail = LocationDetail.fromJson(responseData);
        locationDetail.sensors = ioTDevicesProvider.getListOfSensorsById(locationDetail.sensors.map((sensor) => sensor.id).toList());
        _locationDetail = locationDetail;
        notifyListeners();
      }
    } catch (error) {
      rethrow;
    }
  }
}
