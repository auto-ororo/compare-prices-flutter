import 'package:compare_prices/domain/entities/bottom_price.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'bottom_price_list_page_state.freezed.dart';

@freezed
class BottomPriceListPageState with _$BottomPriceListPageState {
  const factory BottomPriceListPageState({
    @Default([]) List<BottomPrice> bottomPrices,
    @Default([]) List<BottomPrice> filteredBottomPrices,
    @Default("") String searchWord,
  }) = _BottomPriceListPageState;
}
