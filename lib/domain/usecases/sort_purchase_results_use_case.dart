import 'package:compare_prices/domain/entities/purchase_result.dart';
import 'package:compare_prices/domain/entities/purchase_result_sort_type.dart';
import 'package:compare_prices/domain/entities/result.dart';
import 'package:compare_prices/domain/usecases/use_case.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

part 'sort_purchase_results_use_case.freezed.dart';

final sortPurchaseResultsUseCaseProvider =
    Provider.autoDispose<SortPurchaseResultsUseCase>(
        (ref) => SortPurchaseResultsUseCase());

class SortPurchaseResultsUseCase
    extends UseCase<List<PurchaseResult>, SortPurchaseResultsUseCaseParams> {
  SortPurchaseResultsUseCase();

  @override
  Result<List<PurchaseResult>> call(SortPurchaseResultsUseCaseParams params) {
    return Result.guard(() {
      final list = params.purchaseResults.toList();

      params.sortType.when(newestCreatedAt: () {
        // 追加日が新しい順
        list.sort((n, c) => c.createdAt.compareTo(n.createdAt));
      }, newestPurchaseDate: () {
        // 購入日が新しい順
        list.sort((n, c) => c.purchaseDate.compareTo(n.createdAt));
      }, oldestPurchaseDate: () {
        // 購入日が古い順
        list.sort((c, n) => c.purchaseDate.compareTo(n.createdAt));
      });

      return list;
    });
  }
}

@freezed
class SortPurchaseResultsUseCaseParams with _$SortPurchaseResultsUseCaseParams {
  const factory SortPurchaseResultsUseCaseParams({
    required List<PurchaseResult> purchaseResults,
    required PurchaseResultSortType sortType,
  }) = _SortPurchaseResultsUseCaseParams;
}
