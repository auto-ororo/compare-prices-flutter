import 'package:intl/intl.dart';

final _date_format = DateFormat("yyyy-MM-dd");

extension DateTimeExtensions on DateTime {
  String toFormattedString() {
    return _date_format.format(this);
  }
}
