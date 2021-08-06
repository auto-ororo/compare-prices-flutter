import 'package:compare_prices/domain/models/commodity.dart';
import 'package:compare_prices/domain/models/commodity_price.dart';
import 'package:compare_prices/domain/models/purchase_result.dart';
import 'package:compare_prices/domain/models/quantity_type.dart';
import 'package:compare_prices/domain/models/shop.dart';
import 'package:compare_prices/domain/usecases/get_commodity_prices_in_ascending_order_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helper.dart';
import '../../mocks/generated.mocks.dart';

void main() {
  group('GetCommodityPricesInAscendingOrderUseCase', () {
    group('call', () {
      test('単価順に取得できること', () async {
        final purchaseResultRepository = MockPurchaseResultRepository();

        final container = getDisposableProviderContainer(
            purchaseResultRepository: purchaseResultRepository);
        final useCase =
            GetCommodityPricesInAscendingOrderUseCase(container.read);

        final commodity = Commodity.create("a", QuantityType.count());

        final purchaseResult1 = PurchaseResult(
            id: "a",
            commodity: commodity,
            shop: Shop.createByName("a"),
            price: 150,
            quantity: 1,
            purchaseDate: DateTime.now(),
            createdAt: DateTime.now(),
            updatedAt: DateTime.now());

        final purchaseResult2 = PurchaseResult(
            id: "b",
            commodity: commodity,
            shop: Shop.createByName("a"),
            price: 50,
            quantity: 2,
            purchaseDate: DateTime.now(),
            createdAt: DateTime.now(),
            updatedAt: DateTime.now());

        final purchaseResult3 = PurchaseResult(
            id: "c",
            commodity: commodity,
            shop: Shop.createByName("a"),
            price: 100,
            quantity: 3,
            purchaseDate: DateTime.now(),
            createdAt: DateTime.now(),
            updatedAt: DateTime.now());

        final purchaseResults = [
          purchaseResult1,
          purchaseResult2,
          purchaseResult3
        ];

        when(purchaseResultRepository
                .getPurchaseResultsByCommodityId(commodity.id))
            .thenAnswer((realInvocation) async => purchaseResults);

        final result = await useCase(commodity);

        final commodityPrices = [
          CommodityPrice(
              id: "1",
              commodity: commodity,
              purchaseResultId: purchaseResult2.id,
              rank: 1,
              quantity: purchaseResult2.quantity,
              totalPrice: purchaseResult2.price,
              unitPrice: purchaseResult2.unitPrice(),
              shop: purchaseResult2.shop,
              purchaseDate: purchaseResult2.purchaseDate),
          CommodityPrice(
              id: "2",
              commodity: commodity,
              purchaseResultId: purchaseResult3.id,
              rank: 2,
              quantity: purchaseResult3.quantity,
              totalPrice: purchaseResult3.price,
              unitPrice: purchaseResult3.unitPrice(),
              shop: purchaseResult3.shop,
              purchaseDate: purchaseResult3.purchaseDate),
          CommodityPrice(
              id: "3",
              commodity: commodity,
              purchaseResultId: purchaseResult1.id,
              rank: 3,
              quantity: purchaseResult1.quantity,
              totalPrice: purchaseResult1.price,
              unitPrice: purchaseResult1.unitPrice(),
              shop: purchaseResult1.shop,
              purchaseDate: purchaseResult1.purchaseDate),
        ];

        expect(result.dataOrThrow, commodityPrices);
      });
    });
  });
}
