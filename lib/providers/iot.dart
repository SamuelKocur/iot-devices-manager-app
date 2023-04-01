import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/responses/iot/sensor.dart';
import 'user.dart';

class IoTDevicesData with ChangeNotifier {
  static const sensorsUrl = '$baseApiUrl/sensors';
  Map<String, String> requestHeaders;
  List<Sensor> _cachedSensors = [];
  List<Sensor> _favoriteSensors = [];
  List<Sensor> _filteredSensors = [];

  IoTDevicesData(this.requestHeaders);

  void update(Map<String, String> paRequestHeaders) {
    requestHeaders = paRequestHeaders;
  }

  List<Sensor> get sensors {
    return [..._cachedSensors];
  }

  List<Sensor> get favoriteSensors {
    return _cachedSensors.where((sensor) => sensor.isFavorite).toList();
  }

  List<Sensor> get filteredSensors {
    return [..._filteredSensors];
  }

  Sensor getSensorById(int sensorId) {
    return _cachedSensors.firstWhere((sensor) => sensor.id == sensorId);
  }

  List<Sensor> getListOfSensorsById(List<int> sensorIds) {
    return _cachedSensors
        .where((sensor) => sensorIds.contains(sensor.id))
        .toList();
  }

  Future<Sensor?> getAndReloadSensorById(int sensorId) async {
    final url = Uri.parse('$sensorsUrl/$sensorId/');
    try {
      final response = await http.get(url, headers: requestHeaders);
      final responseData = (jsonDecode(response.body) ?? <String, dynamic>{})
          as Map<String, dynamic>;
      if (response.statusCode == 200) {
        final Sensor loadedSensor = Sensor.fromJson(responseData);
        Sensor cachedSensor = getSensorById(sensorId);
        if (cachedSensor.update(loadedSensor)) {
          notifyListeners();
        }
        return cachedSensor;
      } else {
        return null;
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> fetchAndSetIoTDevices({String? type}) async {
    final queryParameters = {'type': type};
    final url = Uri.parse('$sensorsUrl/').replace(queryParameters: queryParameters);
    try {
      final response = await http.get(url, headers: requestHeaders);
      final responseData = (jsonDecode(response.body) ?? <String, dynamic>{}) as Map<String, dynamic>;
      if (response.statusCode == 200) {
        final List<Sensor> loadedSensors = List<Sensor>.from(responseData["sensors"].map((sensor) => Sensor.fromJson(sensor)));
        if (type != null) {
          _filteredSensors = loadedSensors;
        } else {
          _cachedSensors = loadedSensors;
        }
      }
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  /// Not used, as we filter favorites from cached sensors
  Future<void> fetchAndSetFavoriteIoTDevices() async {
    final url = Uri.parse('$sensorsUrl/favorites/');
    try {
      final response = await http.get(url, headers: requestHeaders);
      final responseData = (jsonDecode(response.body) ?? <String, dynamic>{}) as Map<String, dynamic>;
      if (response.statusCode == 200) {
        final List<Sensor> loadedSensors = List<Sensor>.from(responseData["sensors"].map((sensor) => Sensor.fromJson(sensor)));
        _favoriteSensors = loadedSensors;
        notifyListeners();
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> toggleFavoriteSensors(int sensorId) async {
    _toggleInAllLists(sensorId);
    notifyListeners();

    final url = Uri.parse('$sensorsUrl/$sensorId/toggle-favorite/');
    try {
      final response = await http.post(url, headers: requestHeaders);
      if (response.statusCode != 201 && response.statusCode != 204) {
        _toggleInAllLists(sensorId);
        notifyListeners();
        return false;
      }
    } catch (error) {
      return false;
    }
    return true;
  }

  Future<void> setSensorCustomName(int sensorId, String customName) async {
    final queryParameters = {'name': customName};
    final url = Uri.parse('$sensorsUrl/$sensorId/user-customization').replace(queryParameters: queryParameters);
    try {
      final response = await http.post(url, headers: requestHeaders);
      if (response.statusCode <= 200 && response.statusCode < 300) {
        Sensor sensor = getSensorById(sensorId);
        sensor.setCustomName(customName);
        notifyListeners();
      }
    } catch (error) {
      rethrow;
    }
  }

  void _toggleInAllLists(int sensorId) {
    _cachedSensors.firstWhereOrNull((element) => element.id == sensorId)?.toggleFavorite();
    _filteredSensors.firstWhereOrNull((element) => element.id == sensorId)?.toggleFavorite();
  }
}
