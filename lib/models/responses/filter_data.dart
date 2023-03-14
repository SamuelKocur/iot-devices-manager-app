import 'package:flutter/cupertino.dart';

class FilterResponse with ChangeNotifier {
  String dateFormat;
  List<DataResponse> data = [];
  bool _rebuild = false;

  FilterResponse({
    required this.dateFormat,
    required this.data,
  });

  factory FilterResponse.fromJson(Map<String, dynamic> json) => FilterResponse(
      dateFormat: json['date_format'],
      data: List<DataResponse>.from(json["data"].map((data) => DataResponse.fromJson(data)))
  );

  List<DataResponse> filterJustSelected() {
    return data.where((element) => element.selected).toList();
  }

  void toggleRebuild() {
    _rebuild = !_rebuild;
    notifyListeners();
  }
}

class DataResponse with ChangeNotifier {
  int sensorId;
  DateTime date;
  double? avgValue;
  double? minValue;
  double? maxValue;
  double? totalValue;
  bool selected = true;

  DataResponse({
    required this.sensorId,
    required this.date,
    this.avgValue,
    this.minValue,
    this.maxValue,
    this.totalValue,
  });

  set setSelected(bool selected) {
    this.selected = selected;
    notifyListeners();
  }

  factory DataResponse.fromJson(Map<String, dynamic> json) => DataResponse(
    sensorId: json['sensor_id'],
    date: DateTime.parse(json['date']),
    avgValue: double.parse(json['avg_value']),
    minValue: double.parse(json['min_value']),
    maxValue: double.parse(json['max_value']),
    totalValue: double.parse(json['total_value']),
  );
}
