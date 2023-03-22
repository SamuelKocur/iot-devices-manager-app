class DateRange {
  const DateRange(this.dateFrom, this.dateTo);

  final DateTime dateFrom;
  final DateTime dateTo;
}

enum DateRangeOptions {
  pastDay('Past Day'),
  pastWeek('Past Week'),
  pastMonth('Past Month'),
  pastYear('Past Year'),
  dataRange('Select A Data Range');

  const DateRangeOptions(this.text);

  static DateRangeOptions getDateRangeOptionByText(String text) {
    return DateRangeOptions.values.firstWhere(
            (option) => option.text == text,
      orElse: () => DateRangeOptions.pastWeek,
    );
  }

  final String text;

  static DateRange getDateTime(
      String text,
      {DateTime? paDateFrom,
        DateTime? paDateTo,
      }) {
    DateRangeOptions dateRange = DateRangeOptions.values.firstWhere((element) => element.text == text);
    DateTime dateTo = DateTime.now();

    switch(dateRange) {
      case DateRangeOptions.pastDay:
        DateTime dateFrom = dateTo.subtract(const Duration(days: 1));
        return DateRange(dateFrom, dateTo);
      case DateRangeOptions.pastWeek:
        DateTime dateFrom = dateTo.subtract(const Duration(days: 7));
        return DateRange(dateFrom, dateTo);
      case DateRangeOptions.pastMonth:
        DateTime dateFrom = DateTime(
          dateTo.year,
          dateTo.month - 1,
          dateTo.day,
          dateTo.hour,
          dateTo.minute,
          dateTo.second,
          dateTo.millisecond,
          dateTo.microsecond,
        );
        return DateRange(dateFrom, dateTo);
      case DateRangeOptions.pastYear:
        DateTime dateFrom = DateTime(
          dateTo.year - 1,
          dateTo.month,
          dateTo.day,
          dateTo.hour,
          dateTo.minute,
          dateTo.second,
          dateTo.millisecond,
          dateTo.microsecond,
        );
        return DateRange(dateFrom, dateTo);
      case DateRangeOptions.dataRange:
        return DateRange(paDateFrom!, paDateTo!);
      default: // by default it returns past week data
        DateTime dateFrom = dateTo.subtract(const Duration(days: 7));
        return DateRange(dateFrom, dateTo);
    }
  }
}
