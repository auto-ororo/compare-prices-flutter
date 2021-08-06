import 'package:compare_prices/domain/models/commodity.dart';
import 'package:compare_prices/domain/models/quantity_type.dart';
import 'package:compare_prices/domain/usecases/filter_commodities_by_keyword_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FilterCommoditiesByKeywordUseCase', () {
    final commodity1 = Commodity.create("a", QuantityType.count());
    final commodity2 = Commodity.create("b", QuantityType.count());

    final commodities = [commodity1, commodity2];

    group('call', () {
      test('キーワードがない', () async {
        final useCase = FilterCommoditiesByKeywordUseCase();
        final result = await useCase(FilterCommoditiesByKeywordUseCaseParams(
            commodities: commodities, keyword: ""));

        expect(result.dataOrThrow, commodities);
      });

      test('キーワードが商品名に含まれる', () async {
        final useCase = FilterCommoditiesByKeywordUseCase();
        final result = await useCase(FilterCommoditiesByKeywordUseCaseParams(
            commodities: commodities, keyword: "a"));

        expect(result.dataOrThrow, [commodity1]);
      });

      test('キーワードに含まれる商品名が存在しない', () async {
        final useCase = FilterCommoditiesByKeywordUseCase();
        final result = await useCase(FilterCommoditiesByKeywordUseCaseParams(
            commodities: commodities, keyword: "c"));

        expect(result.dataOrThrow, []);
      });
    });
  });
}
