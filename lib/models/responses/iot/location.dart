import 'package:flutter/material.dart';

import 'package:iot_devices_manager_app/providers/auth.dart';

import 'sensor.dart';

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
