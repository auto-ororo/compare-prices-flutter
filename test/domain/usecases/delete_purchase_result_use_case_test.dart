import 'package:compare_prices/domain/exception/domain_exception.dart';
import 'package:compare_prices/domain/exception/exception_type.dart';
import 'package:compare_prices/domain/models/commodity.dart';
import 'package:compare_prices/domain/models/purchase_result.dart';
import 'package:compare_prices/domain/models/quantity_type.dart';
import 'package:compare_prices/domain/models/shop.dart';
import 'package:compare_prices/domain/usecases/delete_purchase_result_by_id_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helper.dart';
import '../../mocks/generated.mocks.dart';

void main() {
  group('DeletePurchaseResultUseCase', () {
    final repository = MockPurchaseResultRepository();
    group('call', () {
      final id = "id";

      test('Paramで渡されたIDに紐付くデータが存在する場合、削除されること', () async {
        final purchaseResult = PurchaseResult.create(
            commodity: Commodity.create("commodityName", QuantityType.count()),
            shop: Shop.createByName("shopName"),
            price: 100,
            quantity: 2,
            purchaseDate: DateTime.now());

        when(repository.getPurchaseResultById(id)).thenAnswer(
          (realInvocation) async => purchaseResult,
        );

        final container = getDisposableProviderContainer(
            purchaseResultRepository: repository);

        final useCase = DeletePurchaseResultByIdUseCase(container.read);
        final result = await useCase(id);

        final capturedArgument =
            verify(repository.deletePurchaseResult(captureAny)).captured.first
                as PurchaseResult;

        expect(result.isSuccess, true);
        expect(capturedArgument, purchaseResult);
      });

      test('Paramで渡されたIDに紐付くデータが存在しない場合、データが存在しない旨のエラーとなること', () async {
        when(repository.getPurchaseResultById(id)).thenAnswer(
          (realInvocation) async => null,
        );

        final container = getDisposableProviderContainer(
            purchaseResultRepository: repository);

        final useCase = DeletePurchaseResultByIdUseCase(container.read);
        final result = await useCase(id);

        expect(result.exception, DomainException(ExceptionType.notFound()));
        verifyNever(repository.deletePurchaseResult(any));
      });
    });
  });
}
