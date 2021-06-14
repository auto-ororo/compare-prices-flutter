import 'package:compare_prices/domain/usecases/get_inexpensive_commodity_list_use_case.dart';
import 'package:compare_prices/domain/usecases/use_case.dart';
import 'package:compare_prices/ui/commodity/commodity_list_page_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:state_notifier/state_notifier.dart';

class CommodityListPageViewModel extends StateNotifier<CommodityListPageState> {
  final GetInexpensiveCommodityListUseCase _getInexpensiveCommodityListUseCase;

  CommodityListPageViewModel(this._getInexpensiveCommodityListUseCase)
      : super(const CommodityListPageState());

  void getList() async {
    final commodityRowsResult =
        await _getInexpensiveCommodityListUseCase(NoParam());

    commodityRowsResult.when(success: (commodityRows) {
      state = state.copyWith(commodityRows: commodityRows);
    }, failure: (exception) {
      print(exception.toString());
    });
  }

  void shuffleList() {
    var commodityRows = state.commodityRows;
    commodityRows.shuffle();
    state = state.copyWith(commodityRows: commodityRows);
  }

  void sort() {
    var list = state.commodityRows;
    list.sort((a, b) => a.commodity.name.compareTo(b.commodity.name));
    state = state.copyWith(filteredCommodityRows: list);
  }

  void bindSearchWord(String word) {
    state = state.copyWith(searchWord: word);
  }

  void filter() {
    if (state.searchWord == "") {
      state = state.copyWith(filteredCommodityRows: state.commodityRows);
      return;
    }

    var list = state.commodityRows
        .where((element) => element.commodity.name.contains(state.searchWord))
        .toList();

    state = state.copyWith(filteredCommodityRows: list);
  }
}
