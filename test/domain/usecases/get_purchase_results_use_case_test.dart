import 'package:compare_prices/domain/models/commodity.dart';
import 'package:compare_prices/domain/models/purchase_result.dart';
import 'package:compare_prices/domain/models/quantity_type.dart';
import 'package:compare_prices/domain/models/shop.dart';
import 'package:compare_prices/domain/usecases/get_purchase_results_use_case.dart';
import 'package:compare_prices/domain/usecases/use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helper.dart';
import '../../mocks/generated.mocks.dart';

void main() {
  group('GetPurchaseResultsUseCase', () {
    group('call', () {
      test('正しく取得できること', () async {
        final purchaseResultRepository = MockPurchaseResultRepository();

        final container = getDisposableProviderContainer(
            purchaseResultRepository: purchaseResultRepository);
        final useCase = GetPurchaseResultsUseCase(container.read);

        final purchaseResults = [
          PurchaseResult(
              id: "a",
              commodity: Commodity.create("a", QuantityType.count()),
              shop: Shop.createByName("a"),
              price: 100,
              quantity: 1,
              purchaseDate: DateTime.now(),
              createdAt: DateTime.now(),
              updatedAt: DateTime.now()),
          PurchaseResult(
              id: "b",
              commodity: Commodity.create("b", QuantityType.count()),
              shop: Shop.createByName("b"),
              price: 100,
              quantity: 1,
              purchaseDate: DateTime.now(),
              createdAt: DateTime.now(),
              updatedAt: DateTime.now()),
        ];

        when(purchaseResultRepository.getPurchaseResults())
            .thenAnswer((realInvocation) async => purchaseResults);

        final result = await useCase(NoParam());

        expect(result.dataOrThrow, purchaseResults);
      });
    });
  });
}
