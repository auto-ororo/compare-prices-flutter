import 'package:compare_prices/domain/entities/shop.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_shop_dialog_state.freezed.dart';

@freezed
class UpdateShopDialogState with _$UpdateShopDialogState {
  const factory UpdateShopDialogState({
    required Shop shop,
  }) = _UpdateShopDialogState;
}