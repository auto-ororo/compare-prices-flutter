import 'package:compare_prices/domain/entities/commodity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'edit_commodity_dialog_state.freezed.dart';

@freezed
class EditCommodityDialogState with _$EditCommodityDialogState {
  const factory EditCommodityDialogState({
    required Commodity commodity,
  }) = _EditCommodityDialogState;
}
