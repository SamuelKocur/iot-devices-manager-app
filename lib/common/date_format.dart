import 'package:intl/intl.dart';


class DateFormatter {
 static const dateTimeFormat = 'd MMM yyyy H:mm';
 static const dateFormat = 'd MMM yyyy';
 static const dateGraphFormat = 'd MMM y H:mm';

 static String dateTime(DateTime date) {
  return DateFormat(dateTimeFormat).format(date);
 }

 static String date(DateTime date) {
  return DateFormat(dateFormat).format(date);
 }

 static String graphDate(DateTime date) {
  return DateFormat(dateGraphFormat).format(date);
 }

 static String byFormat(DateTime date, String format) {
  return DateFormat(format).format(date);
 }
}
