import 'package:compare_prices/domain/models/bottom_price.dart';
import 'package:compare_prices/domain/models/bottom_price_sort_type.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'bottom_price_list_page_state.freezed.dart';

@freezed
class BottomPriceListPageState with _$BottomPriceListPageState {
  const factory BottomPriceListPageState({
    @Default([]) List<BottomPrice> bottomPrices,
    @Default([]) List<BottomPrice> showingBottomPrices,
    @Default("") String searchWord,
    @Default(BottomPriceSortType.newestPurchaseDate())
        BottomPriceSortType sortType,
  }) = _BottomPriceListPageState;
}
