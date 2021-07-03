import 'dart:async';

import 'package:compare_prices/domain/entities/shop.dart';
import 'package:compare_prices/domain/entities/shop_sort_type.dart';
import 'package:compare_prices/domain/exception/exception_extensions.dart';
import 'package:compare_prices/domain/usecases/disable_shop_use_case.dart';
import 'package:compare_prices/domain/usecases/filter_shops_by_keyword_use_case.dart';
import 'package:compare_prices/domain/usecases/get_enabled_shops_use_case.dart';
import 'package:compare_prices/domain/usecases/sort_shops_use_case.dart';
import 'package:compare_prices/domain/usecases/use_case.dart';
import 'package:compare_prices/ui/shop/select/select_shop_page_state.dart';
import 'package:compare_prices/ui/shop/select/shop_popup_action.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:state_notifier/state_notifier.dart';

final selectShopPageViewModelProvider = StateNotifierProvider.autoDispose<
    SelectShopPageViewModel,
    SelectShopPageState>((ref) => SelectShopPageViewModel(ref.read));

class SelectShopPageViewModel extends StateNotifier<SelectShopPageState> {
  final Reader _reader;

  late final _getEnabledShopsListUseCase =
      _reader(getEnabledShopsUseCaseProvider);

  late final _disableShopUseCase = _reader(disableShopUseCaseProvider);

  late final _filterShopsByKeywordUseCase =
      _reader(filterShopsByKeywordUseCaseProvider);

  late final _sortShopsUseCase = _reader(sortShopsUseCaseProvider);

  var _errorMessage = StreamController<String>();
  StreamController<String> get errorMessage => _errorMessage;

  var _onShopSelected = StreamController<Shop>();
  StreamController<Shop> get onShopSelected => _onShopSelected;

  var _onRequestedToEditShop = StreamController<Shop>();
  StreamController<Shop> get onRequestedToEditShop => _onRequestedToEditShop;

  var _onRequestedToDeleteShop = StreamController<Shop>();
  StreamController<Shop> get onRequestedToDeleteShop =>
      _onRequestedToDeleteShop;

  SelectShopPageViewModel(this._reader) : super(const SelectShopPageState());

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

  void disableShop(Shop shop) {
    _disableShopUseCase(shop).then((result) {
      result.when(success: (shops) {
        getList();
      }, failure: (exception) {
        print("delete failed ${exception.toString()}");
        _errorMessage.add(exception.errorMessage());
      });
    });
  }

  void updateSortType(ShopSortType sortType) {
    state = state.copyWith(sortType: sortType);
  }

  void filterAndSort() {
    final filteredList = _filterShopsByKeywordUseCase(
            FilterShopsByKeywordUseCaseParams(
                list: state.shops, keyword: state.searchWord))
        .dataOrThrow;

    final showingShops = _sortShopsUseCase(SortShopsUseCaseParams(
            shops: filteredList, sortType: state.sortType))
        .dataOrThrow;

    state = state.copyWith(showingShops: showingShops);
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
