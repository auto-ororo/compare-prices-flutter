import 'package:compare_prices/domain/models/bottom_price.dart';
import 'package:compare_prices/domain/models/bottom_price_sort_type.dart';
import 'package:compare_prices/domain/models/commodity.dart';
import 'package:compare_prices/domain/models/quantity_type.dart';
import 'package:compare_prices/domain/models/shop.dart';
import 'package:compare_prices/domain/usecases/sort_bottom_prices_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SortBottomPricesUseCase', () {
    group('call', () {
      final useCase = SortBottomPricesUseCase();

      final now = DateTime.now();

      final bottomPrice1 = BottomPrice(
        id: "0",
        commodity: Commodity.create("c", QuantityType.count()),
        mostInexpensiveShop: Shop.createByName("b"),
        price: 100,
        unitPrice: 100,
        quantity: 1,
        purchaseDate: DateTime(now.year, now.month, now.day),
      );

      final bottomPrice2 = BottomPrice(
        id: "1",
        commodity: Commodity.create("a", QuantityType.count()),
        mostInexpensiveShop: Shop.createByName("a"),
        price: 150,
        unitPrice: 150,
        quantity: 1,
        purchaseDate: DateTime(now.year, now.month, now.day - 1),
      );

      final bottomPrice3 = BottomPrice(
        id: "2",
        commodity: Commodity.create("b", QuantityType.count()),
        mostInexpensiveShop: Shop.createByName("c"),
        price: 130,
        unitPrice: 130,
        quantity: 1,
        purchaseDate: DateTime(now.year, now.month, now.day + 1),
      );

      final bottomPrices = [bottomPrice1, bottomPrice2, bottomPrice3];

      test('商品名昇順', () async {
        final result = await useCase(SortBottomPricesUseCaseParams(
            bottomPrices: bottomPrices,
            sortType: BottomPriceSortType.commodity()));

        expect(result.dataOrThrow, [bottomPrice2, bottomPrice3, bottomPrice1]);
      });

      test('店舗名昇順', () async {
        final result = await useCase(SortBottomPricesUseCaseParams(
            bottomPrices: bottomPrices, sortType: BottomPriceSortType.shop()));

        expect(result.dataOrThrow, [bottomPrice2, bottomPrice1, bottomPrice3]);
      });

      test('単価昇順', () async {
        final result = await useCase(SortBottomPricesUseCaseParams(
            bottomPrices: bottomPrices, sortType: BottomPriceSortType.price()));

        expect(result.dataOrThrow, [bottomPrice1, bottomPrice3, bottomPrice2]);
      });

      test('購入日昇順', () async {
        final result = await useCase(SortBottomPricesUseCaseParams(
            bottomPrices: bottomPrices,
            sortType: BottomPriceSortType.oldestPurchaseDate()));

        expect(result.dataOrThrow, [bottomPrice2, bottomPrice1, bottomPrice3]);
      });

      test('購入日降順', () async {
        final result = await useCase(SortBottomPricesUseCaseParams(
            bottomPrices: bottomPrices,
            sortType: BottomPriceSortType.newestPurchaseDate()));

        expect(result.dataOrThrow, [bottomPrice3, bottomPrice1, bottomPrice2]);
      });
    });
  });
}
