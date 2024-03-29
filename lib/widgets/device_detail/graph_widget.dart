import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iot_devices_manager_app/models/app_settings.dart';
import 'package:iot_devices_manager_app/models/responses/filter_data.dart';
import 'package:iot_devices_manager_app/providers/iot.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../common/date_format.dart';
import '../../models/data_filtering.dart';
import '../../models/responses/iot/sensor.dart';
import '../../providers/user.dart';

class GraphWidget extends StatefulWidget {
  DateRange dateRange;
  int sensorId;
  bool showData;

  GraphWidget({
    required this.sensorId,
    required this.dateRange,
    this.showData =  true,
    Key? key,
  }) : super(key: key);

  @override
  State<GraphWidget> createState() => _GraphWidgetState();
}

class _GraphWidgetState extends State<GraphWidget> {
  late Sensor _sensor;
  late UserAppSettings _userAppSettings;
  bool _showAvgValue = true;
  bool _showMinValue = false;
  bool _showMaxValue = false;

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
        value: true,
        onChanged: null,
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

  MarkerSettings _getMarketSettings() {
    return MarkerSettings(
      isVisible: _userAppSettings.graphIncludePoints,
    );
  }

  double _getAnimationDuration() {
    return _userAppSettings.graphAnimate ? 1500 : 0;
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
          Consumer<FilterResponse>(
            builder: (ctx, filterResponse, _) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: SfCartesianChart(
                enableAxisAnimation: false,
                backgroundColor: Colors.white,
                primaryXAxis: DateTimeAxis(
                  dateFormat: DateFormat(filterResponse.dateFormat),
                  intervalType: DateTimeIntervalType.auto,
                  labelAlignment: LabelAlignment.center,
                ),
                series:  _sensor.isBoolSensor() ?
                <StepLineSeries<DataResponse, DateTime>> [
                  StepLineSeries<DataResponse, DateTime>(
                    animationDuration: _getAnimationDuration(),
                    markerSettings: _getMarketSettings(),
                    color: Theme.of(context).colorScheme.primary,
                    dataSource: filterResponse.filterJustSelected(widget.showData),
                    xValueMapper: (DataResponse data, _) => data.date,
                    yValueMapper: (DataResponse data, _) => data.totalValue,
                  ),
                ]
                    : <LineSeries<DataResponse, DateTime>>[
                  if (_showMinValue == true)
                    LineSeries<DataResponse, DateTime>(
                      animationDuration: _getAnimationDuration(),
                      markerSettings: _getMarketSettings(),
                      color: Colors.blue,
                      dataSource: filterResponse.filterJustSelected(widget.showData),
                      xValueMapper: (DataResponse data, _) => data.date,
                      yValueMapper: (DataResponse data, _) => data.minValue,
                    ),
                  if (_showAvgValue == true)
                    LineSeries<DataResponse, DateTime>(
                      animationDuration: _getAnimationDuration(),
                      markerSettings: _getMarketSettings(),
                      color: Theme.of(context).colorScheme.primary,
                      dataSource: filterResponse.filterJustSelected(widget.showData),
                      xValueMapper: (DataResponse data, _) => data.date,
                      yValueMapper: (DataResponse data, _) => data.avgValue,
                    ),
                  if (_showMaxValue == true)
                    LineSeries<DataResponse, DateTime>(
                      animationDuration: _getAnimationDuration(),
                      markerSettings: _getMarketSettings(),
                      color: Colors.red,
                      dataSource: filterResponse.filterJustSelected(widget.showData),
                      xValueMapper: (DataResponse data, _) => data.date,
                      yValueMapper: (DataResponse data, _) => data.maxValue,
                    )
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
                  maximumZoomLevel: 0.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _userAppSettings = Provider.of<UserData>(context, listen: false).userAppSettings;
    _showMinValue = _userAppSettings.graphShowMin;
    _showAvgValue = _userAppSettings.graphShowAvg;
    _showMaxValue = _userAppSettings.graphShowMax;
  }

  @override
  Widget build(BuildContext context) {
    final devices = Provider.of<IoTDevicesData>(context, listen: false);
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
