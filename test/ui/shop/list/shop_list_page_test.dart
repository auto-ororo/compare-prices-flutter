import 'package:compare_prices/domain/exception/domain_exception.dart';
import 'package:compare_prices/domain/exception/exception_type.dart';
import 'package:compare_prices/domain/models/result.dart';
import 'package:compare_prices/domain/models/shop.dart';
import 'package:compare_prices/domain/models/shop_sort_type.dart';
import 'package:compare_prices/domain/usecases/create_shop_by_name_use_case.dart';
import 'package:compare_prices/domain/usecases/delete_shop_use_case.dart';
import 'package:compare_prices/domain/usecases/filter_shops_by_keyword_use_case.dart';
import 'package:compare_prices/domain/usecases/get_shops_use_case.dart';
import 'package:compare_prices/domain/usecases/sort_shops_use_case.dart';
import 'package:compare_prices/ui/assets/color/app_colors.dart';
import 'package:compare_prices/ui/common/extensions/exception_type_extensions.dart';
import 'package:compare_prices/ui/common/search_text_field.dart';
import 'package:compare_prices/ui/drawer/app_drawer.dart';
import 'package:compare_prices/ui/shop/create/create_shop_dialog.dart';
import 'package:compare_prices/ui/shop/list/shop_list_page.dart';
import 'package:compare_prices/ui/shop/update/update_shop_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/mockito.dart';

import '../../../helper.dart';
import '../../../mocks/generate.mocks.dart';

