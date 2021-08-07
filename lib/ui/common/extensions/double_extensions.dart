import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

extension DoubleExtensions on double {
  String currency(BuildContext context, {bool showSymbol = true}) {
    final locale = Localizations.localeOf(context);
    final numberFormat;

    final decimalDigits = ((this * 10) % 10) == 0 ? 0 : 1;

    if (showSymbol) {
      numberFormat = NumberFormat.currency(
        locale: locale.languageCode,
        decimalDigits: decimalDigits,
        symbol: AppLocalizations.of(context)!.commonCurrencySymbol,
      );
    } else {
      numberFormat = NumberFormat.currency(
        locale: locale.languageCode,
        decimalDigits: decimalDigits,
        symbol: "",
      );
    }

    return numberFormat.format(this);
  }
}
