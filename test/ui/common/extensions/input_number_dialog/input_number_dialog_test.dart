import 'package:compare_prices/domain/models/number_type.dart';
import 'package:compare_prices/ui/common/input_number_dialog/input_number_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helper.dart';

void main() {
  group('CreateCommodityDialog', () {
    final title = "title";
    group('初期状態', () {
      testWidgets('Paramが反映されること', (WidgetTester tester) async {
        final suffix = "suffix";
        final initialNumber = 10;
        final numberType = NumberType.count();

        await tester.pumpAppWidget(
            InputNumberDialog(
              title: title,
              suffix: suffix,
              initialNumber: initialNumber,
              numberType: numberType,
            ),
            []);

        await tester.pump();

        expect(find.text(title), findsOneWidget);
        expect(find.text(suffix), findsOneWidget);
        expect(find.text(initialNumber.toString()), findsOneWidget);
      });
    });

    group('数値表示', () {
      final initialNumber = 1000;
      testWidgets('タイプがcountの場合そのまま表示されること', (WidgetTester tester) async {
        final numberType = NumberType.count();

        await tester.pumpAppWidget(
            InputNumberDialog(
              title: title,
              initialNumber: initialNumber,
              numberType: numberType,
            ),
            []);

        await tester.pump();

        expect(find.text("1000"), findsOneWidget);
      });

      testWidgets('タイプがquantityの場合そのまま表示されること', (WidgetTester tester) async {
        final numberType = NumberType.quantity();

        await tester.pumpAppWidget(
            InputNumberDialog(
              title: title,
              initialNumber: initialNumber,
              numberType: numberType,
            ),
            []);

        await tester.pump();

        expect(find.text("1000"), findsOneWidget);
      });

      testWidgets('タイプがcurrencyの場合通貨形式で表示されること', (WidgetTester tester) async {
        final numberType = NumberType.currency();

        await tester.pumpAppWidget(
            InputNumberDialog(
              title: title,
              initialNumber: initialNumber,
              numberType: numberType,
            ),
            []);

        await tester.pump();

        final context = tester.getContext(InputNumberDialog);
        expect(
            find.text(
                "${AppLocalizations.of(context)!.commonCurrencySymbol}1,000"),
            findsOneWidget);
      });
    });

    group('入力', () {
      testWidgets('Paramの最大桁数以上入力できないこと', (WidgetTester tester) async {
        final numberType = NumberType.count();

        await tester.pumpAppWidget(
            InputNumberDialog(
              title: title,
              initialNumber: null,
              maxNumberOfDigits: 3,
              numberType: numberType,
            ),
            []);

        await tester.pump();

        await tester.tap(find.text("1"));
        await tester.tap(find.text("2"));
        await tester.tap(find.text("3"));
        await tester.tap(find.text("4"));

        await tester.pump();

        expect(find.text("123"), findsOneWidget);
        expect(find.text("1234"), findsNothing);
      });

      testWidgets('入力値が0の状態で0入力しても0のままであること', (WidgetTester tester) async {
        final numberType = NumberType.count();

        await tester.pumpAppWidget(
            InputNumberDialog(
              title: title,
              initialNumber: null,
              maxNumberOfDigits: 3,
              numberType: numberType,
            ),
            []);

        await tester.pumpAndSettle();

        await tester.tap(find.byWidgetPredicate(
            (widget) => widget is Text && widget.data == "0"));

        await tester.pump();

        expect(find.text("00"), findsNothing);
      });

      testWidgets('バックスペースで文字が削除されること', (WidgetTester tester) async {
        final numberType = NumberType.count();

        await tester.pumpAppWidget(
            InputNumberDialog(
              title: title,
              initialNumber: null,
              numberType: numberType,
            ),
            []);

        await tester.pumpAndSettle();

        await tester.tap(find.text("1"));
        await tester.tap(find.text("2"));
        await tester.tap(find.text("3"));
        await tester.tap(find.byIcon(Icons.backspace_outlined));

        await tester.pump();

        expect(find.text("12"), findsOneWidget);
        expect(find.text("123"), findsNothing);
      });

      testWidgets('入力値が0の状態でバックスペースを押下しても文字が削除されないこと',
          (WidgetTester tester) async {
        final numberType = NumberType.count();

        await tester.pumpAppWidget(
            InputNumberDialog(
              title: title,
              initialNumber: null,
              numberType: numberType,
            ),
            []);

        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.backspace_outlined));

        await tester.pump();

        expect(find.text("0"), findsNWidgets(2));
      });

      testWidgets('クリアキー押下で入力値が0になること', (WidgetTester tester) async {
        final numberType = NumberType.count();
        final initialNumber = 100;

        await tester.pumpAppWidget(
            InputNumberDialog(
              title: title,
              initialNumber: null,
              numberType: numberType,
            ),
            []);

        await tester.pumpAndSettle();

        await tester.tap(find.text("C"));

        await tester.pump();

        expect(find.text("0"), findsNWidgets(2));
        expect(find.text(initialNumber.toString()), findsNothing);
      });
    });

    group('終了', () {
      testWidgets('OKボタンでダイアログが閉じること', (WidgetTester tester) async {
        final numberType = NumberType.count();

        await tester.pumpAppWidget(
            InputNumberDialog(
              title: title,
              initialNumber: null,
              numberType: numberType,
            ),
            []);

        await tester.pumpAndSettle();

        final context = tester.getContext(InputNumberDialog);

        await tester.tap(find.text(AppLocalizations.of(context)!.commonOk));

        await tester.pumpAndSettle();

        expect(find.byType(InputNumberDialog), findsNothing);
      });

      testWidgets('Cancelボタンでダイアログが閉じること', (WidgetTester tester) async {
        final numberType = NumberType.count();

        await tester.pumpAppWidget(
            InputNumberDialog(
              title: title,
              initialNumber: null,
              numberType: numberType,
            ),
            []);

        await tester.pumpAndSettle();

        final context = tester.getContext(InputNumberDialog);

        await tester.tap(find.text(AppLocalizations.of(context)!.commonCancel));

        await tester.pumpAndSettle();

        expect(find.byType(InputNumberDialog), findsNothing);
      });
    });
  });
}
