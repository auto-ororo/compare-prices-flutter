import 'package:compare_prices/domain/exception/exception_type.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_shop_dialog_state.freezed.dart';

@freezed
class CreateShopDialogState with _$CreateShopDialogState {
  const factory CreateShopDialogState({
    @Default("") String name,
    @Default(null) ExceptionType? happenedExceptionType,
  }) = _CreateShopDialogState;
}
