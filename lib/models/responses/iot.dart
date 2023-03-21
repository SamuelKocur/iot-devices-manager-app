import 'package:flutter/material.dart';
import 'package:iot_devices_manager_app/common/date_format.dart';

import 'package:iot_devices_manager_app/providers/auth.dart';


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

class Device {
  final String mac;
  Location location;
  String? status;
  DateTime? dateUpdated;
  DateTime? dateCreated;
  String? name;

  Device({
    required this.mac,
    required this.location,
    this.status,
    this.dateUpdated,
    this.dateCreated,
    this.name,
  });

  factory Device.fromJson(Map<String, dynamic> json) => Device(
    mac: json['mac'],
    location: Location.fromJson(json['location']),
    status: json['status'],
    dateUpdated: DateTime.parse(json['date_updated']),
    dateCreated: DateTime.parse(json['date_created']),
    name: json['name'],
  );
}

class Location with ChangeNotifier {
  final int id;
  final String building;
  final String floor;
  final String room;
  String name;
  String? customName;
  String? image;
  int? numberOfDevices;

  Location({
    required this.id,
    required this.building,
    required this.floor,
    required this.room,
    required this.name,
    this.customName,
    this.image,
    this.numberOfDevices,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    id: json['id'],
    building: json['building'],
    floor: json['floor'],
    room: json['room'],
    name: json['name'],
    customName: json['custom_name'],
    image: json['image'] != null ? '$imageUrl${json["image"]}' : null,
    numberOfDevices: json['number_of_devices'],
  );

  bool update(Location newLocation) {
    bool hasChanged = false;
    if (name != newLocation.name) {
      name = newLocation.name;
      hasChanged = true;
    }
    if (customName != newLocation.customName) {
      customName = newLocation.customName;
      hasChanged = true;
    }
    if (image != newLocation.image) {
      image = newLocation.image;
      hasChanged = true;
    }
    if (numberOfDevices != newLocation.numberOfDevices) {
      numberOfDevices = newLocation.numberOfDevices;
      hasChanged = true;
    }
    return hasChanged;
  }

  void setCustomName(String newName) {
    if (name.isEmpty) {
      customName = name;
    } else {
      customName = newName;
    }
    notifyListeners();
  }

  String getCustomNameOrName() {
    return customName ?? name;
  }

  String getNumberOfDevices() {
    if (numberOfDevices == 1) {
      return '$numberOfDevices device';
    }
    return '$numberOfDevices devices';
  }
}

class LocationDetail {
  Location location;
  List<Sensor> sensors;

  LocationDetail({
    required this.sensors,
    required this.location,
  });

  factory LocationDetail.fromJson(Map<String, dynamic> json) => LocationDetail(
    location: Location.fromJson(json['location']),
    sensors: List<Sensor>.from(json["sensors"].map((x) => Sensor.fromJson(x)))
  );
}
