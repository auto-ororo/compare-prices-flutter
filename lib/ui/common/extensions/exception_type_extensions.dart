import 'package:compare_prices/domain/exception/exception_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension ExceptionTypeExtensions on ExceptionType {
  String errorMessage(BuildContext context) {
    var errorMessage;

    this.when(
      alreadyExists: () =>
          {errorMessage = AppLocalizations.of(context)!.errorAlreadyExists},
      notFound: () =>
          {errorMessage = AppLocalizations.of(context)!.errorNotFound},
      unknown: (message) =>
          {errorMessage = AppLocalizations.of(context)!.errorUnknown(message)},
    );

    return errorMessage;
  }
}
