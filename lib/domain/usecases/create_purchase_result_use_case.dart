import 'package:compare_prices/data/providers.dart';
import 'package:compare_prices/domain/entities/purchase_result.dart';
import 'package:compare_prices/domain/entities/result.dart';
import 'package:compare_prices/domain/repositories/purchase_result_repository.dart';
import 'package:compare_prices/domain/usecases/use_case.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

part 'create_purchase_result_use_case.freezed.dart';

final createPurchaseResultUseCaseProvider =
    Provider.autoDispose<CreatePurchaseResultUseCase>(
        (ref) => CreatePurchaseResultUseCase(ref.read));

class CreatePurchaseResultUseCase
    extends FutureUseCase<void, CreatePurchaseResultUseCaseParams> {
  final Reader _reader;

  late final PurchaseResultRepository _purchaseResultRepository =
      _reader(purchaseResultRepositoryProvider);

  CreatePurchaseResultUseCase(this._reader);

  @override
  Future<Result<void>> call(CreatePurchaseResultUseCaseParams params) {
    return Result.guardFuture(() async {
      final purchaseResult = PurchaseResult.create(
          commodityId: params.commodityId,
          shopId: params.shopId,
          price: params.price,
          purchaseDate: params.purchaseDate);

      await _purchaseResultRepository.createPurchaseResult(purchaseResult);
    });
  }
}

@freezed
class CreatePurchaseResultUseCaseParams
    with _$CreatePurchaseResultUseCaseParams {
  const factory CreatePurchaseResultUseCaseParams({
    required String commodityId,
    required String shopId,
    required int price,
    required DateTime purchaseDate,
  }) = _FilterShopsByKeywordUseCaseParams;
}