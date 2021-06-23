import 'package:compare_prices/domain/entities/commodity.dart';
import 'package:compare_prices/domain/entities/shop.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'bottom_price.freezed.dart';

@freezed
class BottomPrice with _$BottomPrice {
  const factory BottomPrice({
    required String id,
    required Commodity commodity,
    required Shop mostInexpensiveShop,
    required int price,
    required DateTime purchaseDate,
  }) = _BottomPrice;
}
