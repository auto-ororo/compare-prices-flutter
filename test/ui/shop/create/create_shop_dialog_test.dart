import 'package:compare_prices/domain/exception/domain_exception.dart';
import 'package:compare_prices/domain/exception/exception_type.dart';
import 'package:compare_prices/domain/models/result.dart';
import 'package:compare_prices/domain/models/shop.dart';
import 'package:compare_prices/domain/usecases/create_shop_by_name_use_case.dart';
import 'package:compare_prices/ui/common/extensions/exception_type_extensions.dart';
import 'package:compare_prices/ui/shop/create/create_shop_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/mockito.dart';

import '../../../helper.dart';
import '../../../mocks/generate.mocks.dart';

void main() {
  group('CreateShopDialog', () {
    late MockCreateShopByNameUseCase createShopByNameUseCase;

    late List<Override> overrides;

    setUp(() {
      createShopByNameUseCase = MockCreateShopByNameUseCase();
      overrides = [
        createShopByNameUseCaseProvider.overrideWithProvider(
          Provider.autoDispose<CreateShopByNameUseCase>(
              (ref) => createShopByNameUseCase),
        )
      ];
    });

    group('初期状態', () {
      testWidgets('名前が空欄であること', (WidgetTester tester) async {
        await tester.pumpAppWidget(CreateShopDialog(), overrides);

        expect(
            find.byWidgetPredicate((widget) =>
                widget is TextField && widget.controller?.text == ""),
            findsOneWidget);
      });
    });

    group('登録', () {
      testWidgets('未入力でエラーが表示されること', (WidgetTester tester) async {
        await tester.pumpAppWidget(CreateShopDialog(), overrides);

        final context = tester.getContext(CreateShopDialog);

        // 登録処理実行
        await tester.tap(find.text(AppLocalizations.of(context)!.commonAdd));
        await tester.pump();
        expect(find.text(AppLocalizations.of(context)!.commonInputHint),
            findsOneWidget);

        expect(find.byType(CreateShopDialog), findsOneWidget);
      });

      testWidgets('登録処理で問題が発生した場合、エラーが表示されること', (WidgetTester tester) async {
        final exception = DomainException(ExceptionType.alreadyExists());
        when(createShopByNameUseCase.call(any))
            .thenAnswer((realInvocation) async => Result.failure(exception));

        await tester.pumpAppWidget(CreateShopDialog(), overrides);

        final context = tester.getContext(CreateShopDialog);

        // 名前入力
        await tester.enterText(find.byType(TextField), "a");

        // 登録処理実行
        await tester.tap(find.text(AppLocalizations.of(context)!.commonAdd));
        await tester.pump();
        expect(find.text(exception.exceptionType().errorMessage(context)),
            findsOneWidget);

        expect(find.byType(CreateShopDialog), findsOneWidget);
      });

      testWidgets('入力した名前で登録されること', (WidgetTester tester) async {
        final shop = Shop.createByName("a");
        when(createShopByNameUseCase.call(any))
            .thenAnswer((realInvocation) async => Result.success(shop));

        await tester.pumpAppWidget(CreateShopDialog(), overrides);

        final context = tester.getContext(CreateShopDialog);

        // 名前入力
        await tester.enterText(find.byType(TextField), shop.name);

        // 登録処理実行
        await tester.tap(find.text(AppLocalizations.of(context)!.commonAdd));
        await tester.pumpAndSettle();
        verify(createShopByNameUseCase.call(shop.name)).called(1);

        expect(find.byType(CreateShopDialog), findsNothing);
      });
    });

    group('キャンセル', () {
      testWidgets('ダイアログが閉じること', (WidgetTester tester) async {
        await tester.pumpAppWidget(CreateShopDialog(), overrides);

        final context = tester.getContext(CreateShopDialog);

        await tester.tap(find.text(AppLocalizations.of(context)!.commonCancel));
        await tester.pumpAndSettle();

        expect(find.byType(CreateShopDialog), findsNothing);
      });
    });
  });
}
