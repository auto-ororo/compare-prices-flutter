import 'package:compare_prices/domain/entities/commodity.dart';
import 'package:compare_prices/domain/entities/shop.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_purchase_result_page_state.freezed.dart';

@freezed
class AddPurchaseResultPageState with _$AddPurchaseResultPageState {
  const factory AddPurchaseResultPageState({
    @Default(0) int price,
    DateTime? purchaseDate,
    Commodity? selectedCommodity,
    Shop? selectedShop,
  }) = _AddPurchaseResultPageState;
}
