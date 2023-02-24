import 'package:flutter/material.dart';
import 'package:iot_devices_manager_app/models/responses/data.dart';
import 'package:iot_devices_manager_app/themes/light/drop_down_menu.dart';
import 'package:iot_devices_manager_app/widgets/device_detail/graph_widget.dart';
import 'package:provider/provider.dart';

import '../../models/data_filtering.dart';
import '../../providers/iot.dart';
import '../../themes/light/text_theme.dart';
import '../common/error_dialog.dart';

class FilterDataWidget extends StatefulWidget {
  int sensorId;

  FilterDataWidget(this.sensorId, {Key? key}) : super(key: key);

  @override
  State<FilterDataWidget> createState() => _FilterDataWidgetState();
}

class _FilterDataWidgetState extends State<FilterDataWidget> {
  String _dataRangeCurrentValue = DateRangeOptions.pastWeek.text;
  DateRange _dateRange =
      DateRangeOptions.getDateTime(DateRangeOptions.pastWeek.text);
  List<SensorData> sensorData = [];

  Future<void> _getSensorData(BuildContext context) async {
    try {
      await Provider.of<IoTDevices>(context, listen: false)
          .fetchAndSetFavoriteIoTDevices();
    } catch (error) {
      DialogUtils.showErrorDialog(
          context, 'Something went wrong. Please try again later.');
    }
  }

  List<PopupMenuItem<String>> _dataRangePopupMenu() {
    return DateRangeOptions.values
        .map(
          (e) => _dataRangeCurrentValue == e.text
              ? PopupMenuItem(
                  value: e.text,
                  child: Text(
                    e.text,
                    style: SelectedDropDownItemStyle.data,
                  ),
                )
              : PopupMenuItem(
                  value: e.text,
                  child: Text(
                    e.text,
                    style: UnselectedDropDownItemStyle.data,
                  ),
                ),
        )
        .toList();
  }

  void _setDateRange(String newDateRangeOption, BuildContext context) {
    if (newDateRangeOption == DateRangeOptions.dataRange.text) {
      _displayDayPicker(newDateRangeOption, context);
      return;
    }
    DateRange dateRange = DateRangeOptions.getDateTime(newDateRangeOption);

    setState(() {
      _dataRangeCurrentValue = newDateRangeOption;
      _dateRange = dateRange;
    });
  }

  void _displayDayPicker(String newDateRangeOption, BuildContext context) {
    showDateRangePicker(
      builder: (ctx, child) {
        return Theme(
          data: ThemeData.light().copyWith(
              colorScheme: const ColorScheme.light().copyWith(
                primary: const Color.fromRGBO(42, 179, 129, 1),
              ),
              appBarTheme: AppBarTheme(
                color: Theme.of(context).colorScheme.primary,
              )),
          child: child!,
        );
      },
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    ).then((DateTimeRange? value) {
      if (value != null) {
        DateTime now = DateTime.now();
        DateTimeRange fromRange = DateTimeRange(
          start: now.subtract(const Duration(days: 7)),
          end: now,
        );
        fromRange = value;
        setState(() {
          _dataRangeCurrentValue = newDateRangeOption;
          _dateRange = DateRange(fromRange.start, fromRange.end);
        });
      }
    });
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Text(
              'Display data for: ',
              style: TextInDetailsScreen.data,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              _dataRangeCurrentValue,
              style: Theme.of(context).textTheme.headline5,
            ),
            PopupMenuButton(
              onSelected: (String? newValue) {
                if (newValue != null) {
                  _setDateRange(newValue, context);
                }
              },
              itemBuilder: (ctx) => _dataRangePopupMenu(),
              child: const Padding(
                padding: EdgeInsets.only(left: 10),
                child: Icon(
                  Icons.arrow_drop_down_outlined,
                ),
              ),
            )
          ],
        ),
        FutureBuilder(
          future: _getSensorData(context),
          builder: (ctx, snapshot) =>
              snapshot.connectionState == ConnectionState.waiting
                  ? Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          GraphWidget(
                            sensorId: widget.sensorId,
                            dateRange: _dateRange,
                            sensorData: const [],
                          ),
                          const CircularProgressIndicator()
                        ],
                      ),
                    )
                  : GraphWidget(
                      sensorId: widget.sensorId,
                      dateRange: _dateRange,
                      sensorData: dummyData,
                    ),
        ),
      ],
    );
  }
}
