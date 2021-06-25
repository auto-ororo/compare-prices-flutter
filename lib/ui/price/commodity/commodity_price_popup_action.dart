import 'package:freezed_annotation/freezed_annotation.dart';

part 'commodity_price_popup_action.freezed.dart';

@freezed
class CommodityPricePopupAction<T> with _$CommodityPricePopupAction<T> {
  const factory CommodityPricePopupAction.delete(String purchaseResultId) =
      _delete;
}
