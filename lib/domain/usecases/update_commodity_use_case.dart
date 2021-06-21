import 'package:compare_prices/data/providers.dart';
import 'package:compare_prices/domain/entities/commodity.dart';
import 'package:compare_prices/domain/entities/result.dart';
import 'package:compare_prices/domain/repositories/commodity_repository.dart';
import 'package:compare_prices/domain/usecases/use_case.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final updateCommodityUseCaseProvider =
    Provider.autoDispose<UpdateCommodityUseCase>(
        (ref) => UpdateCommodityUseCase(ref.read));

class UpdateCommodityUseCase
    extends FutureUseCase<void, Commodity> {
  final Reader _reader;

  late final CommodityRepository _commodityRepository =
      _reader(commodityRepositoryProvider);

  UpdateCommodityUseCase(this._reader);

  @override
  Future<Result<void>> call(Commodity params) {
   return Result.guardFuture(() => _commodityRepository.updateCommodity(params));
  }
}
