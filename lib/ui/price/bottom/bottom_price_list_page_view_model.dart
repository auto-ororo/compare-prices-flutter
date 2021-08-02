import 'dart:async';

import 'package:compare_prices/domain/exception/exception_extensions.dart';
import 'package:compare_prices/domain/exception/exception_type.dart';
import 'package:compare_prices/domain/models/bottom_price_sort_type.dart';
import 'package:compare_prices/domain/usecases/filter_bottom_prices_by_keyword_use_case.dart';
import 'package:compare_prices/domain/usecases/get_bottom_prices_use_case.dart';
import 'package:compare_prices/domain/usecases/sort_bottom_prices_use_case.dart';
import 'package:compare_prices/domain/usecases/use_case.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:state_notifier/state_notifier.dart';

import 'bottom_price_list_page_state.dart';

final bottomPriceListPageViewModelProvider = StateNotifierProvider<
    BottomPriceListPageViewModel,
    BottomPriceListPageState>((ref) => BottomPriceListPageViewModel(ref.read));

class BottomPriceListPageViewModel
    extends StateNotifier<BottomPriceListPageState> {
  final Reader _reader;
  late final _getBottomPricesUseCase = _reader(getBottomPricesUseCaseProvider);

  late final _filterBottomPricesByKeywordUseCase =
      _reader(filterBottomPricesByKeywordUseCaseProvider);

  late final _sortBottomPricesUseCase =
      _reader(sortBottomPricesUseCaseProvider);

  var _onExceptionHappened = StreamController<ExceptionType>.broadcast();
  StreamController<ExceptionType> get onExceptionHappened =>
      _onExceptionHappened;

  BottomPriceListPageViewModel(this._reader)
      : super(const BottomPriceListPageState());

  void getList() async {
    _getBottomPricesUseCase(NoParam()).then((result) {
      result.when(success: (commodityRows) {
        state = state.copyWith(bottomPrices: commodityRows);
      }, failure: (exception) {
        _onExceptionHappened.add(exception.exceptionType());
      });
    });
  }

  void updateSearchWord(String word) {
    state = state.copyWith(searchWord: word);
  }

  void updateSortType(BottomPriceSortType sortType) {
    state = state.copyWith(sortType: sortType);
  }

  void filterAndSort() {
    final filteredList = _filterBottomPricesByKeywordUseCase(
            FilterBottomPricesByKeywordUseCaseParams(
                bottomPrices: state.bottomPrices, keyword: state.searchWord))
        .dataOrThrow;

    final sortedList = _sortBottomPricesUseCase(SortBottomPricesUseCaseParams(
            bottomPrices: filteredList, sortType: state.sortType))
        .dataOrThrow;

    state = state.copyWith(showingBottomPrices: sortedList);
  }

  @override
  void dispose() {
    _onExceptionHappened.close();

    super.dispose();
  }
}
