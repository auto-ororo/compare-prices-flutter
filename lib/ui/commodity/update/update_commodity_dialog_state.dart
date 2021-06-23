import 'package:compare_prices/domain/entities/commodity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_commodity_dialog_state.freezed.dart';

@freezed
class UpdateCommodityDialogState with _$UpdateCommodityDialogState {
  const factory UpdateCommodityDialogState({
    required Commodity commodity,
  }) = _UpdateCommodityDialogState;
}
