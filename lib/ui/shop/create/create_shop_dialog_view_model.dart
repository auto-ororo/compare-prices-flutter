import 'dart:async';

import 'package:compare_prices/domain/entities/shop.dart';
import 'package:compare_prices/domain/exception/exception_extensions.dart';
import 'package:compare_prices/domain/usecases/create_shop_by_name_use_case.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'create_shop_dialog_state.dart';

final createShopDialogViewModelProvider = StateNotifierProvider.autoDispose<
    CreateShopDialogViewModel,
    CreateShopDialogState>((ref) => CreateShopDialogViewModel(ref.read));

class CreateShopDialogViewModel extends StateNotifier<CreateShopDialogState> {
  final Reader _reader;

  late final _createShopByNameUseCase =
      _reader(createShopByNameUseCaseProvider);

  final _onShopCreated = StreamController<Shop>();
  StreamController<Shop> get onShopCreated => _onShopCreated;

  CreateShopDialogViewModel(this._reader)
      : super(const CreateShopDialogState());

  void createShop() {
    _createShopByNameUseCase(state.name).then((result) {
      result.when(success: (shop) {
        _onShopCreated.add(shop);
      }, failure: (exception) {
        state =
            state.copyWith(happenedExceptionType: exception.exceptionType());
      });
    });
  }

  void updateName(String name) {
    state = state.copyWith(name: name);
  }

  String? validateName(BuildContext context) {
    if (state.name.isEmpty) {
      return AppLocalizations.of(context)!.commonInputHint;
    } else {
      return null;
    }
  }

  @override
  void dispose() {
    _onShopCreated.close();

    super.dispose();
  }
}
