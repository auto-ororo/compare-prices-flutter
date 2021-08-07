import 'package:compare_prices/domain/exception/domain_exception.dart';
import 'package:compare_prices/domain/exception/exception_type.dart';
import 'package:compare_prices/domain/models/commodity.dart';
import 'package:compare_prices/domain/models/quantity_type.dart';
import 'package:compare_prices/domain/models/result.dart';
import 'package:compare_prices/domain/usecases/create_commodity_use_case.dart';
import 'package:compare_prices/ui/commodity/create/create_commodity_dialog.dart';
import 'package:compare_prices/ui/common/extensions/exception_type_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/mockito.dart';

import '../../../helper.dart';
import '../../../mocks/generate.mocks.dart';

void main() {
  group('CreateCommodityDialog', () {
    final createCommodityUseCase = MockCreateCommodityUseCase();
    final overrides = [
      createCommodityUseCaseProvider.overrideWithProvider(
        Provider.autoDispose<CreateCommodityUseCase>(
            (ref) => createCommodityUseCase),
      )
    ];

    group('初期状態', () {
      testWidgets('名前が空欄、単位が数量であること', (WidgetTester tester) async {
        await tester.pumpAppWidget(CreateCommodityDialog(), overrides);

        final context = tester.getContext(CreateCommodityDialog);

        expect(
            find.byWidgetPredicate((widget) =>
                widget is TextField && widget.controller?.text == ""),
            findsOneWidget);
        expect(find.text(AppLocalizations.of(context)!.quantityCountLabel),
            findsOneWidget);
      });
    });

    group('登録', () {
      testWidgets('未入力でエラーが表示されること', (WidgetTester tester) async {
        await tester.pumpAppWidget(CreateCommodityDialog(), overrides);

        final context = tester.getContext(CreateCommodityDialog);

        // 登録処理実行
        await tester.tap(find.text(AppLocalizations.of(context)!.commonAdd));
        await tester.pump();
        expect(find.text(AppLocalizations.of(context)!.commonInputHint),
            findsOneWidget);

        expect(find.byType(CreateCommodityDialog), findsOneWidget);
      });

      testWidgets('登録処理で問題が発生した場合、エラーが表示されること', (WidgetTester tester) async {
        final exception = DomainException(ExceptionType.alreadyExists());
        when(createCommodityUseCase.call(any))
            .thenAnswer((realInvocation) async => Result.failure(exception));

        await tester.pumpAppWidget(CreateCommodityDialog(), overrides);

        final context = tester.getContext(CreateCommodityDialog);

        // 名前入力
        await tester.enterText(find.byType(TextField), "a");

        // 登録処理実行
        await tester.tap(find.text(AppLocalizations.of(context)!.commonAdd));
        await tester.pump();
        expect(find.text(exception.exceptionType().errorMessage(context)),
            findsOneWidget);

        expect(find.byType(CreateCommodityDialog), findsOneWidget);
      });

      testWidgets('入力した名前、単位で登録されること', (WidgetTester tester) async {
        final commodity = Commodity.create("a", QuantityType.gram());
        when(createCommodityUseCase.call(any))
            .thenAnswer((realInvocation) async => Result.success(commodity));

        await tester.pumpAppWidget(CreateCommodityDialog(), overrides);

        final context = tester.getContext(CreateCommodityDialog);

        // 名前入力
        await tester.enterText(find.byType(TextField), commodity.name);

        // 単位選択
        await tester
            .tap(find.text(AppLocalizations.of(context)!.quantityCountLabel));
        await tester.pump();
        QuantityType.values().forEach((element) {
          expect(find.text(element.label(context)), findsWidgets);
        });
        await tester.tap(find.text(commodity.quantityType.label(context)).last);
        await tester.pump();
        expect(
            find.text(commodity.quantityType.label(context)), findsOneWidget);

        // 登録処理実行
        await tester.tap(find.text(AppLocalizations.of(context)!.commonAdd));
        await tester.pumpAndSettle();
        verify(createCommodityUseCase.call(CreateCommodityUseCaseParams(
                name: commodity.name, quantityType: commodity.quantityType)))
            .called(1);

        expect(find.byType(CreateCommodityDialog), findsNothing);
      });
    });

    group('キャンセル', () {
      testWidgets('ダイアログが閉じること', (WidgetTester tester) async {
        await tester.pumpAppWidget(CreateCommodityDialog(), overrides);

        final context = tester.getContext(CreateCommodityDialog);

        await tester.tap(find.text(AppLocalizations.of(context)!.commonCancel));
        await tester.pumpAndSettle();

        expect(find.byType(CreateCommodityDialog), findsNothing);
      });
    });
  });
}
