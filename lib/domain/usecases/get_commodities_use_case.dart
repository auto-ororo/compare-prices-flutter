import 'package:compare_prices/data/providers.dart';
import 'package:compare_prices/domain/models/commodity.dart';
import 'package:compare_prices/domain/models/result.dart';
import 'package:compare_prices/domain/usecases/use_case.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final getCommoditiesUseCaseProvider =
    Provider.autoDispose<GetCommoditiesUseCase>(
        (ref) => GetCommoditiesUseCase(ref.read));

class GetCommoditiesUseCase extends FutureUseCase<List<Commodity>, NoParam> {
  final Reader _reader;

  late final _commodityRepository = _reader(commodityRepositoryProvider);

  GetCommoditiesUseCase(this._reader);

  @override
  Future<Result<List<Commodity>>> call(NoParam params) {
    return Result.guardFuture(_commodityRepository.getCommodities);
  }
}
