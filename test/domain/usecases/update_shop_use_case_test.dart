import 'package:compare_prices/domain/exception/domain_exception.dart';
import 'package:compare_prices/domain/exception/exception_type.dart';
import 'package:compare_prices/domain/models/shop.dart';
import 'package:compare_prices/domain/usecases/update_shop_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helper.dart';
import '../../mocks/generated.mocks.dart';

void main() {
  group('UpdateShopUseCase', () {
    final repository = MockShopRepository();
    group('call', () {
      final shop = Shop.createByName("name");
      final storedShop = Shop.createByName("name2");

      test('名前が重複する店舗が別で存在する場合、既に存在する旨のエラーとなること', () async {
        when(repository.getShopByName(shop.name)).thenAnswer(
          (realInvocation) async => storedShop,
        );

        final container =
            getDisposableProviderContainer(shopRepository: repository);

        final useCase = UpdateShopUseCase(container.read);
        final result = await useCase(shop);

        expect(
            result.exception, DomainException(ExceptionType.alreadyExists()));
        verifyNever(repository.updateShop(any));
      });

      test('名前を変更していない場合、更新されないこと', () async {
        when(repository.getShopByName(shop.name)).thenAnswer(
          (realInvocation) async => shop,
        );

        final container =
            getDisposableProviderContainer(shopRepository: repository);

        final useCase = UpdateShopUseCase(container.read);
        final result = await useCase(shop);

        expect(result.isSuccess, true);
        verifyNever(repository.updateShop(any));
      });

      test('名前が重複しない場合、Paramの通りに更新されること', () async {
        when(repository.getShopByName(shop.name))
            .thenAnswer((realInvocation) async => null);

        final container =
            getDisposableProviderContainer(shopRepository: repository);

        final useCase = UpdateShopUseCase(container.read);
        final result = await useCase(shop);

        expect(result.isSuccess, true);

        final capturedArgument =
            verify(repository.updateShop(captureAny)).captured.first as Shop;
        expect(capturedArgument.id, shop.id);
        expect(capturedArgument.name, shop.name);
        expect(capturedArgument.createdAt, shop.createdAt);
        expect(capturedArgument.updatedAt.compareTo(shop.updatedAt), 1);
      });
    });
  });
}
