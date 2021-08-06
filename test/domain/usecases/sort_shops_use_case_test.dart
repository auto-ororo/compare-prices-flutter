import 'package:compare_prices/domain/models/shop.dart';
import 'package:compare_prices/domain/models/shop_sort_type.dart';
import 'package:compare_prices/domain/usecases/sort_shops_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SortShopsUseCase', () {
    group('call', () {
      final useCase = SortShopsUseCase();

      final now = DateTime.now();

      final shop1 = Shop(
          id: "1",
          name: "b",
          createdAt: DateTime(now.year, now.month, now.day + 1),
          updatedAt: now);

      final shop2 = Shop(
          id: "2",
          name: "c",
          createdAt: DateTime(now.year, now.month, now.day - 1),
          updatedAt: now);

      final shop3 = Shop(id: "3", name: "a", createdAt: now, updatedAt: now);

      final shops = [shop1, shop2, shop3];

      test('名前昇順', () async {
        final result = await useCase(SortShopsUseCaseParams(
            shops: shops, sortType: ShopSortType.name()));

        expect(result.dataOrThrow, [shop3, shop1, shop2]);
      });

      test('追加日昇順', () async {
        final result = await useCase(SortShopsUseCaseParams(
            shops: shops, sortType: ShopSortType.oldestCreatedAt()));

        expect(result.dataOrThrow, [shop2, shop3, shop1]);
      });

      test('追加日降順', () async {
        final result = await useCase(SortShopsUseCaseParams(
            shops: shops, sortType: ShopSortType.newestCreatedAt()));

        expect(result.dataOrThrow, [shop1, shop3, shop2]);
      });
    });
  });
}
