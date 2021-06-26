import 'package:intl/intl.dart';

final _number_format = NumberFormat.currency(locale: "ja_JP", symbol: "¥");

extension IntExtensions on int {
  String currency() {
    return _number_format.format(this);
  }
}
