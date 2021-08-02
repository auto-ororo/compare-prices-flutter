import 'package:compare_prices/domain/models/commodity.dart';
import 'package:compare_prices/domain/models/commodity_price.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'commodity_price_list_page_state.freezed.dart';

@freezed
class CommodityPriceListPageState with _$CommodityPriceListPageState {
  const factory CommodityPriceListPageState({
    required Commodity commodity,
    @Default([]) List<CommodityPrice> commodityPrices,
    @Default([]) List<CommodityPrice> showingCommodityPrices,
    @Default(false) bool shouldGroupByShop,
  }) = _CommodityPriceListPageState;
}
