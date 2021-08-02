import 'package:compare_prices/domain/models/commodity.dart';
import 'package:compare_prices/domain/models/commodity_sort_type.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'commodity_list_page_state.freezed.dart';

@freezed
class CommodityListPageState with _$CommodityListPageState {
  const factory CommodityListPageState({
    @Default([]) List<Commodity> commodities,
    @Default([]) List<Commodity> showingCommodities,
    @Default(CommoditySortType.newestCreatedAt()) CommoditySortType sortType,
    @Default("") String searchWord,
  }) = _CommodityListPageState;
}
