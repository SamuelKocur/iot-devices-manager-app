import 'package:flutter/material.dart';
import 'package:iot_devices_manager_app/models/requests/filter_data.dart';
import 'package:iot_devices_manager_app/models/responses/filter_data.dart';
import 'package:iot_devices_manager_app/providers/data_filtering.dart';
import 'package:iot_devices_manager_app/widgets/common/date_range_dropdown_menu.dart';
import 'package:iot_devices_manager_app/widgets/device_detail/graph_widget.dart';
import 'package:iot_devices_manager_app/widgets/device_detail/table_widget.dart';
import 'package:provider/provider.dart';

import '../../models/data_filtering.dart';
import '../../providers/user.dart';
import '../../themes/light/text_theme.dart';
import '../common/error_dialog.dart';

class FilterDataWidget extends StatefulWidget {
  int sensorId;

  FilterDataWidget(this.sensorId, {Key? key}) : super(key: key);

  @override
  State<FilterDataWidget> createState() => _FilterDataWidgetState();
}

class _FilterDataWidgetState extends State<FilterDataWidget> {
  String _dateRangeCurrentValue = DateRangeOptions.pastWeek.text;
  DateRange _dateRange = DateRangeOptions.getDateTime(DateRangeOptions.pastWeek.text);


  Future<void> _getSensorData(BuildContext context) async {
    try {
      FilterDataRequest request = FilterDataRequest(
        dateFrom: _dateRange.dateFrom,
        dateTo: _dateRange.dateTo,
        sensorId: widget.sensorId,
      );
      FilterResponse filterProvider = Provider.of<FilterResponse>(context, listen: false);
      await Provider.of<DataFiltering>(context, listen: false).filterData(request, filterProvider);
    } catch (error) {
      DialogUtils.showErrorDialog(
          context, 'Something went wrong when trying to fetch the data. Please try again later.');
    }
  }

  void _updateDataRangeValues(String newDateRangeCurrentValue, DateRange newDateRange) {
    setState(() {
      _dateRangeCurrentValue = newDateRangeCurrentValue;
      _dateRange = newDateRange;
    });
  }

  @override
  void initState() {
    super.initState();
    DateRangeOptions rangeOption = Provider.of<UserData>(context, listen: false).userAppSettings.dateRangeOption;
    _dateRange = DateRangeOptions.getDateTime(rangeOption.text);
    _dateRangeCurrentValue = rangeOption.text;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Text(
              'Get data for: ',
              style: TextInDetailsScreen.data,
            ),
            const SizedBox(
              width: 10,
            ),
            DateRangeDropDownMenu(
              dateRangeCurrentValue: _dateRangeCurrentValue,
              dateRange: _dateRange,
              onUpdate: _updateDataRangeValues,
            ),
          ],
        ),
        FutureBuilder(
          future: _getSensorData(context),
          builder: (ctx, snapshot) =>
              snapshot.connectionState == ConnectionState.waiting
                  ? Column(
                      children: [
                        Center(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              GraphWidget(
                                sensorId: widget.sensorId,
                                dateRange: _dateRange,
                                showData: false,
                              ),
                              const CircularProgressIndicator()
                            ],
                          ),
                        ),
                        Text(
                          'Data:',
                          style: Theme.of(context).textTheme.headline5,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        TableWidget(
                          sensorId: widget.sensorId,
                        )
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GraphWidget(
                          sensorId: widget.sensorId,
                          dateRange: _dateRange,
                        ),
                        Text(
                          'Data:',
                          style: Theme.of(context).textTheme.headline5,
                        ),
                        Text(
                          'Selected data will be displayed in the graph',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        TableWidget(
                          sensorId: widget.sensorId,
                        )
                      ],
                    ),
        ),
      ],
    );
  }
}
