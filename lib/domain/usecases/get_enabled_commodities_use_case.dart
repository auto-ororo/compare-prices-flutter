import 'package:compare_prices/data/providers.dart';
import 'package:compare_prices/domain/entities/commodity.dart';
import 'package:compare_prices/domain/entities/result.dart';
import 'package:compare_prices/domain/usecases/use_case.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final getEnabledCommoditiesUseCaseProvider =
    Provider.autoDispose<GetEnabledCommoditiesUseCase>(
        (ref) => GetEnabledCommoditiesUseCase(ref.read));

class GetEnabledCommoditiesUseCase
    extends FutureUseCase<List<Commodity>, NoParam> {
  final Reader _reader;

  late final _commodityRepository = _reader(commodityRepositoryProvider);

  GetEnabledCommoditiesUseCase(this._reader);

  @override
  Future<Result<List<Commodity>>> call(NoParam params) {
    return Result.guardFuture(_commodityRepository.getEnabledCommodities);
  }
}
