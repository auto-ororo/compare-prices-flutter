import 'package:compare_prices/ui/common/extensions/datetime_extensions.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helper.dart';

void main() {
  group('DateTimeExtensions', () {
    group('toFormattedString', () {
      testWithBuildContext('0埋めなし', (context) {
        final dateTime = DateTime(2021, 11, 11);

        final formattedString = dateTime.toFormattedString(context);

        expect(formattedString, "2021/11/11");
      });

      testWithBuildContext('0埋めあり', (context) {
        final dateTime = DateTime(2021, 1, 1);

        final formattedString = dateTime.toFormattedString(context);

        expect(formattedString, "2021/01/01");
      });
    });
  });
}
