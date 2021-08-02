import 'package:compare_prices/domain/models/number_type.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:state_notifier/state_notifier.dart';

import '../extensions/int_extensions.dart';
import 'input_number_dialog_state.dart';

part 'input_number_dialog_view_model.freezed.dart';

final inputNumberDialogViewModelProvider = StateNotifierProvider.family
    .autoDispose<InputNumberDialogViewModel, InputNumberDialogState,
            InputNumberDialogViewModelParam>(
        (_, param) => InputNumberDialogViewModel(param));

class InputNumberDialogViewModel extends StateNotifier<InputNumberDialogState> {
  InputNumberDialogViewModel(InputNumberDialogViewModelParam param)
      : super(InputNumberDialogState(
            inputtedNumber: param.inputtedNumber,
            numberType: param.numberType)) {
    maxNumberOfDigits = param.maxNumberOfDigits;
  }

  late final int maxNumberOfDigits;

  String convertNumberToString(BuildContext context, int number) {
    String convertedString = number.toString();
    state.numberType.when(
        count: () {},
        quantity: () {},
        currency: () {
          convertedString = number.currency(context);
        });
    return convertedString;
  }

  void updateNumber(String numberChar) {
    final numberString = state.inputtedNumber.toString();

    if (numberString.length == maxNumberOfDigits) return;
    if (numberString == "0") {
      state = state.copyWith(inputtedNumber: int.parse(numberChar));
    } else {
      state =
          state.copyWith(inputtedNumber: int.parse(numberString + numberChar));
    }
  }

  void backSpace() {
    final numberString = state.inputtedNumber.toString();

    if (numberString.length == 1) {
      state = state.copyWith(inputtedNumber: 0);
    } else {
      state = state.copyWith(
          inputtedNumber:
              int.parse(numberString.substring(0, numberString.length - 1)));
    }
  }
}

@freezed
class InputNumberDialogViewModelParam with _$InputNumberDialogViewModelParam {
  const factory InputNumberDialogViewModelParam({
    required int inputtedNumber,
    required NumberType numberType,
    required int maxNumberOfDigits,
  }) = _InputNumberDialogViewModelParam;
}
