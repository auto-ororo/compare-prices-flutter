import 'package:freezed_annotation/freezed_annotation.dart';

part 'shop_sort_type.freezed.dart';

@freezed
class ShopSortType<T> with _$ShopSortType<T> {
  const factory ShopSortType.name() = _name;
  const factory ShopSortType.oldestCreatedAt() = _oldestPurchaseDate;
  const factory ShopSortType.newestCreatedAt() = _newestPurchaseDate;
}
