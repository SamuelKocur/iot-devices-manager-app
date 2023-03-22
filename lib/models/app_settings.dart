import 'package:flutter/cupertino.dart';
import 'package:iot_devices_manager_app/models/data_filtering.dart';

class UserAppSettings with ChangeNotifier {
  String dateFormat;
  String getDataFor;
  bool graphAnimate;
  bool graphIncludePoints;
  bool graphShowAvg;
  bool graphShowMin;
  bool graphShowMax;

  UserAppSettings({
    this.dateFormat = 'dd-MM-yyyy H:mm',
    this.getDataFor = 'Past Week',
    this.graphAnimate = true,
    this.graphIncludePoints = false,
    this.graphShowAvg = true,
    this.graphShowMin = false,
    this.graphShowMax = false,
  });

  factory UserAppSettings.fromJson(Map<String, dynamic> json) => UserAppSettings(
    dateFormat: json['date_format'],
    getDataFor: json['get_data_for'],
    graphAnimate: json['graph_animate'],
    graphIncludePoints: json['graph_include_points'],
    graphShowAvg: json['graph_show_avg'],
    graphShowMin: json['graph_show_min'],
    graphShowMax: json['graph_show_max'],
  );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date_format'] = dateFormat;
    if (DateRangeOptions.values.map((e) => e.text).contains(getDataFor)) {
      data['get_data_for'] = getDataFor;
    } else {
      data['get_data_for'] = DateRangeOptions.pastWeek.text;
    }
    data['graph_animate'] = graphAnimate;
    data['graph_include_points'] = graphIncludePoints;
    data['graph_show_avg'] = graphShowAvg;
    data['graph_show_min'] = graphShowMin;
    data['graph_show_max'] = graphShowMax;
    return data;
  }

  void update(UserAppSettings newSettings) {
    dateFormat = newSettings.dateFormat;
    getDataFor = newSettings.getDataFor;
    graphAnimate = newSettings.graphAnimate;
    graphIncludePoints = newSettings.graphIncludePoints;
    graphShowAvg = newSettings.graphShowAvg;
    graphShowMin = newSettings.graphShowMin;
    graphShowMax = newSettings.graphShowMax;
    notifyListeners();
  }

  DateRangeOptions get dateRangeOption {
    return DateRangeOptions.getDateRangeOptionByText(getDataFor);
  }
}
