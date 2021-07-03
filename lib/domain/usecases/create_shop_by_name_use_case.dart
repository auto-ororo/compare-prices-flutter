import 'package:compare_prices/data/providers.dart';
import 'package:compare_prices/domain/entities/result.dart';
import 'package:compare_prices/domain/entities/shop.dart';
import 'package:compare_prices/domain/exception/domain_exception.dart';
import 'package:compare_prices/domain/usecases/use_case.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final createShopByNameUseCaseProvider =
    Provider.autoDispose<CreateShopByNameUseCase>(
        (ref) => CreateShopByNameUseCase(ref.read));

class CreateShopByNameUseCase extends FutureUseCase<void, String> {
  final Reader _reader;

  late final _shopRepository = _reader(shopRepositoryProvider);

  CreateShopByNameUseCase(this._reader);

  @override
  Future<Result<void>> call(String params) {
    return Result.guardFuture(() async {
      // 同名の店舗が存在した場合はエラー
      if (await _shopRepository.getEnabledShopByName(params) != null) {
        throw DomainException("すでにそんざいしてます");
      }

      final shop = Shop.createByName(params);

      _shopRepository.createShop(shop);
    });
  }
}
