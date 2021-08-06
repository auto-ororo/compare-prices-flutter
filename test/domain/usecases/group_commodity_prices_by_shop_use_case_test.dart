import 'package:compare_prices/domain/models/commodity.dart';
import 'package:compare_prices/domain/models/commodity_price.dart';
import 'package:compare_prices/domain/models/quantity_type.dart';
import 'package:compare_prices/domain/models/shop.dart';
import 'package:compare_prices/domain/usecases/group_commodity_prices_by_shop_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GroupCommodityPricesByShopUseCase', () {
    group('call', () {
      test('店舗の重複が削除されて返却されること', () async {
        final shop1 = Shop.createByName("a");
        final shop2 = Shop.createByName("b");

        final commodityPrice1 = CommodityPrice(
            id: "1",
            commodity: Commodity.create("a", QuantityType.count()),
            purchaseResultId: "a",
            rank: 1,
            quantity: 1,
            totalPrice: 100,
            unitPrice: 100,
            shop: shop1,
            purchaseDate: DateTime.now());

        final commodityPrice2 = CommodityPrice(
            id: "2",
            commodity: Commodity.create("b", QuantityType.count()),
            purchaseResultId: "b",
            rank: 1,
            quantity: 1,
            totalPrice: 100,
            unitPrice: 100,
            shop: shop2,
            purchaseDate: DateTime.now());

        final commodityPrice3 = CommodityPrice(
            id: "3",
            commodity: Commodity.create("c", QuantityType.count()),
            purchaseResultId: "c",
            rank: 1,
            quantity: 1,
            totalPrice: 100,
            unitPrice: 100,
            shop: shop1,
            purchaseDate: DateTime.now());

        final commodityPrices = [
          commodityPrice1,
          commodityPrice2,
          commodityPrice3
        ];

        final useCase = GroupCommodityPricesByShopUseCase();
        final result = await useCase(commodityPrices);

        expect(result.dataOrThrow, [commodityPrice1, commodityPrice2]);
      });
    });
  });
}
