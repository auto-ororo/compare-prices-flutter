import 'package:compare_prices/domain/exception/domain_exception.dart';
import 'package:compare_prices/domain/exception/exception_type.dart';
import 'package:compare_prices/domain/models/commodity.dart';
import 'package:compare_prices/domain/models/quantity_type.dart';
import 'package:compare_prices/domain/usecases/update_commodity_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helper.dart';
import '../../mocks/generated.mocks.dart';

void main() {
  group('UpdateCommodityUseCase', () {
    final repository = MockCommodityRepository();
    group('call', () {
      final commodity = Commodity.create("name", QuantityType.count());
      final storedCommodity = Commodity.create("name2", QuantityType.count());

      test('名前が重複する商品が別で存在する場合、既に存在する旨のエラーとなること', () async {
        when(repository.getCommodityByName(commodity.name)).thenAnswer(
          (realInvocation) async => storedCommodity,
        );

        final container =
            getDisposableProviderContainer(commodityRepository: repository);

        final useCase = UpdateCommodityUseCase(container.read);
        final result = await useCase(commodity);

        expect(
            result.exception, DomainException(ExceptionType.alreadyExists()));
        verifyNever(repository.updateCommodity(any));
      });

      test('名前を変更していない場合、更新されないこと', () async {
        when(repository.getCommodityByName(commodity.name)).thenAnswer(
          (realInvocation) async => commodity,
        );

        final container =
            getDisposableProviderContainer(commodityRepository: repository);

        final useCase = UpdateCommodityUseCase(container.read);
        final result = await useCase(commodity);

        expect(result.isSuccess, true);
        verifyNever(repository.updateCommodity(any));
      });

      test('名前が重複しない場合、Paramの通りに更新されること', () async {
        when(repository.getCommodityByName(commodity.name))
            .thenAnswer((realInvocation) async => null);

        final container =
            getDisposableProviderContainer(commodityRepository: repository);

        final useCase = UpdateCommodityUseCase(container.read);
        final result = await useCase(commodity);

        expect(result.isSuccess, true);

        final capturedArgument = verify(repository.updateCommodity(captureAny))
            .captured
            .first as Commodity;
        expect(capturedArgument.id, commodity.id);
        expect(capturedArgument.name, commodity.name);
        expect(capturedArgument.quantityType, commodity.quantityType);
        expect(capturedArgument.createdAt, commodity.createdAt);
        expect(capturedArgument.updatedAt.compareTo(commodity.updatedAt), 1);
      });
    });
  });
}
