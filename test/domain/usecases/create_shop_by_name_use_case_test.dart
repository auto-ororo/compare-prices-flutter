import 'package:compare_prices/domain/exception/domain_exception.dart';
import 'package:compare_prices/domain/exception/exception_type.dart';
import 'package:compare_prices/domain/models/shop.dart';
import 'package:compare_prices/domain/repositories/shop_repository.dart';
import 'package:compare_prices/domain/usecases/create_shop_by_name_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../helper.dart';
import 'create_shop_by_name_use_case_test.mocks.dart';

@GenerateMocks([ShopRepository])
void main() {
  group('CreateShopByNameUseCase', () {
    final repository = MockShopRepository();

    group('call', () {
      final shopName = "name";

      test('名前が重複する場合、既に存在する旨のエラーとなること', () async {
        when(repository.getShopByName(shopName)).thenAnswer(
          (realInvocation) async => Shop.createByName(
            shopName,
          ),
        );

        final container =
            getDisposableProviderContainer(shopRepository: repository);

        final useCase = CreateShopByNameUseCase(container.read);
        final result = await useCase(shopName);

        expect(
            result.exception, DomainException(ExceptionType.alreadyExists()));
        verifyNever(repository.createShop(any));
      });

      test('名前が重複しない場合、Paramの通りに作成されること', () async {
        when(repository.getShopByName(shopName))
            .thenAnswer((realInvocation) async => null);

        final container =
            getDisposableProviderContainer(shopRepository: repository);

        final useCase = CreateShopByNameUseCase(container.read);
        final result = (await useCase(shopName)).dataOrThrow;

        expect(result.name, shopName);
        final capturedArgument =
            verify(repository.createShop(captureAny)).captured.first as Shop;
        expect(capturedArgument, result);
      });
    });
  });
}
