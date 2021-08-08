import 'package:compare_prices/domain/exception/domain_exception.dart';
import 'package:compare_prices/domain/exception/exception_type.dart';
import 'package:compare_prices/domain/models/bottom_price.dart';
import 'package:compare_prices/domain/models/bottom_price_sort_type.dart';
import 'package:compare_prices/domain/models/commodity.dart';
import 'package:compare_prices/domain/models/quantity_type.dart';
import 'package:compare_prices/domain/models/result.dart';
import 'package:compare_prices/domain/models/shop.dart';
import 'package:compare_prices/domain/usecases/filter_bottom_prices_by_keyword_use_case.dart';
import 'package:compare_prices/domain/usecases/get_bottom_prices_use_case.dart';
import 'package:compare_prices/domain/usecases/get_commodity_prices_in_ascending_order_use_case.dart';
import 'package:compare_prices/domain/usecases/sort_bottom_prices_use_case.dart';
import 'package:compare_prices/ui/assets/color/app_colors.dart';
import 'package:compare_prices/ui/common/extensions/exception_type_extensions.dart';
import 'package:compare_prices/ui/common/search_text_field.dart';
import 'package:compare_prices/ui/drawer/app_drawer.dart';
import 'package:compare_prices/ui/price/bottom/bottom_price_list_page.dart';
import 'package:compare_prices/ui/price/commodity/commodity_price_list_page.dart';
import 'package:compare_prices/ui/purchase_result/create/create_purchase_result_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/mockito.dart';

import '../../../helper.dart';
import '../../../mocks/generate.mocks.dart';

