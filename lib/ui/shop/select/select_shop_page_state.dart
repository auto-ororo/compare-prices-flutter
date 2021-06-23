import 'package:compare_prices/domain/entities/shop.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'select_shop_page_state.freezed.dart';

@freezed
class SelectShopPageState with _$SelectShopPageState {
  const factory SelectShopPageState({
    @Default([]) List<Shop> shops,
    @Default([]) List<Shop> filteredShops,
    @Default("") String searchWord,
  }) = _SelectShopPageState;
}
