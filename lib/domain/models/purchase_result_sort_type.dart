import 'package:freezed_annotation/freezed_annotation.dart';

part 'purchase_result_sort_type.freezed.dart';

@freezed
class PurchaseResultSortType<T> with _$PurchaseResultSortType<T> {
  const factory PurchaseResultSortType.newestCreatedAt() = _newestCreatedAt;
  const factory PurchaseResultSortType.oldestPurchaseDate() =
      _oldestPurchaseDate;
  const factory PurchaseResultSortType.newestPurchaseDate() =
      _newestPurchaseDate;
}
