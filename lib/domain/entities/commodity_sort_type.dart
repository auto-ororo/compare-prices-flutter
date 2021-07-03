import 'package:freezed_annotation/freezed_annotation.dart';

part 'commodity_sort_type.freezed.dart';

@freezed
class CommoditySortType<T> with _$CommoditySortType<T> {
  const factory CommoditySortType.name() = _name;
  const factory CommoditySortType.oldestCreatedAt() = _oldestPurchaseDate;
  const factory CommoditySortType.newestCreatedAt() = _newestPurchaseDate;
}
