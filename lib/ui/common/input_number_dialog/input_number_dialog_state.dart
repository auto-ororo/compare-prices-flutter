import 'package:compare_prices/domain/entities/number_type.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'input_number_dialog_state.freezed.dart';

@freezed
class InputNumberDialogState with _$InputNumberDialogState {
  const factory InputNumberDialogState({
    required int inputtedNumber,
    required NumberType numberType,
  }) = _InputNumberDialogState;
}
