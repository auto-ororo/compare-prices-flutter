import 'package:compare_prices/data/providers.dart';
import 'package:compare_prices/domain/models/result.dart';
import 'package:compare_prices/domain/models/shop.dart';
import 'package:compare_prices/domain/usecases/use_case.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final deleteShopUseCaseProvider = Provider.autoDispose<DeleteShopUseCase>(
    (ref) => DeleteShopUseCase(ref.read));

class DeleteShopUseCase extends FutureUseCase<void, Shop> {
  final Reader _reader;

  late final _shopRepository = _reader(shopRepositoryProvider);

  DeleteShopUseCase(this._reader);

  @override
  Future<Result<void>> call(Shop params) {
    return Result.guardFuture(() => _shopRepository.deleteShop(params));
  }
}
