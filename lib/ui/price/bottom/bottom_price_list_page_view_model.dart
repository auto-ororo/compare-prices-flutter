import 'dart:async';

import 'package:compare_prices/domain/exception/exception_extensions.dart';
import 'package:compare_prices/domain/usecases/filter_bottom_prices_by_keyword_use_case.dart';
import 'package:compare_prices/domain/usecases/get_bottom_prices_use_case.dart';
import 'package:compare_prices/domain/usecases/use_case.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:state_notifier/state_notifier.dart';

import 'bottom_price_list_page_state.dart';

final bottomPriceListPageViewModelProvider = StateNotifierProvider.autoDispose<
    BottomPriceListPageViewModel,
    BottomPriceListPageState>((ref) => BottomPriceListPageViewModel(ref.read));

class BottomPriceListPageViewModel
    extends StateNotifier<BottomPriceListPageState> {
  final Reader _reader;
  late final GetBottomPricesUseCase _getBottomPricesUseCase =
      _reader(getBottomPricesUseCaseProvider);

  late final FilterBottomPricesByKeywordUseCase
      _filterBottomPricesByKeywordUseCase =
      _reader(filterBottomPricesByKeywordUseCaseProvider);

  var _errorMessage = StreamController<String>();
  StreamController<String> get errorMessage => _errorMessage;

  BottomPriceListPageViewModel(this._reader)
      : super(const BottomPriceListPageState());

  void getList() async {
    _getBottomPricesUseCase(NoParam()).then((result) {
      result.when(success: (commodityRows) {
        state = state.copyWith(bottomPrices: commodityRows);
      }, failure: (exception) {
        print("getList failed ${exception.toString()}");
        _errorMessage.add(exception.errorMessage());
      });
    });
  }

  void updateSearchWord(String word) {
    state = state.copyWith(searchWord: word);
  }

  void filter() {
    final list = _filterBottomPricesByKeywordUseCase(
            FilterBottomPricesByKeywordUseCaseParams(
                bottomPrices: state.bottomPrices, keyword: state.searchWord))
        .dataOrThrow;

    state = state.copyWith(filteredBottomPrices: list);
  }

  @override
  void dispose() {
    _errorMessage.close();

    super.dispose();
  }
}
