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

    group('????????????', () {
      testWidgets('Param??????????????????????????????????????????????????????', (WidgetTester tester) async {
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

      testWidgets('????????????????????????????????????????????????????????????????????????????????????????????????',
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

    group('?????????????????????', () {
      testWidgets('Quantity???2????????????????????????????????????????????????', (WidgetTester tester) async {
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

      testWidgets('Quantity???1???????????????????????????????????????', (WidgetTester tester) async {
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

      testWidgets('1????????????????????????????????????', (WidgetTester tester) async {
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

      testWidgets('2????????????????????????????????????', (WidgetTester tester) async {
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

      testWidgets('3????????????????????????????????????', (WidgetTester tester) async {
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

      testWidgets('4?????????????????????????????????????????????', (WidgetTester tester) async {
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

    group('????????????', () {
      testWidgets('Switch???????????????????????????????????????????????????', (WidgetTester tester) async {
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

        // OFF ??? ON
        await tester.tap(find.byType(Switch));
        await tester.pumpAndSettle();
        // ?????????????????????????????????????????????????????????
        expect(find.text(commodityPrice3.shop.name), findsNothing);

        // ON ??? OFF
        await tester.tap(find.byType(Switch));
        await tester.pumpAndSettle();
        // ????????????????????????????????????
        expect(find.text(commodityPrice3.shop.name), findsOneWidget);

        verify(groupCommodityPricesByShopUseCase.call(baseCommodityPrices))
            .called(1);
      });
    });

    group('??????', () {
      testWidgets('????????????????????????????????????????????????????????????????????????', (WidgetTester tester) async {
        when(getCommodityPricesInAscendingOrderUseCase.call(any)).thenAnswer(
            (realInvocation) async => Result.success(baseCommodityPrices));

        await tester.pumpAppWidget(
            CommodityPriceListPage(
              commodity: commodity,
            ),
            overrides);
        await tester.pump();

        // ??????
        await tester.tap(find.byIcon(Icons.add));
        await tester.pumpAndSettle();
        expect(find.byType(CreatePurchaseResultPage), findsOneWidget);

        final context = tester.getContext(CreatePurchaseResultPage);

        Navigator.of(context).pop();
        await tester.pumpAndSettle();

        verify(getCommodityPricesInAscendingOrderUseCase.call(any)).called(2);
      });
    });

    group('??????', () {
      testWidgets('???????????????????????????????????????????????????????????????????????????', (WidgetTester tester) async {
        when(getCommodityPricesInAscendingOrderUseCase.call(any)).thenAnswer(
            (realInvocation) async => Result.success([commodityPrice1]));
        when(deletePurchaseResultByIdUseCase.call(any))
            .thenAnswer((realInvocation) async => Result.success(() {}));

        await tester.pumpAppWidget(
            CommodityPriceListPage(commodity: commodity), overrides);
        await tester.pumpAndSettle();

        final context = tester.getContext(CommodityPriceListPage);

        // ?????????????????????????????????
        await tester.drag(
            find.text(commodityPrice1.shop.name), Offset(-500.0, 0.0));
        await tester.pumpAndSettle();
        await tester.tap(find.byIcon(Icons.delete));
        await tester.pumpAndSettle();

        // ???????????????????????????????????????
        await tester.tap(
          find.text(AppLocalizations.of(context)!.commonCancel),
        );
        await tester.pumpAndSettle();

        verifyNever(deletePurchaseResultByIdUseCase.call(any));
      });

      testWidgets('?????????????????????OK????????????????????????????????????', (WidgetTester tester) async {
        when(getCommodityPricesInAscendingOrderUseCase.call(any)).thenAnswer(
            (realInvocation) async => Result.success([commodityPrice1]));
        when(deletePurchaseResultByIdUseCase.call(any))
            .thenAnswer((realInvocation) async => Result.success(() {}));

        await tester.pumpAppWidget(
            CommodityPriceListPage(commodity: commodity), overrides);
        await tester.pumpAndSettle();

        final context = tester.getContext(CommodityPriceListPage);

        // ?????????????????????????????????
        await tester.drag(
            find.text(commodityPrice1.shop.name), Offset(-500.0, 0.0));
        await tester.pumpAndSettle();
        await tester.tap(find.byIcon(Icons.delete));
        await tester.pumpAndSettle();

        // ?????????????????????OK
        await tester.tap(
          find.text(AppLocalizations.of(context)!.commonOk),
        );
        await tester.pumpAndSettle();

        verify(deletePurchaseResultByIdUseCase
                .call(commodityPrice1.purchaseResultId))
            .called(1);
      });

      testWidgets('???????????????????????????????????????????????????????????????????????????', (WidgetTester tester) async {
        final exception = DomainException(ExceptionType.alreadyExists());
        when(getCommodityPricesInAscendingOrderUseCase.call(any)).thenAnswer(
            (realInvocation) async => Result.success([commodityPrice1]));
        when(deletePurchaseResultByIdUseCase.call(any))
            .thenAnswer((realInvocation) async => Result.failure(exception));

        await tester.pumpAppWidget(
            CommodityPriceListPage(commodity: commodity), overrides);
        await tester.pumpAndSettle();

        final context = tester.getContext(CommodityPriceListPage);

        // ?????????????????????????????????
        await tester.drag(
            find.text(commodityPrice1.shop.name), Offset(-500.0, 0.0));
        await tester.pumpAndSettle();
        await tester.tap(find.byIcon(Icons.delete));
        await tester.pumpAndSettle();

        // ?????????????????????OK
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
