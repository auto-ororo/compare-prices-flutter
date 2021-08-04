import 'package:compare_prices/data/providers.dart';
import 'package:compare_prices/domain/models/result.dart';
import 'package:compare_prices/domain/models/shop.dart';
import 'package:compare_prices/domain/usecases/use_case.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final getShopsUseCaseProvider =
    Provider.autoDispose<GetShopsUseCase>((ref) => GetShopsUseCase(ref.read));

class GetShopsUseCase extends FutureUseCase<List<Shop>, NoParam> {
  final Reader _reader;

  late final _shopRepository = _reader(shopRepositoryProvider);

  GetShopsUseCase(this._reader);

  @override
  Future<Result<List<Shop>>> call(NoParam params) {
    return Result.guardFuture(_shopRepository.getShops);
  }
}
