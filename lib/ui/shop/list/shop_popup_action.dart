import 'package:compare_prices/domain/entities/shop.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'shop_popup_action.freezed.dart';

@freezed
class ShopPopupAction<T> with _$ShopPopupAction<T> {
  const factory ShopPopupAction.edit(Shop shop) = _edit;
  const factory ShopPopupAction.delete(Shop shop) = _delete;
}
