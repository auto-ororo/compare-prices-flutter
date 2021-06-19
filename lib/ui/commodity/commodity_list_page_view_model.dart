import 'dart:async';

import 'package:compare_prices/domain/exception/exception_extensions.dart';
import 'package:compare_prices/domain/usecases/filter_inexpensive_commodity_list_by_keyword_use_case.dart';
import 'package:compare_prices/domain/usecases/get_inexpensive_commodity_list_use_case.dart';
import 'package:compare_prices/domain/usecases/use_case.dart';
import 'package:compare_prices/ui/commodity/commodity_list_page_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:state_notifier/state_notifier.dart';

final commodityListPageViewModelProvider = StateNotifierProvider.autoDispose<
    CommodityListPageViewModel,
    CommodityListPageState>((ref) => CommodityListPageViewModel(ref.read));

class CommodityListPageViewModel extends StateNotifier<CommodityListPageState> {
  final Reader _reader;
  late final GetInexpensiveCommodityListUseCase
      _getInexpensiveCommodityListUseCase =
      _reader(getInexpensiveCommodityListUseCaseProvider);

  late final FilterInexpensiveCommodityListByKeywordUseCase
      _filterInexpensiveCommodityListByKeywordUseCase =
      _reader(filterInexpensiveCommodityListByKeywordUseCaseProvider);

  var _errorMessage = StreamController<String>();
  StreamController<String> get errorMessage => _errorMessage;

  CommodityListPageViewModel(this._reader)
      : super(const CommodityListPageState());

  void getList() async {
    _getInexpensiveCommodityListUseCase(NoParam()).then((result) {
      result.when(success: (commodityRows) {
        state = state.copyWith(commodityRows: commodityRows);
      }, failure: (exception) {
        print("getList failed ${exception.toString()}");
        _errorMessage.add(exception.errorMessage());
      });
    });
  }

  void sort() {
    var list = state.commodityRows;
    list.sort((a, b) => a.commodity.name.compareTo(b.commodity.name));
    state = state.copyWith(filteredCommodityRows: list);
  }

  void updateSearchWord(String word) {
    state = state.copyWith(searchWord: word);
  }

  void filter() {
    final list = _filterInexpensiveCommodityListByKeywordUseCase(
            FilterInexpensiveCommodityListByKeywordUseCaseParams(
                list: state.commodityRows, keyword: state.searchWord))
        .dataOrThrow;

    state = state.copyWith(filteredCommodityRows: list);
  }

  @override
  void dispose() {
    _errorMessage.close();

    super.dispose();
  }
}
