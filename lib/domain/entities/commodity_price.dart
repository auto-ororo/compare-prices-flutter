import 'package:compare_prices/domain/entities/shop.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'commodity_price.freezed.dart';

@freezed
class CommodityPrice with _$CommodityPrice {
  const factory CommodityPrice({
    required String id,
    required String commodityId,
    required String purchaseResultId,
    required int rank,
    required int price,
    required Shop shop,
    required DateTime purchaseDate,
  }) = _CommodityPrice;
}
