class FilterDataRequest {
  int sensorId;
  DateTime dateFrom;
  DateTime dateTo;

  FilterDataRequest({
    required this.sensorId,
    required this.dateFrom,
    required this.dateTo
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sensor_id'] = sensorId;
    data['date_from'] = dateFrom.toString();
    data['date_to'] = dateTo.toString();
    return data;
  }
}
