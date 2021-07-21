import 'package:compare_prices/domain/entities/purchase_result.dart';
import 'package:compare_prices/domain/entities/purchase_result_sort_type.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'purchase_result_list_page_state.freezed.dart';

@freezed
class PurchaseResultListPageState with _$PurchaseResultListPageState {
  const factory PurchaseResultListPageState({
    @Default([]) List<PurchaseResult> purchaseResults,
    @Default([]) List<PurchaseResult> showingPurchaseResults,
    @Default(PurchaseResultSortType.newestPurchaseDate())
        PurchaseResultSortType sortType,
  }) = _PurchaseResultListPageState;
}
