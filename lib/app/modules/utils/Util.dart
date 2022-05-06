import 'package:intl/intl.dart';

class Util {
  static String baseUrl = 'https://api.openweathermap.org/data/2.5/onecall?';
  static String appId = '047535d7eb71ef66ab3585908a4a2dcc';

  static String getFormateDate(DateTime dateTime) {
    return DateFormat().add_yMMMEd().format(dateTime);
  }

  static String getFormatedDay(DateTime dateTime) {
    return DateFormat().add_EEEE().format(dateTime);
  }
}
