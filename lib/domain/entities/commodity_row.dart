import 'package:compare_prices/domain/entities/commodity.dart';
import 'package:compare_prices/domain/entities/shop.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'commodity_row.freezed.dart';

@freezed
class CommodityRow with _$CommodityRow {
  const factory CommodityRow({
    required String id,
    required Commodity commodity,
    required Shop mostInexpensiveShop,
    required int price,
    required DateTime purchaseDate,
  }) = _CommodityRow;
}
