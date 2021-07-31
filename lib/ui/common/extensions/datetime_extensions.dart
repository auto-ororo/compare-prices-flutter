import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

extension DateTimeExtensions on DateTime {
  String toFormattedString(BuildContext context) {
    final _date_format =
        DateFormat(AppLocalizations.of(context)!.commonYyyyMmDd);
    return _date_format.format(this);
  }
}
