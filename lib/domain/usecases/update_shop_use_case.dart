import 'package:compare_prices/data/providers.dart';
import 'package:compare_prices/domain/exception/domain_exception.dart';
import 'package:compare_prices/domain/exception/exception_type.dart';
import 'package:compare_prices/domain/models/result.dart';
import 'package:compare_prices/domain/models/shop.dart';
import 'package:compare_prices/domain/usecases/use_case.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final updateShopUseCaseProvider = Provider.autoDispose<UpdateShopUseCase>(
    (ref) => UpdateShopUseCase(ref.read));

class UpdateShopUseCase extends FutureUseCase<void, Shop> {
  final Reader _reader;

  late final _shopRepository = _reader(shopRepositoryProvider);

  UpdateShopUseCase(this._reader);

  @override
  Future<Result<void>> call(Shop params) {
    return Result.guardFuture(() async {
      final shop = await _shopRepository.getShopByName(params.name);

      // 別商品データに同名の商品名が存在した場合はエラー
      if (shop != null) {
        if (shop.id != params.id) {
          throw DomainException(ExceptionType.alreadyExists());
        }
        return;
      }

      _shopRepository.updateShop(params.copyWith(updatedAt: DateTime.now()));
    });
  }
}
