import 'package:compare_prices/domain/models/commodity.dart';
import 'package:compare_prices/domain/models/quantity_type.dart';
import 'package:compare_prices/domain/usecases/get_commodities_use_case.dart';
import 'package:compare_prices/domain/usecases/use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helper.dart';
import '../../mocks/generated.mocks.dart';

void main() {
  group('GetCommoditiesUseCase', () {
    group('call', () {
      test('正しく取得できること', () async {
        final commodityRepository = MockCommodityRepository();

        final container = getDisposableProviderContainer(
            commodityRepository: commodityRepository);
        final useCase = GetCommoditiesUseCase(container.read);

        final commodities = [
          Commodity.create("a", QuantityType.count()),
          Commodity.create("b", QuantityType.count())
        ];

        when(commodityRepository.getCommodities())
            .thenAnswer((realInvocation) async => commodities);

        final result = await useCase(NoParam());

        expect(result.dataOrThrow, commodities);
      });
    });
  });
}