void main() {
  group('BottomPriceListPage', () {
    late MockGetBottomPricesUseCase getBottomPricesUseCase;
    late MockFilterBottomPricesByKeywordUseCase
        filterBottomPricesByKeywordUseCase;
    late MockSortBottomPricesUseCase sortBottomPricesUseCase;
    late MockGetCommodityPricesInAscendingOrderUseCase
        getCommodityPricesInAscendingOrderUseCase;

    late List<Override> overrides;

    final commodity1 = Commodity.create("ca", QuantityType.gram());
    final commodity2 = Commodity.create("cb", QuantityType.gram());
    final commodity3 = Commodity.create("cc", QuantityType.gram());

    final shop1 = Shop.createByName("sa");
    final shop2 = Shop.createByName("sb");
    final shop3 = Shop.createByName("sc");

    final bottomPrice1 = BottomPrice(
      id: "1",
      commodity: commodity1,
      mostInexpensiveShop: shop1,
      price: 100,
      unitPrice: 50,
      quantity: 2,
      purchaseDate: DateTime.now(),
    );

    final bottomPrice2 = BottomPrice(
      id: "2",
      commodity: commodity2,
      mostInexpensiveShop: shop2,
      price: 150,
      unitPrice: 30,
      quantity: 5,
      purchaseDate: DateTime.now(),
    );

    final bottomPrice3 = BottomPrice(
      id: "3",
      commodity: commodity3,
      mostInexpensiveShop: shop3,
      price: 200,
      unitPrice: 20,
      quantity: 10,
      purchaseDate: DateTime.now(),
    );

    final baseBottomPrices = [bottomPrice1, bottomPrice2, bottomPrice3];

    setUp(() {
      getBottomPricesUseCase = MockGetBottomPricesUseCase();
      filterBottomPricesByKeywordUseCase =
          MockFilterBottomPricesByKeywordUseCase();
      sortBottomPricesUseCase = MockSortBottomPricesUseCase();
      getCommodityPricesInAscendingOrderUseCase =
          MockGetCommodityPricesInAscendingOrderUseCase();

      overrides = [
        getBottomPricesUseCaseProvider.overrideWithProvider(
          Provider.autoDispose<GetBottomPricesUseCase>(
              (ref) => getBottomPricesUseCase),
        ),
        filterBottomPricesByKeywordUseCaseProvider.overrideWithProvider(
          Provider.autoDispose<FilterBottomPricesByKeywordUseCase>(
              (ref) => filterBottomPricesByKeywordUseCase),
        ),
        sortBottomPricesUseCaseProvider.overrideWithProvider(
          Provider.autoDispose<SortBottomPricesUseCase>(
              (ref) => sortBottomPricesUseCase),
        ),
        getCommodityPricesInAscendingOrderUseCaseProvider.overrideWithProvider(
          Provider.autoDispose<GetCommodityPricesInAscendingOrderUseCase>(
              (ref) => getCommodityPricesInAscendingOrderUseCase),
        )
      ];
    });

    group('初期状態', () {
      testWidgets('底値が存在しない場合、検索欄が表示されず、データ登録を促すメッセージが表示されること',
          (WidgetTester tester) async {
        when(getBottomPricesUseCase.call(any))
            .thenAnswer((realInvocation) async => Result.success([]));
        when(filterBottomPricesByKeywordUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success([]));
        when(sortBottomPricesUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success([]));

        await tester.pumpAppWidget(BottomPriceListPage(), overrides);

        final context = tester.getContext(BottomPriceListPage);

        expect(find.text(AppLocalizations.of(context)!.bottomPriceListNoData),
            findsOneWidget);
        expect(find.byType(SearchTextField), findsNothing);
      });

      testWidgets('底値が存在する場合、リスト表示されること', (WidgetTester tester) async {
        when(getBottomPricesUseCase.call(any)).thenAnswer(
            (realInvocation) async => Result.success(baseBottomPrices));
        when(filterBottomPricesByKeywordUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success(baseBottomPrices));
        when(sortBottomPricesUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success(baseBottomPrices));

        await tester.pumpAppWidget(BottomPriceListPage(), overrides);

        final context = tester.getContext(BottomPriceListPage);

        await tester.pump();
        expect(find.text(bottomPrice1.commodity.name), findsOneWidget);
        expect(find.text(bottomPrice2.commodity.name), findsOneWidget);
        expect(find.text(bottomPrice3.commodity.name), findsOneWidget);
        expect(find.text(AppLocalizations.of(context)!.bottomPriceListNoData),
            findsNothing);
        expect(find.byType(SearchTextField), findsOneWidget);

        // ソートアイコンタップ
        await tester.tap(find.byIcon(Icons.swap_vert));
        await tester.pumpAndSettle();

        expect(
            find.byWidgetPredicate((widget) =>
                widget is Text &&
                widget.style?.color == AppColors.primary &&
                widget.data ==
                    AppLocalizations.of(context)!
                        .bottomPriceListSortByNewestPurchaseDate),
            findsOneWidget);
        expect(
            find.byWidgetPredicate((widget) =>
                widget is Text &&
                widget.data ==
                    AppLocalizations.of(context)!
                        .bottomPriceListSortByCommodityName),
            findsOneWidget);
        expect(
            find.byWidgetPredicate((widget) =>
                widget is Text &&
                widget.data ==
                    AppLocalizations.of(context)!
                        .bottomPriceListSortByShopName),
            findsOneWidget);
        expect(
            find.byWidgetPredicate((widget) =>
                widget is Text &&
                widget.data ==
                    AppLocalizations.of(context)!
                        .bottomPriceListSortByOldestPurchaseDate),
            findsOneWidget);
        expect(
            find.byWidgetPredicate((widget) =>
                widget is Text &&
                widget.data ==
                    AppLocalizations.of(context)!.bottomPriceListSortByPrice),
            findsOneWidget);
      });

      testWidgets('底値取得時に問題が発生した場合、エラーメッセージが表示されること',
          (WidgetTester tester) async {
        final exception = DomainException(ExceptionType.alreadyExists());

        when(getBottomPricesUseCase.call(any))
            .thenAnswer((realInvocation) async => Result.failure(exception));
        when(filterBottomPricesByKeywordUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success(baseBottomPrices));
        when(sortBottomPricesUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success(baseBottomPrices));

        await tester.pumpAppWidget(BottomPriceListPage(), overrides);

        final context = tester.getContext(BottomPriceListPage);

        await tester.pump();
        expect(find.text(exception.exceptionType().errorMessage(context)),
            findsOneWidget);
        expect(find.text(AppLocalizations.of(context)!.bottomPriceListNoData),
            findsOneWidget);
        expect(find.byType(SearchTextField), findsNothing);
      });
    });

    group('絞り込み', () {
      testWidgets('検索欄に文字入力時、絞り込み・ソート処理が走ること', (WidgetTester tester) async {
        when(getBottomPricesUseCase.call(any)).thenAnswer(
            (realInvocation) async => Result.success(baseBottomPrices));
        when(filterBottomPricesByKeywordUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success(baseBottomPrices));
        when(sortBottomPricesUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success(baseBottomPrices));

        await tester.pumpAppWidget(BottomPriceListPage(), overrides);
        await tester.pump();

        // 名前入力
        await tester.enterText(find.byType(TextField), "a");
        await tester.pumpAndSettle(Duration(seconds: 1));

        verify(filterBottomPricesByKeywordUseCase.call(
            FilterBottomPricesByKeywordUseCaseParams(
                bottomPrices: baseBottomPrices, keyword: "a")));
        verify(sortBottomPricesUseCase.call(SortBottomPricesUseCaseParams(
            bottomPrices: baseBottomPrices,
            sortType: BottomPriceSortType.newestPurchaseDate())));
      });
    });

    group('ソート', () {
      testWidgets('ソート順変更時、ソート・絞り込み・ソート処理が走ること', (WidgetTester tester) async {
        when(getBottomPricesUseCase.call(any)).thenAnswer(
            (realInvocation) async => Result.success(baseBottomPrices));
        when(filterBottomPricesByKeywordUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success(baseBottomPrices));
        when(sortBottomPricesUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success(baseBottomPrices));

        await tester.pumpAppWidget(BottomPriceListPage(), overrides);
        await tester.pump();

        final context = tester.getContext(BottomPriceListPage);

        // ソート順変更
        await tester.tap(find.byIcon(Icons.swap_vert));
        await tester.pumpAndSettle();
        await tester.tap(find
            .text(AppLocalizations.of(context)!.bottomPriceListSortByShopName));
        await tester.pump();

        // 文字色が変わることを確認
        await tester.tap(find.byIcon(Icons.swap_vert));
        await tester.pump();
        expect(
            find.byWidgetPredicate((widget) =>
                widget is Text &&
                widget.style?.color == AppColors.primary &&
                widget.data ==
                    AppLocalizations.of(context)!
                        .bottomPriceListSortByShopName),
            findsOneWidget);

        // 処理が呼ばれることを確認
        verify(filterBottomPricesByKeywordUseCase.call(
            FilterBottomPricesByKeywordUseCaseParams(
                bottomPrices: baseBottomPrices, keyword: "")));
        verify(sortBottomPricesUseCase.call(SortBottomPricesUseCaseParams(
            bottomPrices: baseBottomPrices,
            sortType: BottomPriceSortType.shop())));
      });
    });

    group('登録', () {
      testWidgets('登録画面に遷移し、復帰後に底値の再検索が走ること', (WidgetTester tester) async {
        when(getBottomPricesUseCase.call(any)).thenAnswer(
            (realInvocation) async => Result.success(baseBottomPrices));
        when(filterBottomPricesByKeywordUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success(baseBottomPrices));
        when(sortBottomPricesUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success(baseBottomPrices));

        await tester.pumpAppWidget(BottomPriceListPage(), overrides);
        await tester.pump();

        // 追加
        await tester.tap(find.byIcon(Icons.add));
        await tester.pumpAndSettle();
        expect(find.byType(CreatePurchaseResultPage), findsOneWidget);

        final context = tester.getContext(CreatePurchaseResultPage);

        Navigator.of(context).pop();
        await tester.pumpAndSettle();

        verify(getBottomPricesUseCase.call(any)).called(2);
      });
    });

    group('選択', () {
      testWidgets('商品毎の価格ランキング画面に遷移し、復帰後に底値の再検索が走ること',
          (WidgetTester tester) async {
        when(getBottomPricesUseCase.call(any)).thenAnswer(
            (realInvocation) async => Result.success([bottomPrice1]));
        when(filterBottomPricesByKeywordUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success([bottomPrice1]));
        when(sortBottomPricesUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success([bottomPrice1]));
        when(getCommodityPricesInAscendingOrderUseCase.call(any))
            .thenAnswer((realInvocation) async => Result.success([]));

        await tester.pumpAppWidget(BottomPriceListPage(), overrides);
        await tester.pump();

        // 商品タップ
        await tester.tap(find.text(commodity1.name));
        await tester.pumpAndSettle();

        expect(find.byType(BottomPriceListPage), findsNothing);
        expect(find.byType(CommodityPriceListPage), findsOneWidget);
        expect(find.text(commodity1.name), findsOneWidget);

        final context = tester.getContext(CommodityPriceListPage);

        Navigator.of(context).pop();
        await tester.pumpAndSettle();

        verify(getBottomPricesUseCase.call(any)).called(2);
      });
    });

    group('メニュー', () {
      testWidgets('メニューを表示できること', (WidgetTester tester) async {
        when(getBottomPricesUseCase.call(any)).thenAnswer(
            (realInvocation) async => Result.success([bottomPrice1]));
        when(filterBottomPricesByKeywordUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success([bottomPrice1]));
        when(sortBottomPricesUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success([bottomPrice1]));

        await tester.pumpAppWidget(BottomPriceListPage(), overrides);
        await tester.pump();

        final context = tester.getContext(BottomPriceListPage);

        // メニュータップ
        await tester.tap(find.byIcon(Icons.menu));
        await tester.pumpAndSettle();

        // メニュー上の表示状態を確認
        expect(find.byType(AppDrawer), findsOneWidget);
        expect(
            find.byWidgetPredicate((widget) =>
                widget is Text &&
                widget.style?.color == AppColors.primary &&
                widget.data == AppLocalizations.of(context)!.commonBottomPrice),
            findsOneWidget);
      });
    });
  });
}
