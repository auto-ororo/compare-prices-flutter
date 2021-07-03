import 'dart:async';

import 'package:compare_prices/domain/entities/shop.dart';
import 'package:compare_prices/domain/exception/exception_extensions.dart';
import 'package:compare_prices/domain/usecases/update_shop_use_case.dart';
import 'package:compare_prices/ui/shop/update/update_shop_dialog_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final updateShopDialogViewModelProvider = StateNotifierProvider.family
    .autoDispose<UpdateShopDialogViewModel, UpdateShopDialogState, Shop>(
        (ref, shop) => UpdateShopDialogViewModel(ref.read, shop));

class UpdateShopDialogViewModel extends StateNotifier<UpdateShopDialogState> {
  final Reader _reader;

  late final _updateShopUseCase = _reader(updateShopUseCaseProvider);

  final _errorMessage = StreamController<String>();
  StreamController<String> get errorMessage => _errorMessage;

  final _onShopUpdated = StreamController<Shop>();
  StreamController<Shop> get onShopUpdated => _onShopUpdated;

  UpdateShopDialogViewModel(this._reader, shop)
      : super(UpdateShopDialogState(shop: shop));

  void updateShop() {
    _updateShopUseCase(state.shop).then((result) {
      result.when(success: (_) {
        _onShopUpdated.add(state.shop);
      }, failure: (exception) {
        _errorMessage.add(exception.errorMessage());
      });
    });
  }

  void updateName(String name) {
    state = state.copyWith(shop: state.shop.copyWith(name: name));
  }

  @override
  void dispose() {
    _errorMessage.close();
    _onShopUpdated.close();

    super.dispose();
  }
}
