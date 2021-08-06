import 'package:compare_prices/domain/models/shop.dart';
import 'package:compare_prices/domain/usecases/filter_shops_by_keyword_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FilterShopsByKeywordUseCase', () {
    final shop1 = Shop.createByName("a");
    final shop2 = Shop.createByName("b");

    final shops = [shop1, shop2];

    group('call', () {
      test('キーワードがない', () async {
        final useCase = FilterShopsByKeywordUseCase();
        final result = await useCase(
            FilterShopsByKeywordUseCaseParams(shops: shops, keyword: ""));

        expect(result.dataOrThrow, shops);
      });

      test('キーワードが店舗名に含まれる', () async {
        final useCase = FilterShopsByKeywordUseCase();
        final result = await useCase(
            FilterShopsByKeywordUseCaseParams(shops: shops, keyword: "a"));

        expect(result.dataOrThrow, [shop1]);
      });

      test('キーワードに含まれる店舗名が存在しない', () async {
        final useCase = FilterShopsByKeywordUseCase();
        final result = await useCase(
            FilterShopsByKeywordUseCaseParams(shops: shops, keyword: "c"));

        expect(result.dataOrThrow, []);
      });
    });
  });
}
