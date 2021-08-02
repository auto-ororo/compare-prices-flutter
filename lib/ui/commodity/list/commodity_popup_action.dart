import 'package:compare_prices/domain/models/commodity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'commodity_popup_action.freezed.dart';

@freezed
class CommodityPopupAction<T> with _$CommodityPopupAction<T> {
  const factory CommodityPopupAction.edit(Commodity commodity) = _edit;
  const factory CommodityPopupAction.delete(Commodity commodity) = _delete;
}
