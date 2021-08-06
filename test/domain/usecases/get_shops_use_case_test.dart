import 'package:compare_prices/domain/models/shop.dart';
import 'package:compare_prices/domain/usecases/get_shops_use_case.dart';
import 'package:compare_prices/domain/usecases/use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helper.dart';
import '../../mocks/generated.mocks.dart';

void main() {
  group('GetShopsUseCase', () {
    group('call', () {
      test('正しく取得できること', () async {
        final shopRepository = MockShopRepository();

        final container =
            getDisposableProviderContainer(shopRepository: shopRepository);
        final useCase = GetShopsUseCase(container.read);

        final shops = [Shop.createByName("a"), Shop.createByName("b")];

        when(shopRepository.getShops())
            .thenAnswer((realInvocation) async => shops);

        final result = await useCase(NoParam());

        expect(result.dataOrThrow, shops);
      });
    });
  });
}
