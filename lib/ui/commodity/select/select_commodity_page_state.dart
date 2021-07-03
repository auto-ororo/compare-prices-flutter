import 'package:compare_prices/domain/entities/commodity.dart';
import 'package:compare_prices/domain/entities/commodity_sort_type.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'select_commodity_page_state.freezed.dart';

@freezed
class SelectCommodityPageState with _$SelectCommodityPageState {
  const factory SelectCommodityPageState({
    @Default([]) List<Commodity> commodities,
    @Default([]) List<Commodity> showingCommodities,
    @Default(CommoditySortType.newestCreatedAt()) CommoditySortType sortType,
    @Default("") String searchWord,
  }) = _SelectCommodityPageState;
}
