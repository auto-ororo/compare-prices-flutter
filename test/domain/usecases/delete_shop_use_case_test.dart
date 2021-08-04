import 'package:compare_prices/domain/models/shop.dart';
import 'package:compare_prices/domain/repositories/shop_repository.dart';
import 'package:compare_prices/domain/usecases/delete_shop_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../helper.dart';
import 'delete_shop_use_case_test.mocks.dart';

@GenerateMocks([ShopRepository])
void main() {
  group('DeleteShopUseCase', () {
    final repository = MockShopRepository();
    group('call', () {
      final shop = Shop.createByName("name");

      test('Paramのデータが削除されること', () async {
        final container =
            getDisposableProviderContainer(shopRepository: repository);

        final useCase = DeleteShopUseCase(container.read);
        final result = await useCase(shop);

        final capturedArgument =
            verify(repository.deleteShop(captureAny)).captured.first as Shop;

        expect(result.isSuccess, true);
        expect(capturedArgument, shop);
      });
    });
  });
}
