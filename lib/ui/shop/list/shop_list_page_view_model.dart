import 'dart:async';

import 'package:compare_prices/domain/exception/exception_extensions.dart';
import 'package:compare_prices/domain/exception/exception_type.dart';
import 'package:compare_prices/domain/models/shop.dart';
import 'package:compare_prices/domain/models/shop_sort_type.dart';
import 'package:compare_prices/domain/usecases/delete_shop_use_case.dart';
import 'package:compare_prices/domain/usecases/filter_shops_by_keyword_use_case.dart';
import 'package:compare_prices/domain/usecases/get_shops_use_case.dart';
import 'package:compare_prices/domain/usecases/sort_shops_use_case.dart';
import 'package:compare_prices/domain/usecases/use_case.dart';
import 'package:compare_prices/ui/shop/list/shop_list_page_state.dart';
import 'package:compare_prices/ui/shop/list/shop_popup_action.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:state_notifier/state_notifier.dart';

final shopListPageViewModelProvider =
    StateNotifierProvider.autoDispose<ShopListPageViewModel, ShopListPageState>(
        (ref) => ShopListPageViewModel(ref.read));

class ShopListPageViewModel extends StateNotifier<ShopListPageState> {
  final Reader _reader;

  late final _getShopsUseCase = _reader(getShopsUseCaseProvider);

  late final _deleteShopUseCase = _reader(deleteShopUseCaseProvider);

  late final _filterShopsByKeywordUseCase =
      _reader(filterShopsByKeywordUseCaseProvider);

  late final _sortShopsUseCase = _reader(sortShopsUseCaseProvider);

  var _onExceptionHappened = StreamController<ExceptionType>();
  StreamController<ExceptionType> get onExceptionHappened =>
      _onExceptionHappened;

  var _onShopSelected = StreamController<Shop>();
  StreamController<Shop> get onShopSelected => _onShopSelected;

  var _onRequestedToEditShop = StreamController<Shop>();
  StreamController<Shop> get onRequestedToEditShop => _onRequestedToEditShop;

  var _onRequestedToDeleteShop = StreamController<Shop>();
  StreamController<Shop> get onRequestedToDeleteShop =>
      _onRequestedToDeleteShop;

  ShopListPageViewModel(this._reader) : super(const ShopListPageState());

  void getList() async {
    _getShopsUseCase(NoParam()).then((result) {
      result.when(success: (shops) {
        state = state.copyWith(shops: shops);
      }, failure: (exception) {
        _onExceptionHappened.add(exception.exceptionType());
      });
    });
  }

  void updateSearchWord(String word) {
    state = state.copyWith(searchWord: word);
  }

  void selectShop(Shop? shop) {
    if (shop != null) {
      _onShopSelected.add(shop);
    }
  }

  void disableShop(Shop shop) {
    _deleteShopUseCase(shop).then((result) {
      result.when(success: (shops) {
        getList();
      }, failure: (exception) {
        _onExceptionHappened.add(exception.exceptionType());
      });
    });
  }

  void updateSortType(ShopSortType sortType) {
    state = state.copyWith(sortType: sortType);
  }

  void filterAndSort() {
    final filteredList = _filterShopsByKeywordUseCase(
            FilterShopsByKeywordUseCaseParams(
                shops: state.shops, keyword: state.searchWord))
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
    _onExceptionHappened.close();
    _onShopSelected.close();
    _onRequestedToDeleteShop.close();
    _onRequestedToEditShop.close();

    super.dispose();
  }
}
