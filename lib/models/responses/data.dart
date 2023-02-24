class SensorData {
  double sensorId;
  DateTime date;
  double? avgValue;
  double? minValue;
  double? maxValue;
  double? totalValue;

  SensorData({
    required this.sensorId,
    required this.date,
    this.avgValue,
    this.minValue,
    this.maxValue,
    this.totalValue,
  });

  factory SensorData.fromJson(Map<String, dynamic> json) => SensorData(
    sensorId: json['sensorId'],
    date: DateTime.parse(json['date']),
    avgValue: json['avgValue'],
    minValue: json['latest_value'],
    maxValue: json['latest_value'],
    totalValue: json['latest_value'],
  );
}

final dummyData = [
  SensorData(
    sensorId: 4,
    date: DateTime.now().subtract(const Duration(days: 7)),
    avgValue: 15,
    minValue: 6,
    maxValue: 20,
  ),
  SensorData(
    sensorId: 4,
    date: DateTime.now().subtract(const Duration(days: 6)),
    avgValue: 13,
    minValue: 4,
    maxValue: 15,
  ),
  SensorData(
    sensorId: 4,
    date: DateTime.now().subtract(const Duration(days: 5)),
    avgValue: 16,
    minValue: 5,
    maxValue: 22,
  ),
  SensorData(
    sensorId: 4,
    date: DateTime.now().subtract(const Duration(days: 4)),
    avgValue: 10,
    minValue: 2,
    maxValue: 14,
  ),
  SensorData(
    sensorId: 4,
    date: DateTime.now().subtract(const Duration(days: 3)),
    avgValue: 9,
    minValue: 3,
    maxValue: 11,
  ),
  SensorData(
    sensorId: 4,
    date: DateTime.now().subtract(const Duration(days: 2)),
    avgValue: 12,
    minValue: 8,
    maxValue: 18,
  ),
  SensorData(
    sensorId: 4,
    date: DateTime.now().subtract(const Duration(days: 1)),
    avgValue: 13,
    minValue: 5,
    maxValue: 18,
  ),
  SensorData(
    sensorId: 4,
    date: DateTime.now(),
    avgValue: 10,
    minValue: 3,
    maxValue: 13,
  ),
];
