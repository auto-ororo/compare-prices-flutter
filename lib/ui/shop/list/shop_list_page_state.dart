import 'package:compare_prices/domain/entities/shop.dart';
import 'package:compare_prices/domain/entities/shop_sort_type.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'shop_list_page_state.freezed.dart';

@freezed
class ShopListPageState with _$ShopListPageState {
  const factory ShopListPageState({
    @Default([]) List<Shop> shops,
    @Default([]) List<Shop> showingShops,
    @Default(ShopSortType.newestCreatedAt()) ShopSortType sortType,
    @Default("") String searchWord,
  }) = _ShopListPageState;
}
