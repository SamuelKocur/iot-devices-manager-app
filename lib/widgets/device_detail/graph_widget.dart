import 'package:flutter/material.dart';
import 'package:iot_devices_manager_app/models/responses/data.dart';
import 'package:iot_devices_manager_app/models/responses/iot.dart';
import 'package:iot_devices_manager_app/providers/iot.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../common/date_format.dart';
import '../../models/data_filtering.dart';

class GraphWidget extends StatefulWidget {
  DateRange dateRange;
  int sensorId;
  List<SensorData> sensorData;

  GraphWidget({
    required this.sensorId,
    required this.sensorData,
    required this.dateRange,
    Key? key,
  }) : super(key: key);

  @override
  State<GraphWidget> createState() => _GraphWidgetState();
}

class _GraphWidgetState extends State<GraphWidget> {
  late Sensor _sensor;
  bool _showAvgValue = true;
  bool _showMinValue = false;
  bool _showMaxValue = false;
  bool _showTotalValue = false;

  Widget _buildCheckbox({
    required bool value,
    required ValueChanged<bool?>? onChanged,
    required String label,
    required Color color,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Checkbox(
          activeColor: color,
          side: BorderSide(
            color: color,
            width: 2,
          ),
          value: value,
          onChanged: onChanged,
        ),
        Text(label),
      ],
    );
  }

  List<Widget> _getGraphCheckBoxes() {
    return _sensor.isBoolSensor()
        ? [
            _buildCheckbox(
              value: _showTotalValue,
              onChanged: (newVal) {
                setState(() {
                  _showTotalValue = newVal ?? false;
                });
              },
              label: 'Total Value',
              color: Theme.of(context).colorScheme.primary,
            ),
          ]
        : [
            _buildCheckbox(
              value: _showMinValue,
              onChanged: (newVal) {
                setState(() {
                  _showMinValue = newVal ?? false;
                });
              },
              label: 'Minimum',
              color: Colors.blue,
            ),
            _buildCheckbox(
              value: _showAvgValue,
              onChanged: (newVal) {
                setState(() {
                  _showAvgValue = newVal ?? false;
                });
              },
              label: 'Average',
              color: Theme.of(context).colorScheme.primary,
            ),
            _buildCheckbox(
              value: _showMaxValue,
              onChanged: (newVal) {
                setState(() {
                  _showMaxValue = newVal ?? false;
                });
              },
              label: 'Maximum   ',
              color: Colors.red,
            ),
          ];
  }

  Widget _buildGraph() {
    return Card(
      margin: const EdgeInsets.all(10),
      color: Colors.white,
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Text(
            '${DateFormatter.date(widget.dateRange.dateFrom)} - ${DateFormatter.date(widget.dateRange.dateTo)}',
            style: Theme.of(context).textTheme.headline6,
          ),
          SfCartesianChart(
            enableAxisAnimation: false,
            backgroundColor: Colors.white,
            primaryXAxis: CategoryAxis(),
            series: <LineSeries<SensorData, String>>[
              if (_showMinValue == true)
                LineSeries<SensorData, String>(
                  color: Colors.blue,
                  dataSource: dummyData,
                  xValueMapper: (SensorData data, _) =>
                      DateFormatter.graphDate(data.date),
                  yValueMapper: (SensorData data, _) => data.minValue,
                ),
              if (_showAvgValue == true)
                LineSeries<SensorData, String>(
                  color: Theme.of(context).colorScheme.primary,
                  dataSource: dummyData,
                  xValueMapper: (SensorData data, _) =>
                      DateFormatter.graphDate(data.date),
                  yValueMapper: (SensorData data, _) => data.avgValue,
                ),
              if (_showMaxValue == true)
                LineSeries<SensorData, String>(
                  color: Colors.red,
                  dataSource: dummyData,
                  xValueMapper: (SensorData data, _) =>
                      DateFormatter.graphDate(data.date),
                  yValueMapper: (SensorData data, _) => data.maxValue,
                ),
              if (_showTotalValue == true)
                LineSeries<SensorData, String>(
                  color: Theme.of(context).colorScheme.primary,
                  dataSource: dummyData,
                  xValueMapper: (SensorData data, _) =>
                      DateFormatter.graphDate(data.date),
                  yValueMapper: (SensorData data, _) => data.totalValue,
                ),
            ],
            trackballBehavior: TrackballBehavior(
              enable: true,
              tooltipSettings: const InteractiveTooltip(
                enable: true,
                format: 'point.x: point.y',
              ),
              lineType: TrackballLineType.horizontal,
            ),
            zoomPanBehavior: ZoomPanBehavior(
              enablePinching: true,
              enableDoubleTapZooming: true,
              // enableSelectionZooming: true,
              maximumZoomLevel: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final devices = Provider.of<IoTDevices>(context, listen: false);
    _sensor = devices.getSensorById(widget.sensorId);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 5,
        ),
        Card(
          color: Theme.of(context).colorScheme.background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              _buildGraph(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: _getGraphCheckBoxes(),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
