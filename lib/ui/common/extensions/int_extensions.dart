import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

extension IntExtensions on int {
  String currency(BuildContext context, {bool showSymbol = true}) {
    final locale = Localizations.localeOf(context);
    final _number_format;

    if (showSymbol) {
      _number_format = NumberFormat.currency(
          locale: locale.languageCode,
          symbol: AppLocalizations.of(context)!.commonCurrencySymbol);
    } else {
      _number_format =
          NumberFormat.currency(locale: locale.languageCode, symbol: "");
    }

    return _number_format.format(this);
  }
}
