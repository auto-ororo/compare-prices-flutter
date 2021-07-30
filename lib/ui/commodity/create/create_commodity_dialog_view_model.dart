import 'dart:async';

import 'package:compare_prices/domain/entities/commodity.dart';
import 'package:compare_prices/domain/entities/quantity_type.dart';
import 'package:compare_prices/domain/exception/exception_extensions.dart';
import 'package:compare_prices/domain/usecases/create_commodity_use_case.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'create_commodity_dialog_state.dart';

final createCommodityDialogViewModelProvider = StateNotifierProvider
    .autoDispose<CreateCommodityDialogViewModel, CreateCommodityDialogState>(
        (ref) => CreateCommodityDialogViewModel(ref.read));

class CreateCommodityDialogViewModel
    extends StateNotifier<CreateCommodityDialogState> {
  final Reader _reader;

  late final _createCommodityByNameUseCase =
      _reader(createCommodityUseCaseProvider);

  final _onCommodityCreated = StreamController<Commodity>();
  StreamController<Commodity> get onCommodityCreated => _onCommodityCreated;

  CreateCommodityDialogViewModel(this._reader)
      : super(const CreateCommodityDialogState());

  void createCommodity() {
    _createCommodityByNameUseCase(
      CreateCommodityUseCaseParams(
        name: state.name,
        quantityType: state.quantityType,
      ),
    ).then((result) {
      result.when(success: (commodity) {
        _onCommodityCreated.add(commodity);
      }, failure: (exception) {
        state =
            state.copyWith(happenedExceptionType: exception.exceptionType());
      });
    });
  }

  String? validateName(BuildContext context) {
    if (state.name.isEmpty) {
      return AppLocalizations.of(context)!.commonInputHint;
    } else {
      return null;
    }
  }

  void updateQuantity(QuantityType? quantityType) {
    if (quantityType != null) {
      state = state.copyWith(quantityType: quantityType);
    }
  }

  void updateName(String name) {
    state = state.copyWith(name: name);
  }

  @override
  void dispose() {
    _onCommodityCreated.close();

    super.dispose();
  }
}
