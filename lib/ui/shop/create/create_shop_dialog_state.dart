import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_shop_dialog_state.freezed.dart';

@freezed
class CreateShopDialogState with _$CreateShopDialogState {
  const factory CreateShopDialogState({
    @Default("") String name,
  }) = _CreateShopDialogState;
}
