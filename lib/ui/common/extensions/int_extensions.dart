import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

extension IntExtensions on int {
  String currency(BuildContext context, {bool showSymbol = true}) {
    final locale = Localizations.localeOf(context);
    final number_format;

    if (showSymbol) {
      number_format = NumberFormat.currency(
          locale: locale.languageCode,
          symbol: AppLocalizations.of(context)!.commonCurrencySymbol);
    } else {
      number_format =
          NumberFormat.currency(locale: locale.languageCode, symbol: "");
    }

    return number_format.format(this);
  }
}
