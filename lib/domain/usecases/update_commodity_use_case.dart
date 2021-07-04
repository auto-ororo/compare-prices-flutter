import 'package:compare_prices/data/providers.dart';
import 'package:compare_prices/domain/entities/commodity.dart';
import 'package:compare_prices/domain/entities/result.dart';
import 'package:compare_prices/domain/exception/domain_exception.dart';
import 'package:compare_prices/domain/exception/exception_type.dart';
import 'package:compare_prices/domain/usecases/use_case.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final updateCommodityUseCaseProvider =
    Provider.autoDispose<UpdateCommodityUseCase>(
        (ref) => UpdateCommodityUseCase(ref.read));

class UpdateCommodityUseCase extends FutureUseCase<void, Commodity> {
  final Reader _reader;

  late final _commodityRepository = _reader(commodityRepositoryProvider);

  UpdateCommodityUseCase(this._reader);

  @override
  Future<Result<void>> call(Commodity params) {
    return Result.guardFuture(() async {
      final commodity =
          await _commodityRepository.getEnabledCommodityByName(params.name);

      // 別商品データに同名の商品名が存在した場合はエラー
      if (commodity != null) {
        if (commodity.id != params.id) {
          throw DomainException(ExceptionType.alreadyExists());
        }
        return;
      }

      _commodityRepository
          .updateCommodity(params.copyWith(updatedAt: DateTime.now()));
    });
  }
}
