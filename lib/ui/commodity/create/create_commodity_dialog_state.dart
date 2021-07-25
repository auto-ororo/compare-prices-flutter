import 'package:compare_prices/domain/entities/quantity.dart';
import 'package:compare_prices/domain/exception/exception_type.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_commodity_dialog_state.freezed.dart';

@freezed
class CreateCommodityDialogState with _$CreateCommodityDialogState {
  const factory CreateCommodityDialogState({
    @Default("") String name,
    @Default(Quantity.count()) Quantity quantity,
    @Default(null) ExceptionType? happenedExceptionType,
  }) = _CreateCommodityDialogState;
}
