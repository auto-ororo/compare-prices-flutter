import 'package:compare_prices/domain/models/result.dart';
import 'package:compare_prices/domain/usecases/get_bottom_prices_use_case.dart';
import 'package:compare_prices/domain/usecases/get_commodities_use_case.dart';
import 'package:compare_prices/domain/usecases/get_purchase_results_use_case.dart';
import 'package:compare_prices/domain/usecases/get_shops_use_case.dart';
import 'package:compare_prices/ui/commodity/list/commodity_list_page.dart';
import 'package:compare_prices/ui/drawer/app_drawer.dart';
import 'package:compare_prices/ui/price/bottom/bottom_price_list_page.dart';
import 'package:compare_prices/ui/purchase_result/list/purchase_result_list_page.dart';
import 'package:compare_prices/ui/route.dart';
import 'package:compare_prices/ui/shop/list/shop_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/mockito.dart';

import '../../helper.dart';
import '../../mocks/generate.mocks.dart';

void main() {
  group('AppDrawer', () {
    late MockGetBottomPricesUseCase getBottomPricesUseCase;
    late MockGetCommoditiesUseCase getCommoditiesUseCase;
    late MockGetShopsUseCase getShopsUseCase;
    late MockGetPurchaseResultsUseCase getPurchaseResultsUseCase;

    late List<Override> overrides;

    setUp(() {
      getBottomPricesUseCase = MockGetBottomPricesUseCase();
      getCommoditiesUseCase = MockGetCommoditiesUseCase();
      getShopsUseCase = MockGetShopsUseCase();
      getPurchaseResultsUseCase = MockGetPurchaseResultsUseCase();

      overrides = [
        getBottomPricesUseCaseProvider.overrideWithProvider(
          Provider.autoDispose<GetBottomPricesUseCase>(
              (ref) => getBottomPricesUseCase),
        ),
        getCommoditiesUseCaseProvider.overrideWithProvider(
          Provider.autoDispose<GetCommoditiesUseCase>(
              (ref) => getCommoditiesUseCase),
        ),
        getShopsUseCaseProvider.overrideWithProvider(
          Provider.autoDispose<GetShopsUseCase>((ref) => getShopsUseCase),
        ),
        getPurchaseResultsUseCaseProvider.overrideWithProvider(
          Provider.autoDispose<GetPurchaseResultsUseCase>(
              (ref) => getPurchaseResultsUseCase),
        )
      ];
    });

    group('遷移', () {
      testWidgets('底値一覧に遷移できること', (WidgetTester tester) async {
        when(getBottomPricesUseCase.call(any))
            .thenAnswer((realInvocation) async => Result.success([]));

        await tester.pumpAppWidget(
            AppDrawer(currentRoute: RouteName.licensePage), overrides);

        final context = tester.getContext(AppDrawer);

        await tester
            .tap(find.text(AppLocalizations.of(context)!.commonBottomPrice));
        await tester.pumpAndSettle();

        expect(find.byType(BottomPriceListPage), findsOneWidget);
      });

      testWidgets('商品一覧に遷移できること', (WidgetTester tester) async {
        when(getCommoditiesUseCase.call(any))
            .thenAnswer((realInvocation) async => Result.success([]));

        await tester.pumpAppWidget(
            AppDrawer(currentRoute: RouteName.licensePage), overrides);

        final context = tester.getContext(AppDrawer);

        await tester
            .tap(find.text(AppLocalizations.of(context)!.commonCommodity));
        await tester.pumpAndSettle();

        expect(find.byType(CommodityListPage), findsOneWidget);
      });

      testWidgets('店舗一覧に遷移できること', (WidgetTester tester) async {
        when(getShopsUseCase.call(any))
            .thenAnswer((realInvocation) async => Result.success([]));

        await tester.pumpAppWidget(
            AppDrawer(currentRoute: RouteName.licensePage), overrides);

        final context = tester.getContext(AppDrawer);

        await tester.tap(find.text(AppLocalizations.of(context)!.commonShop));
        await tester.pumpAndSettle();

        expect(find.byType(ShopListPage), findsOneWidget);
      });

      testWidgets('登録履歴に遷移できること', (WidgetTester tester) async {
        when(getPurchaseResultsUseCase.call(any))
            .thenAnswer((realInvocation) async => Result.success([]));

        await tester.pumpAppWidget(
            AppDrawer(currentRoute: RouteName.licensePage), overrides);

        final context = tester.getContext(AppDrawer);

        await tester
            .tap(find.text(AppLocalizations.of(context)!.commonHistory));
        await tester.pumpAndSettle();

        expect(find.byType(PurchaseResultListPage), findsOneWidget);
      });

      testWidgets('ライセンス情報に遷移できること', (WidgetTester tester) async {
        await tester.pumpAppWidget(
            AppDrawer(currentRoute: RouteName.commodityListPage), overrides);

        final context = tester.getContext(AppDrawer);

        await tester
            .tap(find.text(AppLocalizations.of(context)!.commonLicense));
        await tester.pumpAndSettle();

        expect(find.byType(LicensePage), findsOneWidget);
      });

      testWidgets('表示中画面の場合は遷移処理が走らないこと', (WidgetTester tester) async {
        await tester.pumpAppWidget(
            AppDrawer(currentRoute: RouteName.commodityListPage), overrides);

        final context = tester.getContext(AppDrawer);

        await tester
            .tap(find.text(AppLocalizations.of(context)!.commonCommodity));
        await tester.pumpAndSettle();

        expect(find.byType(CommodityListPage), findsNothing);
      });
    });
  });
}
