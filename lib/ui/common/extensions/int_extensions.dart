import 'package:intl/intl.dart';

final _number_format_with_symbol =
    NumberFormat.currency(locale: "ja_JP", symbol: "¥");

final _number_format_without_symbol =
    NumberFormat.currency(locale: "ja_JP", symbol: "");

extension IntExtensions on int {
  String currency({bool showSymbol = true}) {
    if (showSymbol) {
      return _number_format_with_symbol.format(this);
    } else {
      return _number_format_without_symbol.format(this);
    }
  }
}
