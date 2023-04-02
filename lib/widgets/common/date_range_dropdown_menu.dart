import 'package:flutter/material.dart';

import '../../models/data_filtering.dart';
import '../../themes/light/drop_down_menu.dart';

class DateRangeDropDownMenu extends StatelessWidget {
  String dateRangeCurrentValue;
  DateRange dateRange;
  final Function(String, DateRange) onUpdate;

  DateRangeDropDownMenu({
    Key? key,
    required this.dateRangeCurrentValue,
    required this.dateRange,
    required this.onUpdate,
  }) : super(key: key);

  List<DropdownMenuItem<String>> _dateRangeDropDownMenu() {
    return DateRangeOptions.values
        .map(
          (e) => dateRangeCurrentValue == e.text
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

  void _setDateRange(String newDateRangeOption, BuildContext context) {
    if (newDateRangeOption == DateRangeOptions.dataRange.text) {
      _displayDayPicker(newDateRangeOption, context);
      return;
    }
    DateRange dateRange = DateRangeOptions.getDateTime(newDateRangeOption);

    onUpdate(
      newDateRangeOption,
      dateRange,
    );
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
        onUpdate(
          newDateRangeOption,
          DateRange(
              fromRange.start,
              fromRange.end
                  .add(const Duration(days: 1))
                  .subtract(const Duration(milliseconds: 1))),
        );
      }
    });
    return;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      onChanged: (String? newValue) {
        if (newValue != null) {
          _setDateRange(newValue, context);
        }
      },
      items: _dateRangeDropDownMenu(),
      value: dateRangeCurrentValue,
    );
  }
}
