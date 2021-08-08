import 'package:compare_prices/domain/exception/domain_exception.dart';
import 'package:compare_prices/domain/exception/exception_type.dart';
import 'package:compare_prices/domain/models/commodity.dart';
import 'package:compare_prices/domain/models/commodity_price.dart';
import 'package:compare_prices/domain/models/quantity_type.dart';
import 'package:compare_prices/domain/models/result.dart';
import 'package:compare_prices/domain/models/shop.dart';
import 'package:compare_prices/domain/usecases/delete_purchase_result_by_id_use_case.dart';
import 'package:compare_prices/domain/usecases/get_commodity_prices_in_ascending_order_use_case.dart';
import 'package:compare_prices/domain/usecases/group_commodity_prices_by_shop_use_case.dart';
import 'package:compare_prices/ui/common/extensions/exception_type_extensions.dart';
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
  group('CommodityPriceListPage', () {
    late MockGetCommodityPricesInAscendingOrderUseCase
        getCommodityPricesInAscendingOrderUseCase;
    late MockDeletePurchaseResultByIdUseCase deletePurchaseResultByIdUseCase;
    late MockGroupCommodityPricesByShopUseCase
        groupCommodityPricesByShopUseCase;

    late List<Override> overrides;

    final commodity = Commodity.create("ca", QuantityType.count());

    final shop1 = Shop.createByName("shopName1");
    final shop2 = Shop.createByName("shopName2");
    final shop3 = Shop.createByName("shopName3");
    final shop4 = Shop.createByName("shopName4");

    final commodityPrice1 = CommodityPrice(
      id: "1",
      commodity: commodity,
      shop: shop1,
      totalPrice: 100,
      unitPrice: 50,
      quantity: 2,
      purchaseDate: DateTime.now(),
      rank: 1,
      purchaseResultId: 'pa',
    );

    final commodityPrice2 = CommodityPrice(
      id: "2",
      commodity: commodity,
      shop: shop2,
      totalPrice: 200,
      unitPrice: 100,
      quantity: 2,
      purchaseDate: DateTime.now(),
      rank: 2,
      purchaseResultId: 'pb',
    );

    final commodityPrice3 = CommodityPrice(
      id: "3",
      commodity: commodity,
      shop: shop3,
      totalPrice: 300,
      unitPrice: 300,
      quantity: 1,
      purchaseDate: DateTime.now(),
      rank: 3,
      purchaseResultId: 'pc',
    );

    final commodityPrice4 = CommodityPrice(
      id: "4",
      commodity: commodity,
      shop: shop4,
      totalPrice: 300,
      unitPrice: 300,
      quantity: 1,
      purchaseDate: DateTime.now(),
      rank: 4,
      purchaseResultId: 'pd',
    );

    final baseCommodityPrices = [
      commodityPrice1,
      commodityPrice2,
      commodityPrice3,
      commodityPrice4
    ];

    setUp(() {
      getCommodityPricesInAscendingOrderUseCase =
          MockGetCommodityPricesInAscendingOrderUseCase();
      deletePurchaseResultByIdUseCase = MockDeletePurchaseResultByIdUseCase();
      groupCommodityPricesByShopUseCase =
          MockGroupCommodityPricesByShopUseCase();

      overrides = [
        getCommodityPricesInAscendingOrderUseCaseProvider.overrideWithProvider(
          Provider.autoDispose<GetCommodityPricesInAscendingOrderUseCase>(
              (ref) => getCommodityPricesInAscendingOrderUseCase),
        ),
        deletePurchaseResultByIdUseCaseProvider.overrideWithProvider(
          Provider.autoDispose<DeletePurchaseResultByIdUseCase>(
              (ref) => deletePurchaseResultByIdUseCase),
        ),
        groupCommodityPricesByShopUseCaseProvider.overrideWithProvider(
          Provider.autoDispose<GroupCommodityPricesByShopUseCase>(
              (ref) => groupCommodityPricesByShopUseCase),
        )
      ];
    });

    group('初期状態', () {
      testWidgets('Paramの商品名、価格リストが表示されること', (WidgetTester tester) async {
        when(getCommodityPricesInAscendingOrderUseCase.call(any)).thenAnswer(
            (realInvocation) async => Result.success(baseCommodityPrices));

        await tester.pumpAppWidget(
            CommodityPriceListPage(
              commodity: commodity,
            ),
            overrides);

        await tester.pumpAndSettle();
        expect(find.text(commodityPrice1.shop.name), findsOneWidget);
        expect(find.text(commodityPrice2.shop.name), findsOneWidget);
        expect(find.text(commodityPrice3.shop.name), findsOneWidget);
        expect(find.text(commodityPrice4.shop.name), findsOneWidget);

        expect(
            find.byWidgetPredicate(
                (widget) => widget is Switch && widget.value == false),
            findsOneWidget);
      });

      testWidgets('価格取得時に問題が発生した場合、エラーメッセージが表示されること',
          (WidgetTester tester) async {
        final exception = DomainException(ExceptionType.alreadyExists());

        when(getCommodityPricesInAscendingOrderUseCase.call(any))
            .thenAnswer((realInvocation) async => Result.failure(exception));

        await tester.pumpAppWidget(
            CommodityPriceListPage(
              commodity: commodity,
            ),
            overrides);

        final context = tester.getContext(CommodityPriceListPage);

        await tester.pump();
        expect(find.text(exception.exceptionType().errorMessage(context)),
            findsOneWidget);
      });
    });

    group('リストアイテム', () {
      testWidgets('Quantityが2個以上のとき、単価表示されること', (WidgetTester tester) async {
        when(getCommodityPricesInAscendingOrderUseCase.call(any)).thenAnswer(
            (realInvocation) async => Result.success([commodityPrice1]));

        await tester.pumpAppWidget(
            CommodityPriceListPage(
              commodity: commodity,
            ),
            overrides);
        await tester.pumpAndSettle();

        final context = tester.getContext(CommodityPriceListPage);

        expect(
            find.text(
              AppLocalizations.of(context)!.commonUnitWithSuffix(
                commodityPrice1.commodity.quantityType.unit().toString(),
                commodityPrice1.commodity.quantityType.suffix(context),
              ),
            ),
            findsOneWidget);
      });

      testWidgets('Quantityが1個のとき、単価表示されない', (WidgetTester tester) async {
        when(getCommodityPricesInAscendingOrderUseCase.call(any)).thenAnswer(
            (realInvocation) async => Result.success([commodityPrice3]));

        await tester.pumpAppWidget(
            CommodityPriceListPage(
              commodity: commodity,
            ),
            overrides);
        await tester.pumpAndSettle();

        final context = tester.getContext(CommodityPriceListPage);

        expect(
            find.text(
              AppLocalizations.of(context)!.commonUnitWithSuffix(
                commodityPrice3.commodity.quantityType.unit().toString(),
                commodityPrice3.commodity.quantityType.suffix(context),
              ),
            ),
            findsNothing);
      });

      testWidgets('1位の画像が表示されること', (WidgetTester tester) async {
        when(getCommodityPricesInAscendingOrderUseCase.call(any)).thenAnswer(
            (realInvocation) async => Result.success([commodityPrice1]));

        await tester.pumpAppWidget(
            CommodityPriceListPage(
              commodity: commodity,
            ),
            overrides);
        await tester.pumpAndSettle();

        expect(findByAssetImage("lib/ui/assets/image/crown_gold.png"),
            findsOneWidget);
      });

      testWidgets('2位の画像が表示されること', (WidgetTester tester) async {
        when(getCommodityPricesInAscendingOrderUseCase.call(any)).thenAnswer(
            (realInvocation) async => Result.success([commodityPrice2]));

        await tester.pumpAppWidget(
            CommodityPriceListPage(
              commodity: commodity,
            ),
            overrides);
        await tester.pumpAndSettle();

        expect(findByAssetImage("lib/ui/assets/image/crown_silver.png"),
            findsOneWidget);
      });

      testWidgets('3位の画像が表示されること', (WidgetTester tester) async {
        when(getCommodityPricesInAscendingOrderUseCase.call(any)).thenAnswer(
            (realInvocation) async => Result.success([commodityPrice3]));

        await tester.pumpAppWidget(
            CommodityPriceListPage(
              commodity: commodity,
            ),
            overrides);
        await tester.pumpAndSettle();

        expect(findByAssetImage("lib/ui/assets/image/crown_bronze.png"),
            findsOneWidget);
      });

      testWidgets('4位以下は画像が表示されないこと', (WidgetTester tester) async {
        when(getCommodityPricesInAscendingOrderUseCase.call(any)).thenAnswer(
            (realInvocation) async => Result.success([commodityPrice4]));

        await tester.pumpAppWidget(
            CommodityPriceListPage(
              commodity: commodity,
            ),
            overrides);
        await tester.pumpAndSettle();

        expect(findByAssetImage("lib/ui/assets/image/crown_gold.png"),
            findsNothing);
        expect(findByAssetImage("lib/ui/assets/image/crown_silver.png"),
            findsNothing);
        expect(findByAssetImage("lib/ui/assets/image/crown_bronze.png"),
            findsNothing);
      });
    });

    group('絞り込み', () {
      testWidgets('Switchの切り替えで絞り込み処理が走ること', (WidgetTester tester) async {
        final filteredCommodityPrices = [commodityPrice1, commodityPrice2];

        when(getCommodityPricesInAscendingOrderUseCase.call(any)).thenAnswer(
            (realInvocation) async => Result.success(baseCommodityPrices));
        when(groupCommodityPricesByShopUseCase.call(any)).thenAnswer(
            (realInvocation) => Result.success(filteredCommodityPrices));

        await tester.pumpAppWidget(
            CommodityPriceListPage(
              commodity: commodity,
            ),
            overrides);
        await tester.pump();

        // OFF → ON
        await tester.tap(find.byType(Switch));
        await tester.pumpAndSettle();
        // 絞り込みから外れたデータが表示されない
        expect(find.text(commodityPrice3.shop.name), findsNothing);

        // ON → OFF
        await tester.tap(find.byType(Switch));
        await tester.pumpAndSettle();
        // 絞り込み前のリストに戻る
        expect(find.text(commodityPrice3.shop.name), findsOneWidget);

        verify(groupCommodityPricesByShopUseCase.call(baseCommodityPrices))
            .called(1);
      });
    });

    group('登録', () {
      testWidgets('登録画面に遷移し、復帰後に底値の再検索が走ること', (WidgetTester tester) async {
        when(getCommodityPricesInAscendingOrderUseCase.call(any)).thenAnswer(
            (realInvocation) async => Result.success(baseCommodityPrices));

        await tester.pumpAppWidget(
            CommodityPriceListPage(
              commodity: commodity,
            ),
            overrides);
        await tester.pump();

        // 追加
        await tester.tap(find.byIcon(Icons.add));
        await tester.pumpAndSettle();
        expect(find.byType(CreatePurchaseResultPage), findsOneWidget);

        final context = tester.getContext(CreatePurchaseResultPage);

        Navigator.of(context).pop();
        await tester.pumpAndSettle();

        verify(getCommodityPricesInAscendingOrderUseCase.call(any)).called(2);
      });
    });

    group('削除', () {
      testWidgets('確認メッセージキャンセルで削除処理が行われないこと', (WidgetTester tester) async {
        when(getCommodityPricesInAscendingOrderUseCase.call(any)).thenAnswer(
            (realInvocation) async => Result.success([commodityPrice1]));
        when(deletePurchaseResultByIdUseCase.call(any))
            .thenAnswer((realInvocation) async => Result.success(() {}));

        await tester.pumpAppWidget(
            CommodityPriceListPage(commodity: commodity), overrides);
        await tester.pumpAndSettle();

        final context = tester.getContext(CommodityPriceListPage);

        // 削除確認メッセージ表示
        await tester.drag(
            find.text(commodityPrice1.shop.name), Offset(-500.0, 0.0));
        await tester.pumpAndSettle();
        await tester.tap(find.byIcon(Icons.delete));
        await tester.pumpAndSettle();

        // 確認メッセージでキャンセル
        await tester.tap(
          find.text(AppLocalizations.of(context)!.commonCancel),
        );
        await tester.pumpAndSettle();

        verifyNever(deletePurchaseResultByIdUseCase.call(any));
      });

      testWidgets('確認メッセージOKで削除処理が行われること', (WidgetTester tester) async {
        when(getCommodityPricesInAscendingOrderUseCase.call(any)).thenAnswer(
            (realInvocation) async => Result.success([commodityPrice1]));
        when(deletePurchaseResultByIdUseCase.call(any))
            .thenAnswer((realInvocation) async => Result.success(() {}));

        await tester.pumpAppWidget(
            CommodityPriceListPage(commodity: commodity), overrides);
        await tester.pumpAndSettle();

        final context = tester.getContext(CommodityPriceListPage);

        // 削除確認メッセージ表示
        await tester.drag(
            find.text(commodityPrice1.shop.name), Offset(-500.0, 0.0));
        await tester.pumpAndSettle();
        await tester.tap(find.byIcon(Icons.delete));
        await tester.pumpAndSettle();

        // 確認メッセージOK
        await tester.tap(
          find.text(AppLocalizations.of(context)!.commonOk),
        );
        await tester.pumpAndSettle();

        verify(deletePurchaseResultByIdUseCase
                .call(commodityPrice1.purchaseResultId))
            .called(1);
      });

      testWidgets('削除処理で問題が発生した際にエラーが表示されること', (WidgetTester tester) async {
        final exception = DomainException(ExceptionType.alreadyExists());
        when(getCommodityPricesInAscendingOrderUseCase.call(any)).thenAnswer(
            (realInvocation) async => Result.success([commodityPrice1]));
        when(deletePurchaseResultByIdUseCase.call(any))
            .thenAnswer((realInvocation) async => Result.failure(exception));

        await tester.pumpAppWidget(
            CommodityPriceListPage(commodity: commodity), overrides);
        await tester.pumpAndSettle();

        final context = tester.getContext(CommodityPriceListPage);

        // 削除確認メッセージ表示
        await tester.drag(
            find.text(commodityPrice1.shop.name), Offset(-500.0, 0.0));
        await tester.pumpAndSettle();
        await tester.tap(find.byIcon(Icons.delete));
        await tester.pumpAndSettle();

        // 確認メッセージOK
        await tester.tap(
          find.text(AppLocalizations.of(context)!.commonOk),
        );
        await tester.pumpAndSettle();

        expect(find.text(exception.exceptionType().errorMessage(context)),
            findsOneWidget);
        verify(deletePurchaseResultByIdUseCase
                .call(commodityPrice1.purchaseResultId))
            .called(1);
      });
    });
  });
}
