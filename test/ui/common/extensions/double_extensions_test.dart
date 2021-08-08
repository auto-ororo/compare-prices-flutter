import 'package:compare_prices/ui/common/extensions/double_extensions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helper.dart';

void main() {
  group('DoubleExtensions', () {
    group('currency', () {
      testWithBuildContext('通貨記号あり・整数値', (context) {
        final formattedString = 15.0.currency(context, showSymbol: true);

        expect(formattedString,
            "${AppLocalizations.of(context)!.commonCurrencySymbol}15");
      });

      testWithBuildContext('通貨記号なし・整数値', (context) {
        final formattedString = 15.0.currency(context, showSymbol: false);

        expect(formattedString, "15");
      });

      testWithBuildContext('通貨記号あり・小数値あり', (context) {
        final formattedString = 15.1.currency(context, showSymbol: true);

        expect(formattedString,
            "${AppLocalizations.of(context)!.commonCurrencySymbol}15.1");
      });

      testWithBuildContext('通貨記号なし・小数値あり', (context) {
        final formattedString = 15.1.currency(context, showSymbol: false);

        expect(formattedString, "15.1");
      });
    });
  });
}
