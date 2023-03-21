import 'location.dart';

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
