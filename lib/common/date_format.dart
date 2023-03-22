import 'package:intl/intl.dart';


class DateFormatter {
 static const dateTimeFormat = 'dd-MM-yyyy H:mm';
 static const dateFormat = 'd MMM yyyy';
 static const dateGraphFormat = 'd MMM y H:mm';
 static const availableDateTimeFormats = [
  'MMM d yyyy, H:mm',
  'dd.MM.yyyy H:mm',
  'dd-MM-yyyy H:mm',
  'dd/MM/yyyy H:mm',
 ];

 static String dateTime(DateTime date) {
  return DateFormat(dateTimeFormat).format(date.toLocal());
 }

 static String date(DateTime date) {
  return DateFormat(dateFormat).format(date.toLocal());
 }

 static String graphDate(DateTime date) {
  return DateFormat(dateGraphFormat).format(date.toLocal());
 }

 static String byFormat(DateTime date, String format) {
  return DateFormat(format).format(date.toLocal());
 }
}
