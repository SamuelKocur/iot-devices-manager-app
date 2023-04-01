import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iot_devices_manager_app/providers/iot.dart';

import '../models/responses/iot/location.dart';
import 'user.dart';

class LocationsData with ChangeNotifier {
  static const locationsUrl = '$baseApiUrl/locations';
  final IoTDevicesData ioTDevicesProvider;
  Map<String, String> requestHeaders;
  List<Location> _locations = [];

  LocationsData(this.requestHeaders, this.ioTDevicesProvider);

  void update(Map<String, String> paRequestHeaders) {
    requestHeaders = paRequestHeaders;
  }

  List<Location> get locations {
    return [..._locations];
  }

  Location getLocationById(int locationId) {
    return _locations.firstWhere((location) => location.id == locationId);
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

  Future<LocationDetail?> getAndReloadLocationDetailById(int locationId) async {
    final url = Uri.parse('$locationsUrl/$locationId/');
    try {
      final response = await http.get(url, headers: requestHeaders);
      final responseData = (jsonDecode(response.body) ?? <String, dynamic>{})  as Map<String, dynamic>;
      if (response.statusCode == 200) {
        LocationDetail loadedLocationDetail = LocationDetail.fromJson(responseData);
        loadedLocationDetail.sensors = ioTDevicesProvider.getListOfSensorsById(
            loadedLocationDetail.sensors.map((sensor) => sensor.id).toList()
        );
        Location cachedLocation = getLocationById(locationId);
        if (cachedLocation.update(loadedLocationDetail.location)) {
          notifyListeners();
        }
        loadedLocationDetail.location = cachedLocation;
        setSensorsLocation(loadedLocationDetail);
        return loadedLocationDetail;
      }
    } catch (error) {
      rethrow;
    }
    return null;
  }

  Future<void> setLocationCustomName(int locationId, String customName) async {
    final queryParameters = {'name': customName};
    final url = Uri.parse('$locationsUrl/$locationId/user-customization').replace(queryParameters: queryParameters);
    try {
      final response = await http.post(url, headers: requestHeaders);
      if (response.statusCode <= 200 && response.statusCode < 300) {
        Location location = getLocationById(locationId);
        location.setCustomName(customName);
        notifyListeners();
      }
    } catch (error) {
      rethrow;
    }
  }

  void setSensorsLocation(LocationDetail locationDetail) {
    Location location = locationDetail.location;
    for (var sensor in locationDetail.sensors) {
      sensor.setLocation(location);
    }
  }
}
