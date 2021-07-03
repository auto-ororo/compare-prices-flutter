import 'package:freezed_annotation/freezed_annotation.dart';

part 'bottom_price_list_sort_type.freezed.dart';

@freezed
class BottomPriceSortType<T> with _$BottomPriceSortType<T> {
  const factory BottomPriceSortType.commodity() = _commodity;
  const factory BottomPriceSortType.shop() = _shop;
  const factory BottomPriceSortType.price() = _price;
  const factory BottomPriceSortType.oldestPurchaseDate() = _oldestPurchaseDate;
  const factory BottomPriceSortType.newestPurchaseDate() = _newestPurchaseDate;
}
