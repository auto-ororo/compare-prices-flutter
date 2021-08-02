import 'package:compare_prices/data/providers.dart';
import 'package:compare_prices/domain/models/result.dart';
import 'package:compare_prices/domain/usecases/use_case.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final initializeAppUseCaseProvider = Provider.autoDispose<InitializeAppUseCase>(
    (ref) => InitializeAppUseCase(ref.read));

class InitializeAppUseCase extends FutureUseCase<void, NoParam> {
  final Reader _reader;

  late final _infrastructureConfigRepository =
      _reader(infrastructureConfigRepositoryProvider);

  InitializeAppUseCase(this._reader);

  @override
  Future<Result<void>> call(NoParam params) {
    return Result.guardFuture(_infrastructureConfigRepository.initialize);
  }
}
