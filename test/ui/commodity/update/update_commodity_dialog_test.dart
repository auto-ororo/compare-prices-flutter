import 'package:compare_prices/domain/exception/domain_exception.dart';
import 'package:compare_prices/domain/exception/exception_type.dart';
import 'package:compare_prices/domain/models/commodity.dart';
import 'package:compare_prices/domain/models/quantity_type.dart';
import 'package:compare_prices/domain/models/result.dart';
import 'package:compare_prices/domain/usecases/update_commodity_use_case.dart';
import 'package:compare_prices/ui/commodity/update/update_commodity_dialog.dart';
import 'package:compare_prices/ui/common/extensions/exception_type_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/mockito.dart';

import '../../../helper.dart';
import '../../../mocks/generate.mocks.dart';

void main() {
  group('UpdateCommodityDialog', () {
    late MockUpdateCommodityUseCase updateCommodityUseCase;

    late List<Override> overrides;

    setUp(() {
      updateCommodityUseCase = MockUpdateCommodityUseCase();
      overrides = [
        updateCommodityUseCaseProvider.overrideWithProvider(
          Provider.autoDispose<UpdateCommodityUseCase>(
              (ref) => updateCommodityUseCase),
        )
      ];
    });

    final initialCommodity = Commodity.create("a", QuantityType.gram());

    group('初期状態', () {
      testWidgets('名前がParamの商品名、単位であること', (WidgetTester tester) async {
        await tester.pumpAppWidget(
            UpdateCommodityDialog(
              commodity: initialCommodity,
            ),
            overrides);

        expect(
            find.byWidgetPredicate((widget) =>
                widget is TextField &&
                widget.controller?.text == initialCommodity.name),
            findsOneWidget);
        expect(
            find.byWidgetPredicate(
                (widget) => widget is TextField && widget.enabled == false),
            findsOneWidget);
      });
    });

    group('更新', () {
      testWidgets('未入力でエラーが表示されること', (WidgetTester tester) async {
        await tester.pumpAppWidget(
            UpdateCommodityDialog(
              commodity: initialCommodity,
            ),
            overrides);

        final context = tester.getContext(UpdateCommodityDialog);

        // 空入力
        await tester.enterText(
            find.byWidgetPredicate((widget) =>
                widget is TextField &&
                widget.controller?.text == initialCommodity.name),
            "");

        // 登録処理実行
        await tester.tap(find.text(AppLocalizations.of(context)!.commonUpdate));
        await tester.pump();
        expect(find.text(AppLocalizations.of(context)!.commonInputHint),
            findsOneWidget);

        expect(find.byType(UpdateCommodityDialog), findsOneWidget);
      });

      testWidgets('更新処理で問題が発生した場合エラーが表示されること', (WidgetTester tester) async {
        final exception = DomainException(ExceptionType.alreadyExists());
        when(updateCommodityUseCase.call(any))
            .thenAnswer((realInvocation) async => Result.failure(exception));

        await tester.pumpAppWidget(
            UpdateCommodityDialog(
              commodity: initialCommodity,
            ),
            overrides);

        final context = tester.getContext(UpdateCommodityDialog);

        // 名前入力
        await tester.enterText(
            find.byWidgetPredicate((widget) =>
                widget is TextField &&
                widget.controller?.text == initialCommodity.name),
            initialCommodity.name);

        // 登録処理実行
        await tester.tap(find.text(AppLocalizations.of(context)!.commonUpdate));
        await tester.pump();
        expect(find.text(exception.exceptionType().errorMessage(context)),
            findsOneWidget);

        expect(find.byType(UpdateCommodityDialog), findsOneWidget);
      });

      testWidgets('入力した名前で更新されること', (WidgetTester tester) async {
        when(updateCommodityUseCase.call(any))
            .thenAnswer((realInvocation) async => Result.success(() {}));

        await tester.pumpAppWidget(
            UpdateCommodityDialog(
              commodity: initialCommodity,
            ),
            overrides);

        final context = tester.getContext(UpdateCommodityDialog);

        final editedCommodity = initialCommodity.copyWith(name: "b");

        // 名前入力
        await tester.enterText(
            find.byWidgetPredicate((widget) =>
                widget is TextField &&
                widget.controller?.text == initialCommodity.name),
            editedCommodity.name);

        // 登録処理実行
        await tester.tap(find.text(AppLocalizations.of(context)!.commonUpdate));
        await tester.pumpAndSettle();
        verify(updateCommodityUseCase.call(editedCommodity)).called(1);

        expect(find.byType(UpdateCommodityDialog), findsNothing);
      });
    });

    group('キャンセル', () {
      testWidgets('ダイアログが閉じること', (WidgetTester tester) async {
        await tester.pumpAppWidget(
            UpdateCommodityDialog(
              commodity: initialCommodity,
            ),
            overrides);

        final context = tester.getContext(UpdateCommodityDialog);

        await tester.tap(find.text(AppLocalizations.of(context)!.commonCancel));
        await tester.pumpAndSettle();

        expect(find.byType(UpdateCommodityDialog), findsNothing);
      });
    });
  });
}
