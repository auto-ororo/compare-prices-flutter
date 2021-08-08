import 'package:compare_prices/ui/common/extensions/int_extensions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helper.dart';

void main() {
  group('IntExtensions', () {
    group('currency', () {
      testWithBuildContext('通貨記号あり', (context) {
        final formattedString = 15.currency(context, showSymbol: true);

        expect(formattedString,
            "${AppLocalizations.of(context)!.commonCurrencySymbol}15");
      });

      testWithBuildContext('通貨記号なし', (context) {
        final formattedString = 15.currency(context, showSymbol: false);

        expect(formattedString, "15");
      });
    });
  });
}
