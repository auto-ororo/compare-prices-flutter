import 'package:compare_prices/data/providers.dart';
import 'package:compare_prices/domain/entities/commodity.dart';
import 'package:compare_prices/domain/entities/result.dart';
import 'package:compare_prices/domain/usecases/use_case.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final disableCommodityUseCaseProvider =
    Provider.autoDispose<DisableCommodityUseCase>(
        (ref) => DisableCommodityUseCase(ref.read));

class DisableCommodityUseCase extends FutureUseCase<void, Commodity> {
  final Reader _reader;

  late final _commodityRepository = _reader(commodityRepositoryProvider);

  DisableCommodityUseCase(this._reader);

  @override
  Future<Result<void>> call(Commodity params) {
    return Result.guardFuture(() => _commodityRepository.updateCommodity(
        params.copyWith(isEnabled: false, updatedAt: DateTime.now())));
  }
}
