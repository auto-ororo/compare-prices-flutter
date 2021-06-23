import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_commodity_dialog_state.freezed.dart';

@freezed
class CreateCommodityDialogState with _$CreateCommodityDialogState {
  const factory CreateCommodityDialogState({
    @Default("") String name,
  }) = _CreateCommodityDialogState;
}