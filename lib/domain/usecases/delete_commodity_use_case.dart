import 'package:compare_prices/data/providers.dart';
import 'package:compare_prices/domain/entities/commodity.dart';
import 'package:compare_prices/domain/entities/result.dart';
import 'package:compare_prices/domain/repositories/commodity_repository.dart';
import 'package:compare_prices/domain/usecases/use_case.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final deleteCommodityUseCaseProvider =
    Provider.autoDispose<DeleteCommodityUseCase>(
        (ref) => DeleteCommodityUseCase(ref.read));

class DeleteCommodityUseCase
    extends FutureUseCase<void, Commodity> {
  final Reader _reader;

  late final CommodityRepository _commodityRepository =
      _reader(commodityRepositoryProvider);

  DeleteCommodityUseCase(this._reader);

  @override
  Future<Result<void>> call(Commodity params) {
   return Result.guardFuture(() => _commodityRepository.deleteCommodity(params));
  }
}
