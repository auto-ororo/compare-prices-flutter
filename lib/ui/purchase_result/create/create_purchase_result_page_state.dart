import 'package:compare_prices/domain/models/commodity.dart';
import 'package:compare_prices/domain/models/shop.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_purchase_result_page_state.freezed.dart';

@freezed
class CreatePurchaseResultPageState with _$CreatePurchaseResultPageState {
  const factory CreatePurchaseResultPageState({
    @Default(0) int price,
    @Default(1) int count,
    required DateTime purchaseDate,
    Commodity? selectedCommodity,
    Shop? selectedShop,
  }) = _CreatePurchaseResultPageState;
}
