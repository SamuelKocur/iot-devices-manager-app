import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iot_devices_manager_app/models/requests/filter_data.dart';
import 'package:iot_devices_manager_app/models/responses/iot/sensor.dart';
import 'package:iot_devices_manager_app/widgets/common/date_range_dropdown_menu.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../common/date_format.dart';
import '../../../models/app_settings.dart';
import '../../../models/data_filtering.dart';
import '../../../models/responses/filter_data.dart';
import '../../../providers/data_filtering.dart';
import '../../../providers/user.dart';
import '../../../themes/light/drop_down_menu.dart';
import '../../../themes/light/text_theme.dart';
import '../../../widgets/common/error_dialog.dart';

class DataComparisonResultScreen extends StatefulWidget {
  static const routeName = '/data-comparison-result';

  const DataComparisonResultScreen({Key? key}) : super(key: key);

  @override
  State<DataComparisonResultScreen> createState() => _DataComparisonResultScreenState();
}

class _DataComparisonResultScreenState extends State<DataComparisonResultScreen>
    with SingleTickerProviderStateMixin {
  List<Sensor> _sensorsForComparison = [];
  List<bool> _showSensorValues = [];
  late UserAppSettings _userAppSettings;
  String _dateRangeCurrentValue = DateRangeOptions.pastWeek.text;
  DateRange _dateRange = DateRangeOptions.getDateTime(DateRangeOptions.pastWeek.text);
  String _selectedDataType = 'Average';
  final List<String> _dataTypes = [
    'Minimum',
    'Average',
    'Maximum',
  ];
  final List<Color> _colorScheme = [
    Colors.blue,
    const Color.fromRGBO(42, 179, 129, 1),
    Colors.red,
    Colors.orangeAccent,
    Colors.purpleAccent,
  ];
  var _isLoading = false;
  List<FilterComparisonResponse> _comparisonData = [];

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
    List<Widget> result = [];
    for(var i = 0; i< _sensorsForComparison.length; i++) {
      var sensor = _sensorsForComparison[i];
      result.add(_buildCheckbox(
        value: _showSensorValues[i],
        onChanged: (newVal) {
          setState(() {
            _showSensorValues[i] = newVal ?? false;
          });
        },
        label: sensor.name,
        color: _colorScheme[i],
      ));
    }
    return result;
  }

  MarkerSettings _getMarketSettings() {
    return MarkerSettings(
      isVisible: _userAppSettings.graphIncludePoints,
    );
  }

  double _getAnimationDuration() {
    return _userAppSettings.graphAnimate ? 1500 : 0;
  }
  
  List<LineSeries<DataResponse, DateTime>> _getLineSeries() {
    if (_comparisonData.isEmpty) {
      return [];
    }
    List<LineSeries<DataResponse, DateTime>> result = [];
    for(var i = 0; i< _comparisonData.length; i++) {
      var sensorData = _comparisonData[i];
      int sensorIndex = _sensorsForComparison.indexWhere((sensor) => sensor.id == sensorData.sensorId);
      if (_showSensorValues[sensorIndex]) {
        result.add(
            LineSeries<DataResponse, DateTime>(
              animationDuration: _getAnimationDuration(),
              markerSettings: _getMarketSettings(),
              color: _colorScheme[sensorIndex],
              dataSource: sensorData.data,
              xValueMapper: (DataResponse data, _) => data.date,
              yValueMapper: (DataResponse data, _) {
                if (_selectedDataType == 'Minimum') {
                  return data.minValue;
                } else if (_selectedDataType == 'Maximum') {
                  return data.maxValue;
                } else {
                  return data.avgValue;
                }
              },
            )
        );
      }
    }
    return result;
  }

  List<StepLineSeries<DataResponse, DateTime>> _getStepLineSeries() {
    if (_comparisonData.isEmpty) {
      return [];
    }
    List<StepLineSeries<DataResponse, DateTime>> result = [];
    for(var i = 0; i< _comparisonData.length; i++) {
      var sensorData = _comparisonData[i];
      int sensorIndex = _sensorsForComparison.indexWhere((sensor) => sensor.id == sensorData.sensorId);
      if (_showSensorValues[sensorIndex]) {
        result.add(
          StepLineSeries<DataResponse, DateTime>(
            animationDuration: _getAnimationDuration(),
            markerSettings: _getMarketSettings(),
            color: _colorScheme[sensorIndex],
            dataSource: sensorData.data,
            xValueMapper: (DataResponse data, _) => data.date,
            yValueMapper: (DataResponse data, _) => data.totalValue,
          ),
        );
      }
    }
    return result;
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
            '${DateFormatter.date(_dateRange.dateFrom)} - ${DateFormatter.date(_dateRange.dateTo)}',
            style: Theme.of(context).textTheme.headline6,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: SfCartesianChart(
              enableAxisAnimation: false,
              backgroundColor: Colors.white,
              primaryXAxis: DateTimeAxis(
                dateFormat: DateFormat(
                  _comparisonData.isEmpty
                      ? DateFormatter.dateFormat
                      : _comparisonData[0].dateFormat,
                ),
                intervalType: DateTimeIntervalType.auto,
                labelAlignment: LabelAlignment.center,
              ),
              series: _sensorsForComparison[0].isBoolSensor()
                  ? <StepLineSeries<DataResponse, DateTime>>[
                      ..._getStepLineSeries()
                    ]
                  : <LineSeries<DataResponse, DateTime>>[
                      ..._getLineSeries(),
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
        ],
      ),
    );
  }

  void _updateDateRangeValues(
    String newDateRangeCurrentValue, DateRange newDateRange) {
    setState(() {
      _dateRangeCurrentValue = newDateRangeCurrentValue;
      _dateRange = newDateRange;
    });
    _getData();
  }

  List<DropdownMenuItem<String>> _dataTypeDropDownMenu() {
    if (_sensorsForComparison[0].isBoolSensor()) {
      setState(() {
        _selectedDataType = 'Total';
      });
      return [
        const DropdownMenuItem(
          value: 'Total',
          child: Text(
            'Total',
            style: SelectedDropDownItemStyle.data,
          ),
        )
      ];
    }
    return _dataTypes
        .map(
          (type) => _selectedDataType == type
              ? DropdownMenuItem(
                  value: type,
                  child: Text(
                    type,
                    style: SelectedDropDownItemStyle.data,
                  ),
                )
              : DropdownMenuItem(
                  value: type,
                  child: Text(
                    type,
                    style: UnselectedDropDownItemStyle.data,
                  ),
                ),
        )
        .toList();
  }

  Future<void> _getData() async {
    setState(() {
      _isLoading = true;
      _comparisonData = [];
    });
    try {
      FilterComparisonDataRequest request = FilterComparisonDataRequest(
        dateFrom: _dateRange.dateFrom,
        dateTo: _dateRange.dateTo,
        sensorIds: _sensorsForComparison.map((sensor) => sensor.id).toList(),
      );
      var data = await Provider.of<DataFiltering>(context, listen: false)
          .filterDataForComparison(request);
      setState(() {
        _comparisonData = data;
      });
    } catch (error) {
      DialogUtils.showErrorDialog(context,
          'Something went wrong when trying to fetch the data. Please try again later.');
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _userAppSettings = Provider.of<UserData>(context, listen: false).userAppSettings;
  }

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    var sensors = args['sensors'] as Iterable<Sensor>;
    _sensorsForComparison = sensors.toList();
    if (_showSensorValues.isEmpty) {
      _showSensorValues = _sensorsForComparison.map((e) => true).toList();
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Data comparison',
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ElevatedButton(
        onPressed: () => _getData(),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: Text(
            'Compare'.toUpperCase(),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    'Compare Data for: ',
                    style: TextInDetailsScreen.data,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  DateRangeDropDownMenu(
                    dateRangeCurrentValue: _dateRangeCurrentValue,
                    dateRange: _dateRange,
                    onUpdate: _updateDateRangeValues,
                  )
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  const Text(
                    'Data Type: ',
                    style: TextInDetailsScreen.data,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  DropdownButton(
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _selectedDataType = newValue;
                        });
                      }
                    },
                    items: _dataTypeDropDownMenu(),
                    value: _selectedDataType,
                  )
                ],
              ),
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
                    if (_isLoading)
                        Stack(
                        alignment: Alignment.center,
                        children: [
                          _buildGraph(),
                          const CircularProgressIndicator(),
                        ],
                      ),
                   if (!_isLoading)
                      _buildGraph(),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.end,
                      children: _getGraphCheckBoxes(),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
