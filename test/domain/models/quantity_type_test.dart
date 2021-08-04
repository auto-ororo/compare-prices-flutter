import 'package:compare_prices/domain/models/quantity_type.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helper.dart';

void main() {
  group('QuantityType', () {
    final countType = QuantityType.count();
    final gramType = QuantityType.gram();
    final milliliterType = QuantityType.milliliter();

    group('getTypeById', () {
      test('count', () {
        expect(QuantityType.getTypeById("1"), countType);
      });

      test('gram', () {
        expect(QuantityType.getTypeById("2"), gramType);
      });

      test('milliliter', () {
        expect(QuantityType.getTypeById("3"), milliliterType);
      });
    });

    group('values', () {
      test('Typeが網羅されていること', () {
        expect(QuantityType.values(), [
          countType,
          gramType,
          milliliterType,
        ]);
      });
    });

    group('id', () {
      test('count', () {
        expect(countType.id(), "1");
      });

      test('gram', () {
        expect(gramType.id(), "2");
      });

      test('milliliter', () {
        expect(milliliterType.id(), "3");
      });
    });

    group('unit', () {
      test('count', () {
        expect(countType.unit(), 1);
      });

      test('gram', () {
        expect(gramType.unit(), 100);
      });

      test('milliliter', () {
        expect(milliliterType.unit(), 100);
      });
    });

    group('suffix', () {
      testWithBuildContext('count', (context) {
        expect(countType.suffix(context),
            AppLocalizations.of(context)?.quantityCountSuffix);
      });

      testWithBuildContext('gram', (context) {
        expect(gramType.suffix(context),
            AppLocalizations.of(context)?.quantityGramSuffix);
      });

      testWithBuildContext('milliliter', (context) {
        expect(milliliterType.suffix(context),
            AppLocalizations.of(context)?.quantityMilliliterSuffix);
      });
    });

    group('label', () {
      testWithBuildContext('count', (context) {
        expect(countType.label(context),
            AppLocalizations.of(context)?.quantityCountLabel);
      });

      testWithBuildContext('gram', (context) {
        expect(gramType.label(context),
            AppLocalizations.of(context)?.quantityGramLabel);
      });

      testWithBuildContext('milliliter', (context) {
        expect(milliliterType.label(context),
            AppLocalizations.of(context)?.quantityMilliliterLabel);
      });
    });

    group('isEqualToUnit', () {
      test('count', () {
        expect(countType.isEqualToUnit(1), true);
        expect(countType.isEqualToUnit(100), false);
      });

      test('gram', () {
        expect(gramType.isEqualToUnit(1), false);
        expect(gramType.isEqualToUnit(100), true);
      });

      test('milliliter', () {
        expect(milliliterType.isEqualToUnit(1), false);
        expect(milliliterType.isEqualToUnit(100), true);
      });
    });
  });
}
