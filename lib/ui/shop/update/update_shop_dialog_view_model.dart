import 'dart:async';

import 'package:compare_prices/domain/exception/exception_extensions.dart';
import 'package:compare_prices/domain/models/shop.dart';
import 'package:compare_prices/domain/usecases/update_shop_use_case.dart';
import 'package:compare_prices/ui/shop/update/update_shop_dialog_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final updateShopDialogViewModelProvider = StateNotifierProvider.family
    .autoDispose<UpdateShopDialogViewModel, UpdateShopDialogState, Shop>(
        (ref, shop) => UpdateShopDialogViewModel(ref.read, shop));

class UpdateShopDialogViewModel extends StateNotifier<UpdateShopDialogState> {
  final Reader _reader;

  late final _updateShopUseCase = _reader(updateShopUseCaseProvider);

  final _onShopUpdated = StreamController<Shop>();
  StreamController<Shop> get onShopUpdated => _onShopUpdated;

  UpdateShopDialogViewModel(this._reader, shop)
      : super(UpdateShopDialogState(shop: shop));

  void updateShop() {
    _updateShopUseCase(state.shop).then((result) {
      result.when(success: (_) {
        _onShopUpdated.add(state.shop);
      }, failure: (exception) {
        state =
            state.copyWith(happenedExceptionType: exception.exceptionType());
      });
    });
  }

  void updateName(String name) {
    state = state.copyWith(shop: state.shop.copyWith(name: name));
  }

  String? validateName(BuildContext context) {
    if (state.shop.name.isEmpty) {
      return AppLocalizations.of(context)!.commonInputHint;
    } else {
      return null;
    }
  }

  @override
  void dispose() {
    _onShopUpdated.close();

    super.dispose();
  }
}
