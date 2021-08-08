import 'package:compare_prices/domain/exception/exception_type.dart';
import 'package:compare_prices/ui/common/extensions/exception_type_extensions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helper.dart';

void main() {
  group('ExceptionTypeExtensions', () {
    group('errorMessage', () {
      testWithBuildContext('alreadyExists', (context) {
        final message = ExceptionType.alreadyExists().errorMessage(context);

        expect(message, AppLocalizations.of(context)!.errorAlreadyExists);
      });

      testWithBuildContext('errorNotFound', (context) {
        final message = ExceptionType.notFound().errorMessage(context);

        expect(message, AppLocalizations.of(context)!.errorNotFound);
      });

      testWithBuildContext('unknown', (context) {
        final message = ExceptionType.unknown("msg").errorMessage(context);

        expect(message, AppLocalizations.of(context)!.errorUnknown("msg"));
      });
    });
  });
}
