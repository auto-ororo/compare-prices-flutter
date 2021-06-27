import 'dart:async';

import 'package:compare_prices/domain/entities/commodity.dart';
import 'package:compare_prices/domain/exception/exception_extensions.dart';
import 'package:compare_prices/domain/usecases/disable_commodity_use_case.dart';
import 'package:compare_prices/domain/usecases/filter_commodities_by_keyword_use_case.dart';
import 'package:compare_prices/domain/usecases/get_enabled_commodities_use_case.dart';
import 'package:compare_prices/domain/usecases/use_case.dart';
import 'package:compare_prices/ui/commodity/select/commodity_popup_action.dart';
import 'package:compare_prices/ui/commodity/select/select_commodity_page_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:state_notifier/state_notifier.dart';

final selectCommodityPageViewModelProvider = StateNotifierProvider.autoDispose<
    SelectCommodityPageViewModel,
    SelectCommodityPageState>((ref) => SelectCommodityPageViewModel(ref.read));

class SelectCommodityPageViewModel
    extends StateNotifier<SelectCommodityPageState> {
  final Reader _reader;

  late final GetEnabledCommoditiesUseCase _getEnabledCommoditiesListUseCase =
      _reader(getEnabledCommoditiesUseCaseProvider);

  late final DisableCommodityUseCase _disableCommodityUseCase =
      _reader(disableCommodityUseCaseProvider);

  late final FilterCommoditiesByKeywordUseCase
      _filterCommoditiesByKeywordUseCase =
      _reader(filterCommoditiesByKeywordUseCaseProvider);

  var _errorMessage = StreamController<String>();
  StreamController<String> get errorMessage => _errorMessage;

  var _onCommoditySelected = StreamController<Commodity>();
  StreamController<Commodity> get onCommoditySelected => _onCommoditySelected;

  var _onRequestedToEditCommodity = StreamController<Commodity>();
  StreamController<Commodity> get onRequestedToEditCommodity =>
      _onRequestedToEditCommodity;

  var _onRequestedToDeleteCommodity = StreamController<Commodity>();
  StreamController<Commodity> get onRequestedToDeleteCommodity =>
      _onRequestedToDeleteCommodity;

  SelectCommodityPageViewModel(this._reader)
      : super(const SelectCommodityPageState());

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

  void disableCommodity(Commodity commodity) {
    _disableCommodityUseCase(commodity).then((result) {
      result.when(success: (commodities) {
        getList();
      }, failure: (exception) {
        print("delete failed ${exception.toString()}");
        _errorMessage.add(exception.errorMessage());
      });
    });
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
      _onRequestedToEditCommodity.add(commodity);
    }, delete: (commodity) {
      _onRequestedToDeleteCommodity.add(commodity);
    });
  }

  @override
  void dispose() {
    _errorMessage.close();
    _onCommoditySelected.close();
    _onRequestedToDeleteCommodity.close();
    _onRequestedToEditCommodity.close();

    super.dispose();
  }
}
