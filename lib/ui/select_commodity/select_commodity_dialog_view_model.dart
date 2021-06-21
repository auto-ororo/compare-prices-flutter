import 'dart:async';

import 'package:compare_prices/domain/entities/commodity.dart';
import 'package:compare_prices/domain/exception/exception_extensions.dart';
import 'package:compare_prices/domain/usecases/filter_commodities_by_keyword_use_case.dart';
import 'package:compare_prices/domain/usecases/get_enabled_commodities_use_case.dart';
import 'package:compare_prices/domain/usecases/use_case.dart';
import 'package:compare_prices/ui/select_commodity/commodity_popup_action.dart';
import 'package:compare_prices/ui/select_commodity/select_commodity_dialog_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:state_notifier/state_notifier.dart';

final selectCommodityDialogViewModelProvider = StateNotifierProvider
    .autoDispose<SelectCommodityDialogViewModel, SelectCommodityDialogState>(
        (ref) => SelectCommodityDialogViewModel(ref.read));

class SelectCommodityDialogViewModel
    extends StateNotifier<SelectCommodityDialogState> {
  final Reader _reader;

  late final GetEnabledCommoditiesUseCase _getEnabledCommoditiesListUseCase =
      _reader(getEnabledCommoditiesUseCaseProvider);

  late final FilterCommoditiesByKeywordUseCase
      _filterCommoditiesByKeywordUseCase =
      _reader(filterCommoditiesByKeywordUseCaseProvider);

  var _errorMessage = StreamController<String>();

  StreamController<String> get errorMessage => _errorMessage;

  var _onCommoditySelected = StreamController<Commodity>();

  StreamController<Commodity> get onCommoditySelected => _onCommoditySelected;

  var _editCommodity = StreamController<Commodity>();
  StreamController<Commodity> get editCommodity => _editCommodity;

  var _deleteCommodity = StreamController<Commodity>();
  StreamController<Commodity> get deleteCommodity => _deleteCommodity;

  SelectCommodityDialogViewModel(this._reader)
      : super(const SelectCommodityDialogState());

  void getList() async {
    _getEnabledCommoditiesListUseCase(NoParam()).then((result) {
      result.when(success: (commodities) {
        state = state.copyWith(commodities: commodities);
      }, failure: (exception) {
        print("getList failed ${exception.toString()}");
        _errorMessage.add(exception.errorMessage());
      });
    });
  }

  void updateSearchWord(String word) {
    state = state.copyWith(searchWord: word);
  }

  void selectCommodity(Commodity commodity) {
    _onCommoditySelected.add(commodity);
  }

  void filter() {
    final list = _filterCommoditiesByKeywordUseCase(
            FilterCommoditiesByKeywordUseCaseParams(
                list: state.commodities, keyword: state.searchWord))
        .dataOrThrow;

    state = state.copyWith(filteredCommodities: list);
  }

  void handleCommodityPopupAction(CommodityPopupAction action) {
    action.when(edit: (commodity) {
      _editCommodity.add(commodity);
    }, delete: (commodity) {

    });
  }

  @override
  void dispose() {
    _errorMessage.close();
    _onCommoditySelected.close();

    super.dispose();
  }
}
