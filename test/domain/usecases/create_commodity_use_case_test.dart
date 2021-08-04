import 'package:compare_prices/domain/exception/domain_exception.dart';
import 'package:compare_prices/domain/exception/exception_type.dart';
import 'package:compare_prices/domain/models/commodity.dart';
import 'package:compare_prices/domain/models/quantity_type.dart';
import 'package:compare_prices/domain/repositories/commodity_repository.dart';
import 'package:compare_prices/domain/usecases/create_commodity_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../helper.dart';
import 'create_commodity_use_case_test.mocks.dart';

@GenerateMocks([CommodityRepository])
void main() {
  group('CreateCommodityUseCase', () {
    final repository = MockCommodityRepository();
    group('call', () {
      final commodityName = "name";
      final quantityType = QuantityType.count();

      test('名前が重複する場合、既に存在する旨のエラーとなること', () async {
        when(repository.getCommodityByName(commodityName)).thenAnswer(
          (realInvocation) async => Commodity.create(
            commodityName,
            quantityType,
          ),
        );

        final container =
            getDisposableProviderContainer(commodityRepository: repository);

        final useCase = CreateCommodityUseCase(container.read);
        final result = await useCase(CreateCommodityUseCaseParams(
            name: commodityName, quantityType: quantityType));

        expect(
            result.exception, DomainException(ExceptionType.alreadyExists()));
      });

      test('名前が重複しない場合、Paramの通りに作成されること', () async {
        when(repository.getCommodityByName(commodityName))
            .thenAnswer((realInvocation) async => null);

        final container =
            getDisposableProviderContainer(commodityRepository: repository);

        final useCase = CreateCommodityUseCase(container.read);
        final result = (await useCase(CreateCommodityUseCaseParams(
                name: commodityName, quantityType: quantityType)))
            .dataOrThrow;

        expect(result.name, commodityName);
        expect(result.quantityType, quantityType);
        final capturedArgument = verify(repository.createCommodity(captureAny))
            .captured
            .first as Commodity;
        expect(capturedArgument, result);
      });
    });
  });
}
