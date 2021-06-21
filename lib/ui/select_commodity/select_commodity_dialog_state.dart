import 'package:compare_prices/domain/entities/commodity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'select_commodity_dialog_state.freezed.dart';

@freezed
class SelectCommodityDialogState with _$SelectCommodityDialogState {
  const factory SelectCommodityDialogState({
    @Default([]) List<Commodity> commodities,
    @Default([]) List<Commodity> filteredCommodities,
    @Default("") String searchWord,
  }) = _SelectCommodityDialogState;
}
