import 'dart:async';

import 'package:compare_prices/domain/entities/shop.dart';
import 'package:compare_prices/domain/exception/exception_extensions.dart';
import 'package:compare_prices/domain/usecases/delete_shop_use_case.dart';
import 'package:compare_prices/domain/usecases/filter_shops_by_keyword_use_case.dart';
import 'package:compare_prices/domain/usecases/get_enabled_shops_use_case.dart';
import 'package:compare_prices/domain/usecases/use_case.dart';
import 'package:compare_prices/ui/shop/select/shop_popup_action.dart';
import 'package:compare_prices/ui/shop/select/select_shop_page_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:state_notifier/state_notifier.dart';

final selectShopPageViewModelProvider = StateNotifierProvider.autoDispose<
    SelectShopPageViewModel,
    SelectShopPageState>((ref) => SelectShopPageViewModel(ref.read));

class SelectShopPageViewModel
    extends StateNotifier<SelectShopPageState> {
  final Reader _reader;

  late final GetEnabledShopsUseCase _getEnabledShopsListUseCase =
      _reader(getEnabledShopsUseCaseProvider);

  late final DeleteShopUseCase _deleteShopUseCase =
      _reader(deleteShopUseCaseProvider);

  late final FilterShopsByKeywordUseCase
      _filterShopsByKeywordUseCase =
      _reader(filterShopsByKeywordUseCaseProvider);

  var _errorMessage = StreamController<String>();
  StreamController<String> get errorMessage => _errorMessage;

  var _onShopSelected = StreamController<Shop>();
  StreamController<Shop> get onShopSelected => _onShopSelected;

  var _onRequestedToEditShop = StreamController<Shop>();
  StreamController<Shop> get onRequestedToEditShop =>
      _onRequestedToEditShop;

  var _onRequestedToDeleteShop = StreamController<Shop>();
  StreamController<Shop> get onRequestedToDeleteShop =>
      _onRequestedToDeleteShop;

  SelectShopPageViewModel(this._reader)
      : super(const SelectShopPageState());

  void getList() async {
    _getEnabledShopsListUseCase(NoParam()).then((result) {
      result.when(success: (shops) {
        state = state.copyWith(shops: shops);
      }, failure: (exception) {
        print("getList failed ${exception.toString()}");
        _errorMessage.add(exception.errorMessage());
      });
    });
  }

  void updateSearchWord(String word) {
    state = state.copyWith(searchWord: word);
  }

  void selectShop(Shop shop) {
    _onShopSelected.add(shop);
  }

  void deleteShop(Shop shop) {
    _deleteShopUseCase(shop).then((result) {
      result.when(success: (shops) {
        getList();
      }, failure: (exception) {
        print("delete failed ${exception.toString()}");
        _errorMessage.add(exception.errorMessage());
      });
    });
  }

  void filter() {
    final list = _filterShopsByKeywordUseCase(
            FilterShopsByKeywordUseCaseParams(
                list: state.shops, keyword: state.searchWord))
        .dataOrThrow;

    state = state.copyWith(filteredShops: list);
  }

  void handleShopPopupAction(ShopPopupAction action) {
    action.when(edit: (shop) {
      _onRequestedToEditShop.add(shop);
    }, delete: (shop) {
      _onRequestedToDeleteShop.add(shop);
    });
  }

  @override
  void dispose() {
    _errorMessage.close();
    _onShopSelected.close();
    _onRequestedToDeleteShop.close();
    _onRequestedToEditShop.close();

    super.dispose();
  }
}