import 'package:flutter/material.dart';
import 'package:iot_devices_manager_app/themes/light/drop_down_menu.dart';

import '../../models/data_filtering.dart';
import '../../themes/light/text_theme.dart';

class FilterDataWidget extends StatefulWidget {
  int sensorId;
  static const routeName = '/device-detail';

  FilterDataWidget(this.sensorId, {Key? key}) : super(key: key);

  @override
  State<FilterDataWidget> createState() => _FilterDataWidgetState();
}

class _FilterDataWidgetState extends State<FilterDataWidget> {
  String _dataRangeValue = DataFilteringRanges.pastMonth.text;

  List<DropdownMenuItem<String>> _dataRangeMenu() {
    return DataFilteringRanges.values
        .map(
          (e) => _dataRangeValue == e.text
              ? DropdownMenuItem(
                  value: e.text,
                  child: Text(
                    e.text,
                    style: SelectedDropDownItemStyle.data,
                  ),
                )
              : DropdownMenuItem(
                  value: e.text,
                  child: Text(
                    e.text,
                    style: UnselectedDropDownItemStyle.data,
                  ),
                ),
        )
        .toList();
  }

  List<PopupMenuItem<String>> _dataRangePopupMenu() {
    return DataFilteringRanges.values
        .map(
          (e) => _dataRangeValue == e.text
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

  @override
  Widget build(BuildContext context) {
    final sensorId = ModalRoute.of(context)!.settings.arguments as int;
    return Row(
      children: [
        const Text(
          'Display data for: ',
          style: TextInDetailsScreen.data,
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          _dataRangeValue,
          style: Theme.of(context).textTheme.headline5,
        ),
        // DropdownButton(
        //   underline: Container(),
        //   value: _dataRangeValue,
        //   items: _dataRangeMenu(),
        //   onChanged: (String? newValue) {
        //     if (newValue != null) {
        //       setState(() => _dataRangeValue = newValue);
        //     }
        //   },
        // ),
        PopupMenuButton(
          onSelected: (String? newValue) {
            if (newValue != null) {
              setState(() => _dataRangeValue = newValue);
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
    );
  }
}
