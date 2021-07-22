import 'dart:async';

import 'package:compare_prices/domain/entities/commodity.dart';
import 'package:compare_prices/domain/entities/commodity_sort_type.dart';
import 'package:compare_prices/domain/exception/exception_extensions.dart';
import 'package:compare_prices/domain/exception/exception_type.dart';
import 'package:compare_prices/domain/usecases/disable_commodity_use_case.dart';
import 'package:compare_prices/domain/usecases/filter_commodities_by_keyword_use_case.dart';
import 'package:compare_prices/domain/usecases/get_enabled_commodities_use_case.dart';
import 'package:compare_prices/domain/usecases/sort_commodities_use_case.dart';
import 'package:compare_prices/domain/usecases/use_case.dart';
import 'package:compare_prices/ui/commodity/list/commodity_list_page_state.dart';
import 'package:compare_prices/ui/commodity/list/commodity_popup_action.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:state_notifier/state_notifier.dart';

final commodityListPageViewModelProvider = StateNotifierProvider.autoDispose<
    CommodityListPageViewModel,
    CommodityListPageState>((ref) => CommodityListPageViewModel(ref.read));

class CommodityListPageViewModel extends StateNotifier<CommodityListPageState> {
  final Reader _reader;

  late final _getEnabledCommoditiesListUseCase =
      _reader(getEnabledCommoditiesUseCaseProvider);

  late final _disableCommodityUseCase =
      _reader(disableCommodityUseCaseProvider);

  late final _filterCommoditiesByKeywordUseCase =
      _reader(filterCommoditiesByKeywordUseCaseProvider);

  late final _sortCommoditiesUseCase = _reader(sortCommoditiesUseCaseProvider);

  var _onExceptionHappened = StreamController<ExceptionType>();
  StreamController<ExceptionType> get onExceptionHappened =>
      _onExceptionHappened;

  var _onCommoditySelected = StreamController<Commodity>();
  StreamController<Commodity> get onCommoditySelected => _onCommoditySelected;

  var _onRequestedToEditCommodity = StreamController<Commodity>();
  StreamController<Commodity> get onRequestedToEditCommodity =>
      _onRequestedToEditCommodity;

  var _onRequestedToDeleteCommodity = StreamController<Commodity>();
  StreamController<Commodity> get onRequestedToDeleteCommodity =>
      _onRequestedToDeleteCommodity;

  CommodityListPageViewModel(this._reader)
      : super(const CommodityListPageState());

  void getList() async {
    _getEnabledCommoditiesListUseCase(NoParam()).then((result) {
      result.when(success: (commodities) {
        state = state.copyWith(commodities: commodities);
      }, failure: (exception) {
        _onExceptionHappened.add(exception.exceptionType());
      });
    });
  }

  void updateSearchWord(String word) {
    state = state.copyWith(searchWord: word);
  }

  void selectCommodity(Commodity commodity) {
    _onCommoditySelected.add(commodity);
  }

  void disableCommodity(Commodity commodity) {
    _disableCommodityUseCase(commodity).then((result) {
      result.when(success: (commodities) {
        getList();
      }, failure: (exception) {
        _onExceptionHappened.add(exception.exceptionType());
      });
    });
  }

  void updateSortType(CommoditySortType sortType) {
    state = state.copyWith(sortType: sortType);
  }

  void filterAndSort() {
    final filteredList = _filterCommoditiesByKeywordUseCase(
            FilterCommoditiesByKeywordUseCaseParams(
                list: state.commodities, keyword: state.searchWord))
        .dataOrThrow;

    final showingCommodities = _sortCommoditiesUseCase(
            SortCommoditiesUseCaseParams(
                commodities: filteredList, sortType: state.sortType))
        .dataOrThrow;

    state = state.copyWith(showingCommodities: showingCommodities);
  }

  void handleCommodityPopupAction(CommodityPopupAction action) {
    action.when(edit: (commodity) {
      _onRequestedToEditCommodity.add(commodity);
    }, delete: (commodity) {
      _onRequestedToDeleteCommodity.add(commodity);
    });
  }

  @override
  void dispose() {
    _onExceptionHappened.close();
    _onCommoditySelected.close();
    _onRequestedToDeleteCommodity.close();
    _onRequestedToEditCommodity.close();

    super.dispose();
  }
}