void main() {
  group('ShopListPage', () {
    late MockCreateShopByNameUseCase createShopUseCase;
    late MockGetShopsUseCase getShopsUseCase;
    late MockDeleteShopUseCase deleteShopUseCase;
    late MockFilterShopsByKeywordUseCase filterShopsByKeywordUseCase;
    late MockSortShopsUseCase sortShopsUseCase;

    late List<Override> overrides;

    final title = "title";

    final shop1 = Shop.createByName("a");
    final shop2 = Shop.createByName("b");
    final shop3 = Shop.createByName("c");

    final baseShops = [shop1, shop2, shop3];

    setUp(() {
      createShopUseCase = MockCreateShopByNameUseCase();
      getShopsUseCase = MockGetShopsUseCase();
      deleteShopUseCase = MockDeleteShopUseCase();
      filterShopsByKeywordUseCase = MockFilterShopsByKeywordUseCase();
      sortShopsUseCase = MockSortShopsUseCase();

      overrides = [
        createShopByNameUseCaseProvider.overrideWithProvider(
          Provider.autoDispose<CreateShopByNameUseCase>(
              (ref) => createShopUseCase),
        ),
        getShopsUseCaseProvider.overrideWithProvider(
          Provider.autoDispose<GetShopsUseCase>((ref) => getShopsUseCase),
        ),
        deleteShopUseCaseProvider.overrideWithProvider(
          Provider.autoDispose<DeleteShopUseCase>((ref) => deleteShopUseCase),
        ),
        filterShopsByKeywordUseCaseProvider.overrideWithProvider(
          Provider.autoDispose<FilterShopsByKeywordUseCase>(
              (ref) => filterShopsByKeywordUseCase),
        ),
        sortShopsUseCaseProvider.overrideWithProvider(
          Provider.autoDispose<SortShopsUseCase>((ref) => sortShopsUseCase),
        ),
      ];

      when(createShopUseCase.call(any))
          .thenAnswer((realInvocation) async => Result.success(shop1));
    });

    group('初期状態', () {
      testWidgets('商品が存在しない場合、検索欄が表示されず、データ登録を促すメッセージが表示されること',
          (WidgetTester tester) async {
        when(getShopsUseCase.call(any))
            .thenAnswer((realInvocation) async => Result.success([]));
        when(filterShopsByKeywordUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success([]));
        when(sortShopsUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success([]));

        await tester.pumpAppWidget(
            ShopListPage(title: title, isSelectable: true), overrides);

        final context = tester.getContext(ShopListPage);

        expect(find.text(title), findsOneWidget);
        expect(find.text(AppLocalizations.of(context)!.shopListNoData),
            findsOneWidget);
        expect(find.byType(SearchTextField), findsNothing);
      });

      testWidgets('商品が存在する場合、リスト表示されること', (WidgetTester tester) async {
        when(getShopsUseCase.call(any))
            .thenAnswer((realInvocation) async => Result.success(baseShops));
        when(filterShopsByKeywordUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success(baseShops));
        when(sortShopsUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success(baseShops));

        await tester.pumpAppWidget(
            ShopListPage(title: title, isSelectable: true), overrides);

        final context = tester.getContext(ShopListPage);

        await tester.pump();
        expect(find.text(title), findsOneWidget);
        expect(find.text(shop1.name), findsOneWidget);
        expect(find.text(shop2.name), findsOneWidget);
        expect(find.text(shop3.name), findsOneWidget);
        expect(find.text(AppLocalizations.of(context)!.shopListNoData),
            findsNothing);
        expect(find.byType(SearchTextField), findsOneWidget);

        // ソートアイコンタップ
        await tester.tap(find.byIcon(Icons.swap_vert));
        await tester.pump();

        expect(
            find.byWidgetPredicate((widget) =>
                widget is Text &&
                widget.style?.color == AppColors.primary &&
                widget.data ==
                    AppLocalizations.of(context)!
                        .shopListSortByNewestCreatedAt),
            findsOneWidget);
        expect(
            find.byWidgetPredicate((widget) =>
                widget is Text &&
                widget.data ==
                    AppLocalizations.of(context)!
                        .shopListSortByOldestCreatedAt),
            findsOneWidget);
        expect(
            find.byWidgetPredicate((widget) =>
                widget is Text &&
                widget.data ==
                    AppLocalizations.of(context)!.shopListSortByName),
            findsOneWidget);
      });

      testWidgets('商品取得時に問題が発生した場合、エラーメッセージが表示されること',
          (WidgetTester tester) async {
        final exception = DomainException(ExceptionType.alreadyExists());

        when(getShopsUseCase.call(any))
            .thenAnswer((realInvocation) async => Result.failure(exception));
        when(filterShopsByKeywordUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success(baseShops));
        when(sortShopsUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success(baseShops));

        await tester.pumpAppWidget(
            ShopListPage(title: title, isSelectable: true), overrides);

        final context = tester.getContext(ShopListPage);

        await tester.pump();
        expect(find.text(exception.exceptionType().errorMessage(context)),
            findsOneWidget);
        expect(find.text(title), findsOneWidget);
        expect(find.text(AppLocalizations.of(context)!.shopListNoData),
            findsOneWidget);
        expect(find.byType(SearchTextField), findsNothing);
      });
    });

    group('絞り込み', () {
      testWidgets('検索欄に文字入力時、絞り込み・ソート処理が走ること', (WidgetTester tester) async {
        when(getShopsUseCase.call(any))
            .thenAnswer((realInvocation) async => Result.success(baseShops));
        when(filterShopsByKeywordUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success(baseShops));
        when(sortShopsUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success(baseShops));

        await tester.pumpAppWidget(
            ShopListPage(title: title, isSelectable: true), overrides);
        await tester.pump();

        // 名前入力
        await tester.enterText(find.byType(TextField), "a");
        await tester.pumpAndSettle(Duration(seconds: 1));

        verify(filterShopsByKeywordUseCase.call(
            FilterShopsByKeywordUseCaseParams(shops: baseShops, keyword: "a")));
        verify(sortShopsUseCase.call(SortShopsUseCaseParams(
            shops: baseShops, sortType: ShopSortType.newestCreatedAt())));
      });
    });

    group('ソート', () {
      testWidgets('ソート順変更時、ソート・絞り込み・ソート処理が走ること', (WidgetTester tester) async {
        when(getShopsUseCase.call(any))
            .thenAnswer((realInvocation) async => Result.success(baseShops));
        when(filterShopsByKeywordUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success(baseShops));
        when(sortShopsUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success(baseShops));

        await tester.pumpAppWidget(
            ShopListPage(title: title, isSelectable: true), overrides);
        await tester.pump();

        final context = tester.getContext(ShopListPage);

        // ソート順変更
        await tester.tap(find.byIcon(Icons.swap_vert));
        await tester.pumpAndSettle();
        await tester
            .tap(find.text(AppLocalizations.of(context)!.shopListSortByName));
        await tester.pump();

        // 文字色が変わることを確認
        await tester.tap(find.byIcon(Icons.swap_vert));
        await tester.pump();
        expect(
            find.byWidgetPredicate((widget) =>
                widget is Text &&
                widget.style?.color == AppColors.primary &&
                widget.data ==
                    AppLocalizations.of(context)!.shopListSortByName),
            findsOneWidget);

        // 処理が呼ばれることを確認
        verify(filterShopsByKeywordUseCase.call(
            FilterShopsByKeywordUseCaseParams(shops: baseShops, keyword: "")));
        verify(sortShopsUseCase.call(SortShopsUseCaseParams(
            shops: baseShops, sortType: ShopSortType.name())));
      });
    });

    group('登録', () {
      testWidgets('選択可能フラグがtrueの場合、登録後画面が閉じること', (WidgetTester tester) async {
        when(getShopsUseCase.call(any))
            .thenAnswer((realInvocation) async => Result.success(baseShops));
        when(filterShopsByKeywordUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success(baseShops));
        when(sortShopsUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success(baseShops));

        await tester.pumpAppWidget(
            ShopListPage(title: title, isSelectable: true), overrides);
        await tester.pump();

        final context = tester.getContext(ShopListPage);

        // 追加
        await tester.tap(find.byIcon(Icons.add));
        await tester.pumpAndSettle();
        expect(find.byType(CreateShopDialog), findsOneWidget);

        // 名前入力
        await tester.enterText(find.byType(TextFormField), "a");

        // 登録処理実行
        await tester.tap(find.text(AppLocalizations.of(context)!.commonAdd));
        await tester.pumpAndSettle();

        expect(find.byType(ShopListPage), findsNothing);

        verify(getShopsUseCase.call(any)).called(1);
      });

      testWidgets('選択可能フラグがfalseの場合、登録後画面が閉じず、再度商品取得処理が行われること',
          (WidgetTester tester) async {
        when(getShopsUseCase.call(any))
            .thenAnswer((realInvocation) async => Result.success(baseShops));
        when(filterShopsByKeywordUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success(baseShops));
        when(sortShopsUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success(baseShops));

        await tester.pumpAppWidget(
            ShopListPage(title: title, isSelectable: false), overrides);
        await tester.pump();

        final context = tester.getContext(ShopListPage);

        // 追加
        await tester.tap(find.byIcon(Icons.add));
        await tester.pumpAndSettle();

        expect(find.byType(CreateShopDialog), findsOneWidget);

        // 名前入力
        await tester.enterText(find.byType(TextFormField), "a");

        // 登録処理実行
        await tester.tap(find.text(AppLocalizations.of(context)!.commonAdd));
        await tester.pumpAndSettle();

        expect(find.byType(ShopListPage), findsOneWidget);

        verify(getShopsUseCase.call(any)).called(2);
      });
    });

    group('編集', () {
      testWidgets('編集ダイアログを開け、ダイアログを閉じた後に再度商品取得処理が行われること',
          (WidgetTester tester) async {
        when(getShopsUseCase.call(any))
            .thenAnswer((realInvocation) async => Result.success([shop1]));
        when(filterShopsByKeywordUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success([shop1]));
        when(sortShopsUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success([shop1]));

        await tester.pumpAppWidget(
            ShopListPage(title: title, isSelectable: true), overrides);
        await tester.pump();

        final context = tester.getContext(ShopListPage);

        // 編集ダイアログを表示
        await tester.tap(find.byIcon(Icons.adaptive.more));
        await tester.pumpAndSettle();
        await tester.tap(
          find.text(AppLocalizations.of(context)!.commonEdit),
        );
        await tester.pumpAndSettle();

        // 編集ダイアログで商品情報が表示
        expect(find.byType(UpdateShopDialog), findsOneWidget);
        expect(find.text(shop1.name), findsNWidgets(2));

        // 編集ダイアログを閉じる
        await tester.tap(find.text(AppLocalizations.of(context)!.commonCancel));
        await tester.pumpAndSettle();
        expect(find.byType(UpdateShopDialog), findsNothing);

        verify(getShopsUseCase.call(any)).called(2);
      });
    });

    group('削除', () {
      testWidgets('確認メッセージキャンセルで削除処理が行われないこと', (WidgetTester tester) async {
        when(getShopsUseCase.call(any))
            .thenAnswer((realInvocation) async => Result.success([shop1]));
        when(filterShopsByKeywordUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success([shop1]));
        when(sortShopsUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success([shop1]));

        await tester.pumpAppWidget(
            ShopListPage(title: title, isSelectable: true), overrides);
        await tester.pump();

        final context = tester.getContext(ShopListPage);

        // 削除確認メッセージ表示
        await tester.tap(find.byIcon(Icons.adaptive.more));
        await tester.pumpAndSettle();
        await tester.tap(
          find.text(AppLocalizations.of(context)!.commonDelete),
        );
        await tester.pumpAndSettle();

        // 確認メッセージでキャンセル
        await tester.tap(
          find.text(AppLocalizations.of(context)!.commonCancel),
        );
        await tester.pumpAndSettle();

        verifyNever(deleteShopUseCase.call(any));
      });

      testWidgets('確認メッセージOKで削除処理が行われること', (WidgetTester tester) async {
        when(getShopsUseCase.call(any))
            .thenAnswer((realInvocation) async => Result.success([shop1]));
        when(filterShopsByKeywordUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success([shop1]));
        when(sortShopsUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success([shop1]));
        when(deleteShopUseCase.call(any))
            .thenAnswer((realInvocation) async => Result.success(() {}));

        await tester.pumpAppWidget(
            ShopListPage(title: title, isSelectable: true), overrides);
        await tester.pump();

        final context = tester.getContext(ShopListPage);

        // 削除確認メッセージ表示
        await tester.tap(find.byIcon(Icons.adaptive.more));
        await tester.pumpAndSettle();
        await tester.tap(
          find.text(AppLocalizations.of(context)!.commonDelete),
        );
        await tester.pumpAndSettle();

        // 確認メッセージでOK
        await tester.tap(
          find.text(AppLocalizations.of(context)!.commonOk),
        );
        await tester.pumpAndSettle();

        verify(deleteShopUseCase.call(shop1)).called(1);
        verify(getShopsUseCase.call(any)).called(2);
      });

      testWidgets('削除処理で問題が発生した際にエラーが表示されること', (WidgetTester tester) async {
        final exception = DomainException(ExceptionType.alreadyExists());

        when(getShopsUseCase.call(any))
            .thenAnswer((realInvocation) async => Result.success([shop1]));
        when(filterShopsByKeywordUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success([shop1]));
        when(sortShopsUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success([shop1]));
        when(deleteShopUseCase.call(any))
            .thenAnswer((realInvocation) async => Result.failure(exception));

        await tester.pumpAppWidget(
            ShopListPage(title: title, isSelectable: true), overrides);
        await tester.pump();

        final context = tester.getContext(ShopListPage);

        // 削除確認メッセージ表示
        await tester.tap(find.byIcon(Icons.adaptive.more));
        await tester.pumpAndSettle();
        await tester.tap(
          find.text(AppLocalizations.of(context)!.commonDelete),
        );
        await tester.pumpAndSettle();

        // 確認メッセージでOK
        await tester.tap(
          find.text(AppLocalizations.of(context)!.commonOk),
        );
        await tester.pumpAndSettle();

        expect(find.text(exception.exceptionType().errorMessage(context)),
            findsOneWidget);
        verify(deleteShopUseCase.call(shop1)).called(1);
      });
    });

    group('選択', () {
      testWidgets('選択可能フラグがtrueの場合、商品タップで画面が閉じること',
          (WidgetTester tester) async {
        when(getShopsUseCase.call(any))
            .thenAnswer((realInvocation) async => Result.success([shop1]));
        when(filterShopsByKeywordUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success([shop1]));
        when(sortShopsUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success([shop1]));

        await tester.pumpAppWidget(
            ShopListPage(title: title, isSelectable: true), overrides);
        await tester.pump();

        // 商品タップ
        await tester.tap(find.text(shop1.name));
        await tester.pumpAndSettle();

        expect(find.byType(ShopListPage), findsNothing);
      });

      testWidgets('選択可能フラグがfalseの場合、商品タップで画面が閉じないこと',
          (WidgetTester tester) async {
        when(getShopsUseCase.call(any))
            .thenAnswer((realInvocation) async => Result.success([shop1]));
        when(filterShopsByKeywordUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success([shop1]));
        when(sortShopsUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success([shop1]));

        await tester.pumpAppWidget(
            ShopListPage(title: title, isSelectable: false), overrides);
        await tester.pump();

        // 商品タップ
        await tester.tap(find.text(shop1.name));
        await tester.pumpAndSettle();

        expect(find.byType(ShopListPage), findsOneWidget);
      });
    });

    group('メニュー', () {
      testWidgets('選択可能フラグがtrueの場合、メニューバーが存在しないこと',
          (WidgetTester tester) async {
        when(getShopsUseCase.call(any))
            .thenAnswer((realInvocation) async => Result.success([shop1]));
        when(filterShopsByKeywordUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success([shop1]));
        when(sortShopsUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success([shop1]));

        await tester.pumpAppWidget(
            ShopListPage(title: title, isSelectable: true), overrides);
        await tester.pump();

        expect(find.byIcon(Icons.menu), findsNothing);
      });

      testWidgets('選択可能フラグがfalseの場合、メニューを表示できること', (WidgetTester tester) async {
        when(getShopsUseCase.call(any))
            .thenAnswer((realInvocation) async => Result.success([shop1]));
        when(filterShopsByKeywordUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success([shop1]));
        when(sortShopsUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success([shop1]));

        await tester.pumpAppWidget(
            ShopListPage(title: title, isSelectable: false), overrides);
        await tester.pump();

        final context = tester.getContext(ShopListPage);

        expect(find.byIcon(Icons.menu), findsOneWidget);

        // メニュータップ
        await tester.tap(find.byIcon(Icons.menu));
        await tester.pumpAndSettle();

        // メニュー上の表示状態を確認
        expect(find.byType(AppDrawer), findsOneWidget);
        expect(
            find.byWidgetPredicate((widget) =>
                widget is Text &&
                widget.style?.color == AppColors.primary &&
                widget.data == AppLocalizations.of(context)!.commonShop),
            findsOneWidget);
      });
    });
  });
}
