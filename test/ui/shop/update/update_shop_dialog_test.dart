import 'package:compare_prices/domain/exception/domain_exception.dart';
import 'package:compare_prices/domain/exception/exception_type.dart';
import 'package:compare_prices/domain/models/result.dart';
import 'package:compare_prices/domain/models/shop.dart';
import 'package:compare_prices/domain/usecases/update_shop_use_case.dart';
import 'package:compare_prices/ui/common/extensions/exception_type_extensions.dart';
import 'package:compare_prices/ui/shop/update/update_shop_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/mockito.dart';

import '../../../helper.dart';
import '../../../mocks/generate.mocks.dart';

void main() {
  group('UpdateShopDialog', () {
    late MockUpdateShopUseCase updateShopUseCase;
    late List<Override> overrides;

    setUp(() {
      updateShopUseCase = MockUpdateShopUseCase();
      overrides = [
        updateShopUseCaseProvider.overrideWithProvider(
          Provider.autoDispose<UpdateShopUseCase>((ref) => updateShopUseCase),
        )
      ];
    });

    final initialShop = Shop.createByName("a");

    group('初期状態', () {
      testWidgets('名前がParamの店舗名であること', (WidgetTester tester) async {
        await tester.pumpAppWidget(
            UpdateShopDialog(
              shop: initialShop,
            ),
            overrides);

        expect(
            find.byWidgetPredicate((widget) =>
                widget is TextField &&
                widget.controller?.text == initialShop.name),
            findsOneWidget);
      });
    });

    group('更新', () {
      testWidgets('未入力でエラーが表示されること', (WidgetTester tester) async {
        await tester.pumpAppWidget(
            UpdateShopDialog(
              shop: initialShop,
            ),
            overrides);

        final context = tester.getContext(UpdateShopDialog);

        // 空入力
        await tester.enterText(
            find.byWidgetPredicate((widget) =>
                widget is TextField &&
                widget.controller?.text == initialShop.name),
            "");

        // 登録処理実行
        await tester.tap(find.text(AppLocalizations.of(context)!.commonUpdate));
        await tester.pump();
        expect(find.text(AppLocalizations.of(context)!.commonInputHint),
            findsOneWidget);

        expect(find.byType(UpdateShopDialog), findsOneWidget);
      });

      testWidgets('更新処理で問題が発生した場合エラーが表示されること', (WidgetTester tester) async {
        final exception = DomainException(ExceptionType.alreadyExists());
        when(updateShopUseCase.call(any))
            .thenAnswer((realInvocation) async => Result.failure(exception));

        await tester.pumpAppWidget(
            UpdateShopDialog(
              shop: initialShop,
            ),
            overrides);

        final context = tester.getContext(UpdateShopDialog);

        // 名前入力
        await tester.enterText(
            find.byWidgetPredicate((widget) =>
                widget is TextField &&
                widget.controller?.text == initialShop.name),
            initialShop.name);

        // 登録処理実行
        await tester.tap(find.text(AppLocalizations.of(context)!.commonUpdate));
        await tester.pump();
        expect(find.text(exception.exceptionType().errorMessage(context)),
            findsOneWidget);

        expect(find.byType(UpdateShopDialog), findsOneWidget);
      });

      testWidgets('入力した名前で更新されること', (WidgetTester tester) async {
        when(updateShopUseCase.call(any))
            .thenAnswer((realInvocation) async => Result.success(() {}));

        await tester.pumpAppWidget(
            UpdateShopDialog(
              shop: initialShop,
            ),
            overrides);

        final context = tester.getContext(UpdateShopDialog);

        final editedShop = initialShop.copyWith(name: "b");

        // 名前入力
        await tester.enterText(
            find.byWidgetPredicate((widget) =>
                widget is TextField &&
                widget.controller?.text == initialShop.name),
            editedShop.name);

        // 登録処理実行
        await tester.tap(find.text(AppLocalizations.of(context)!.commonUpdate));
        await tester.pumpAndSettle();
        verify(updateShopUseCase.call(editedShop)).called(1);

        expect(find.byType(UpdateShopDialog), findsNothing);
      });
    });

    group('キャンセル', () {
      testWidgets('ダイアログが閉じること', (WidgetTester tester) async {
        await tester.pumpAppWidget(
            UpdateShopDialog(
              shop: initialShop,
            ),
            overrides);

        final context = tester.getContext(UpdateShopDialog);

        await tester.tap(find.text(AppLocalizations.of(context)!.commonCancel));
        await tester.pumpAndSettle();

        expect(find.byType(UpdateShopDialog), findsNothing);
      });
    });
  });
}
