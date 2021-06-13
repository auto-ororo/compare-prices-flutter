import 'package:compare_prices/domain/entities/commodity_row.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'commodity_list_page_state.freezed.dart';

@freezed
class CommodityListPageState with _$CommodityListPageState {
  const factory CommodityListPageState({
    @Default([]) List<CommodityRow> commodityRows,
    @Default([]) List<CommodityRow> filteredCommodityRows,
    @Default("") String searchWord,
  }) = _CommodityListPageState;
}
