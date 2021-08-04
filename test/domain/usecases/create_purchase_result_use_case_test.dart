import 'package:compare_prices/domain/models/commodity.dart';
import 'package:compare_prices/domain/models/purchase_result.dart';
import 'package:compare_prices/domain/models/quantity_type.dart';
import 'package:compare_prices/domain/models/shop.dart';
import 'package:compare_prices/domain/repositories/purchase_result_repository.dart';
import 'package:compare_prices/domain/usecases/create_purchase_result_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../helper.dart';
import 'create_purchase_result_use_case_test.mocks.dart';

@GenerateMocks([PurchaseResultRepository])
void main() {
  group('CreatePurchaseResultUseCase', () {
    final repository = MockPurchaseResultRepository();
    group('call', () {
      test('Paramの通りに作成されること', () async {
        final commodity =
            Commodity.create("commodityName", QuantityType.count());
        final shop = Shop.createByName("shopName");
        final price = 100;
        final quantity = 5;
        final purchaseDate = DateTime.now();

        final container = getDisposableProviderContainer(
            purchaseResultRepository: repository);

        final useCase = CreatePurchaseResultUseCase(container.read);
        final result = (await useCase(
          CreatePurchaseResultUseCaseParams(
            commodity: commodity,
            shop: shop,
            price: price,
            quantity: quantity,
            purchaseDate: purchaseDate,
          ),
        ))
            .dataOrThrow;

        expect(result.commodity, commodity);
        expect(result.shop, shop);
        expect(result.price, price);
        expect(result.quantity, quantity);
        final capturedArgument =
            verify(repository.createPurchaseResult(captureAny)).captured.first
                as PurchaseResult;
        expect(capturedArgument, result);
      });
    });
  });
}
