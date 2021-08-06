import 'package:compare_prices/domain/models/bottom_price.dart';
import 'package:compare_prices/domain/models/commodity.dart';
import 'package:compare_prices/domain/models/quantity_type.dart';
import 'package:compare_prices/domain/models/shop.dart';
import 'package:compare_prices/domain/usecases/filter_bottom_prices_by_keyword_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FilterBottomPricesByKeywordUseCase', () {
    final bottomPrice1 = BottomPrice(
      id: "1",
      commodity: Commodity.create("a", QuantityType.count()),
      mostInexpensiveShop: Shop.createByName("b"),
      price: 100,
      unitPrice: 20,
      quantity: 5,
      purchaseDate: DateTime.now(),
    );

    final bottomPrice2 = BottomPrice(
      id: "2",
      commodity: Commodity.create("b", QuantityType.count()),
      mostInexpensiveShop: Shop.createByName("c"),
      price: 100,
      unitPrice: 20,
      quantity: 5,
      purchaseDate: DateTime.now(),
    );

    final bottomPrice3 = BottomPrice(
      id: "3",
      commodity: Commodity.create("a", QuantityType.count()),
      mostInexpensiveShop: Shop.createByName("c"),
      price: 100,
      unitPrice: 20,
      quantity: 5,
      purchaseDate: DateTime.now(),
    );

    final bottomPrices = [bottomPrice1, bottomPrice2, bottomPrice3];

    group('call', () {
      test('キーワードがない', () async {
        final useCase = FilterBottomPricesByKeywordUseCase();
        final result = await useCase(FilterBottomPricesByKeywordUseCaseParams(
            bottomPrices: bottomPrices, keyword: ""));

        expect(result.dataOrThrow, bottomPrices);
      });

      test('キーワードが商品名に含まれる', () async {
        final useCase = FilterBottomPricesByKeywordUseCase();
        final result = await useCase(FilterBottomPricesByKeywordUseCaseParams(
            bottomPrices: bottomPrices, keyword: "a"));

        expect(result.dataOrThrow, [bottomPrice1, bottomPrice3]);
      });

      test('キーワードが商品名と店舗名に含まれる', () async {
        final useCase = FilterBottomPricesByKeywordUseCase();
        final result = await useCase(FilterBottomPricesByKeywordUseCaseParams(
            bottomPrices: bottomPrices, keyword: "b"));

        expect(result.dataOrThrow, [bottomPrice1, bottomPrice2]);
      });

      test('キーワードが店舗名に含まれる', () async {
        final useCase = FilterBottomPricesByKeywordUseCase();
        final result = await useCase(FilterBottomPricesByKeywordUseCaseParams(
            bottomPrices: bottomPrices, keyword: "c"));

        expect(result.dataOrThrow, [bottomPrice2, bottomPrice3]);
      });

      test('キーワードに含まれる商品名、店舗名が存在しない', () async {
        final useCase = FilterBottomPricesByKeywordUseCase();
        final result = await useCase(FilterBottomPricesByKeywordUseCaseParams(
            bottomPrices: bottomPrices, keyword: "d"));

        expect(result.dataOrThrow, []);
      });
    });
  });
}
