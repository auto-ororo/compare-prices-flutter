import 'package:compare_prices/data/providers.dart';
import 'package:compare_prices/domain/models/commodity.dart';
import 'package:compare_prices/domain/models/purchase_result.dart';
import 'package:compare_prices/domain/models/result.dart';
import 'package:compare_prices/domain/models/shop.dart';
import 'package:compare_prices/domain/usecases/use_case.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

part 'create_purchase_result_use_case.freezed.dart';

final createPurchaseResultUseCaseProvider =
    Provider.autoDispose<CreatePurchaseResultUseCase>(
        (ref) => CreatePurchaseResultUseCase(ref.read));

class CreatePurchaseResultUseCase
    extends FutureUseCase<PurchaseResult, CreatePurchaseResultUseCaseParams> {
  final Reader _reader;

  late final _purchaseResultRepository =
      _reader(purchaseResultRepositoryProvider);

  CreatePurchaseResultUseCase(this._reader);

  @override
  Future<Result<PurchaseResult>> call(
      CreatePurchaseResultUseCaseParams params) {
    return Result.guardFuture(() async {
      final purchaseResult = PurchaseResult.create(
          commodity: params.commodity,
          shop: params.shop,
          price: params.price,
          quantity: params.quantity,
          purchaseDate: params.purchaseDate);

      await _purchaseResultRepository.createPurchaseResult(purchaseResult);

      return purchaseResult;
    });
  }
}

@freezed
class CreatePurchaseResultUseCaseParams
    with _$CreatePurchaseResultUseCaseParams {
  const factory CreatePurchaseResultUseCaseParams({
    required Commodity commodity,
    required Shop shop,
    required int price,
    required int quantity,
    required DateTime purchaseDate,
  }) = _CreatePurchaseResultUseCaseParams;
}
