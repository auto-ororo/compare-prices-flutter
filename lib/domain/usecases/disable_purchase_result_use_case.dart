import 'package:compare_prices/data/providers.dart';
import 'package:compare_prices/domain/exception/domain_exception.dart';
import 'package:compare_prices/domain/exception/exception_type.dart';
import 'package:compare_prices/domain/models/result.dart';
import 'package:compare_prices/domain/usecases/use_case.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final deletePurchaseResultByIdUseCaseProvider =
    Provider.autoDispose<DeletePurchaseResultByIdUseCase>(
        (ref) => DeletePurchaseResultByIdUseCase(ref.read));

class DeletePurchaseResultByIdUseCase extends FutureUseCase<void, String> {
  final Reader _reader;

  late final _purchaseResultRepository =
      _reader(purchaseResultRepositoryProvider);

  DeletePurchaseResultByIdUseCase(this._reader);

  @override
  Future<Result<void>> call(String params) {
    return Result.guardFuture(() async {
      final purchaseResult =
          await _purchaseResultRepository.getEnabledPurchaseResultById(params);

      if (purchaseResult == null) {
        throw DomainException(ExceptionType.notFound());
      }

      await _purchaseResultRepository.updatePurchaseResult(
          purchaseResult.copyWith(isEnabled: false, updatedAt: DateTime.now()));
    });
  }
}
