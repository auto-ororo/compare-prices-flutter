import 'package:compare_prices/domain/models/commodity.dart';
import 'package:compare_prices/domain/models/commodity_sort_type.dart';
import 'package:compare_prices/domain/models/quantity_type.dart';
import 'package:compare_prices/domain/usecases/sort_commodities_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SortCommoditiesUseCase', () {
    group('call', () {
      final useCase = SortCommoditiesUseCase();

      final now = DateTime.now();

      final commodity1 = Commodity(
          id: "1",
          name: "b",
          quantityType: QuantityType.count(),
          createdAt: DateTime(now.year, now.month, now.day + 1),
          updatedAt: now);

      final commodity2 = Commodity(
          id: "2",
          name: "c",
          quantityType: QuantityType.count(),
          createdAt: DateTime(now.year, now.month, now.day - 1),
          updatedAt: now);

      final commodity3 = Commodity(
          id: "3",
          name: "a",
          quantityType: QuantityType.count(),
          createdAt: now,
          updatedAt: now);

      final commodities = [commodity1, commodity2, commodity3];

      test('名前昇順', () async {
        final result = await useCase(SortCommoditiesUseCaseParams(
            commodities: commodities, sortType: CommoditySortType.name()));

        expect(result.dataOrThrow, [commodity3, commodity1, commodity2]);
      });

      test('追加日昇順', () async {
        final result = await useCase(SortCommoditiesUseCaseParams(
            commodities: commodities,
            sortType: CommoditySortType.oldestCreatedAt()));

        expect(result.dataOrThrow, [commodity2, commodity3, commodity1]);
      });

      test('追加日降順', () async {
        final result = await useCase(SortCommoditiesUseCaseParams(
            commodities: commodities,
            sortType: CommoditySortType.newestCreatedAt()));

        expect(result.dataOrThrow, [commodity1, commodity3, commodity2]);
      });
    });
  });
}
