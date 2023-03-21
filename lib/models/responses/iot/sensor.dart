import 'package:flutter/material.dart';
import 'package:iot_devices_manager_app/common/date_format.dart';

import 'device.dart';
import 'location.dart';


class Sensor with ChangeNotifier {
  final int id;
  final String order;
  String name;
  String? customName;
  final String type;
  String? unit;
  DateTime? dateCreated;
  DateTime? dateUpdated;
  bool isFavorite;
  LatestValue latestValue;
  final Device device;

  Sensor({
    required this.id,
    required this.order,
    required this.name,
    this.customName,
    required this.type,
    this.unit,
    this.dateCreated,
    this.dateUpdated,
    required this.isFavorite,
    required this.latestValue,
    required this.device,
  });

  factory Sensor.fromJson(Map<String, dynamic> json) => Sensor(
    id: json['id'],
    order: json['order'],
    name: json['name'],
    customName: json['custom_name'],
    type: json['type'],
    unit: json['unit'],
    dateCreated: DateTime.parse(json['date_created']),
    dateUpdated: DateTime.parse(json['date_updated']),
    isFavorite: json['is_favorite'] ?? false,
    latestValue: json['latest_value'] != null
        ? LatestValue.fromJson(json['latest_value'])
        : LatestValue(value: 0, timestamp: DateTime.now()),
    device: Device.fromJson(json['device']),
  );

  bool update(Sensor loadedSensor) {
    bool hasChanged = false;
    if (latestValue.value != loadedSensor.latestValue.value) {
      latestValue.value = loadedSensor.latestValue.value;
      hasChanged = true;
    }
    if (latestValue.timestamp != loadedSensor.latestValue.timestamp) {
      latestValue.timestamp = loadedSensor.latestValue.timestamp;
      hasChanged = true;
    }
    if (isFavorite != loadedSensor.isFavorite) {
      isFavorite = loadedSensor.isFavorite;
      hasChanged = true;
    }
    if (name != loadedSensor.name) {
      name = loadedSensor.name;
      hasChanged = true;
    }
    if (customName != loadedSensor.customName) {
      customName = loadedSensor.customName;
      hasChanged = true;
    }
    if (dateUpdated != loadedSensor.dateUpdated) {
      dateUpdated = loadedSensor.dateUpdated;
      hasChanged = true;
    }
    return hasChanged;
  }

  void toggleFavorite() {
    isFavorite = !isFavorite;
    notifyListeners();
  }

  String getFormattedDate() {
    String formattedDate = latestValue.getFormattedTimestamp();
    return formattedDate;
  }

  String getFormattedLatestValue() {
    if (isBoolSensor()) {
      return getFormattedDate();
    }
    return "${latestValue.value} ${unit?.replaceAll('Â', '') ?? ""}";
  }

  void setCustomName(String newCustomName) {
    if (newCustomName.isEmpty) {
      customName = newCustomName;
    } else {
      customName = newCustomName;
    }
    notifyListeners();
  }

  void setLocation(Location newLocation) {
    device.location = newLocation;
    notifyListeners();
  }

  String getCustomNameOrName() {
    return customName ?? name;
  }

  String getUnit() {
    if (isBoolSensor()) {
      return "";
    }
    return unit?.replaceAll('Â', '') ?? "";
  }

  bool isBoolSensor() {
    return unit == 'bool';
  }
}

class LatestValue {
  double value;
  DateTime timestamp;

  LatestValue({
    required this.value,
    required this.timestamp,
  });

  factory LatestValue.fromJson(Map<String, dynamic> json) => LatestValue(
    value: json['value'],
    timestamp: DateTime.parse(json['timestamp']),
  );

  String getFormattedTimestamp() {
    return DateFormatter.dateTime(timestamp);
  }
}
