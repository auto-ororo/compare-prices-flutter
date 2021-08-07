import 'package:compare_prices/domain/models/bottom_price.dart';
import 'package:compare_prices/domain/models/commodity.dart';
import 'package:compare_prices/domain/models/purchase_result.dart';
import 'package:compare_prices/domain/models/quantity_type.dart';
import 'package:compare_prices/domain/models/shop.dart';
import 'package:compare_prices/domain/usecases/get_bottom_prices_use_case.dart';
import 'package:compare_prices/domain/usecases/use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helper.dart';
import '../../mocks/generate.mocks.dart';

void main() {
  group('GetBottomPricesUseCase', () {
    group('call', () {
      test('正しく取得できること', () async {
        final commodityRepository = MockCommodityRepository();
        final purchaseResultRepository = MockPurchaseResultRepository();

        final container = getDisposableProviderContainer(
            commodityRepository: commodityRepository,
            purchaseResultRepository: purchaseResultRepository);
        final useCase = GetBottomPricesUseCase(container.read);

        final commodity1 = Commodity.create("a", QuantityType.count());
        final commodity2 = Commodity.create("b", QuantityType.count());
        final commodity3 = Commodity.create("c", QuantityType.count());
        final commodity4 = Commodity.create("d", QuantityType.count());

        final shop1 = Shop.createByName("e");
        final shop2 = Shop.createByName("f");

        final purchaseResult1 = PurchaseResult(
            id: "g",
            commodity: commodity2,
            shop: shop1,
            price: 100,
            quantity: 1,
            purchaseDate: DateTime.now(),
            createdAt: DateTime.now(),
            updatedAt: DateTime.now());

        final purchaseResult2 = PurchaseResult(
            id: "h",
            commodity: commodity4,
            shop: shop2,
            price: 100,
            quantity: 1,
            purchaseDate: DateTime.now(),
            createdAt: DateTime.now(),
            updatedAt: DateTime.now());

        final purchaseResult3 = PurchaseResult(
            id: "i",
            commodity: commodity4,
            shop: shop2,
            price: 100,
            quantity: 1,
            purchaseDate: DateTime.now(),
            createdAt: DateTime.now(),
            updatedAt: DateTime.now());

        final newestPurchaseResult1 = PurchaseResult(
            id: "j",
            commodity: commodity2,
            shop: shop1,
            price: 100,
            quantity: 1,
            purchaseDate: DateTime.now(),
            createdAt: DateTime.now(),
            updatedAt: DateTime.now());

        final newestPurchaseResult2 = PurchaseResult(
            id: "k",
            commodity: commodity4,
            shop: shop2,
            price: 100,
            quantity: 1,
            purchaseDate: DateTime.now(),
            createdAt: DateTime.now(),
            updatedAt: DateTime.now());

        when(commodityRepository.getCommodities()).thenAnswer(
          (realInvocation) async =>
              [commodity1, commodity2, commodity3, commodity4],
        );

        final purchaseResultAnswersPerCommodityId = {
          commodity1.id: null,
          commodity2.id: purchaseResult1,
          commodity3.id: purchaseResult2,
          commodity4.id: purchaseResult3,
        };
        purchaseResultAnswersPerCommodityId.forEach((key, value) {
          when(purchaseResultRepository
                  .getMostInexpensivePurchaseResultPerUnitByCommodityId(key))
              .thenAnswer((realInvocation) async => value);
        });

        final newestPurchaseResultAnswersPerCommodityId = {
          commodity2.id: newestPurchaseResult1,
          commodity3.id: null,
          commodity4.id: newestPurchaseResult2,
        };
        newestPurchaseResultAnswersPerCommodityId.forEach((key, value) {
          when(purchaseResultRepository
                  .getNewestPurchaseResultByCommodityId(key))
              .thenAnswer((realInvocation) async => value);
        });

        final bottomPrice1 = BottomPrice(
          id: "0",
          commodity: commodity2,
          mostInexpensiveShop: shop1,
          price: purchaseResult1.price,
          unitPrice: purchaseResult1.unitPrice(),
          quantity: purchaseResult1.quantity,
          purchaseDate: newestPurchaseResult1.purchaseDate,
        );

        final bottomPrice2 = BottomPrice(
          id: "1",
          commodity: commodity4,
          mostInexpensiveShop: shop2,
          price: purchaseResult2.price,
          unitPrice: purchaseResult2.unitPrice(),
          quantity: purchaseResult2.quantity,
          purchaseDate: newestPurchaseResult2.purchaseDate,
        );

        final bottomPrices = [bottomPrice1, bottomPrice2];

        final result = await useCase(NoParam());

        expect(result.dataOrThrow, bottomPrices);
      });
    });
  });
}
