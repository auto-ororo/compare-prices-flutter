import 'package:compare_prices/data/providers.dart';
import 'package:compare_prices/domain/models/purchase_result.dart';
import 'package:compare_prices/domain/models/result.dart';
import 'package:compare_prices/domain/usecases/use_case.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final getPurchaseResultsUseCaseProvider =
    Provider.autoDispose<GetPurchaseResultsUseCase>(
        (ref) => GetPurchaseResultsUseCase(ref.read));

class GetPurchaseResultsUseCase
    extends FutureUseCase<List<PurchaseResult>, NoParam> {
  final Reader _reader;

  late final _purchaseResultRepository =
      _reader(purchaseResultRepositoryProvider);

  GetPurchaseResultsUseCase(this._reader);

  @override
  Future<Result<List<PurchaseResult>>> call(NoParam params) async {
    return Result.guardFuture(_purchaseResultRepository.getPurchaseResults);
  }
}
