import 'dart:async';

import 'package:compare_prices/domain/entities/commodity.dart';
import 'package:compare_prices/domain/exception/exception_extensions.dart';
import 'package:compare_prices/domain/usecases/delete_purchase_result_use_case.dart';
import 'package:compare_prices/domain/usecases/get_commodity_prices_in_ascending_order_use_case.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:state_notifier/state_notifier.dart';

import 'commodity_price_list_page_state.dart';

final commodityPriceListPageViewModelProvider = StateNotifierProvider.family
    .autoDispose<CommodityPriceListPageViewModel, CommodityPriceListPageState,
            Commodity>(
        (ref, commodity) =>
            CommodityPriceListPageViewModel(ref.read, commodity));

class CommodityPriceListPageViewModel
    extends StateNotifier<CommodityPriceListPageState> {
  final Reader _reader;
  late final GetCommodityPricesInAscendingOrderUseCase
      _getCommodityPricesInAscendingOrderUseCase =
      _reader(getCommodityPricesInAscendingOrderUseCaseProvider);

  late final DeletePurchaseResultByIdUseCase _deletePurchaseResultByIdUseCase =
      _reader(deletePurchaseResultByIdUseCaseProvider);

  var _errorMessage = StreamController<String>();
  StreamController<String> get errorMessage => _errorMessage;

  CommodityPriceListPageViewModel(this._reader, Commodity commodity)
      : super(CommodityPriceListPageState(commodity: commodity));

  void getList() async {
    _getCommodityPricesInAscendingOrderUseCase(state.commodity.id)
        .then((result) {
      result.when(success: (commodityPrices) {
        state = state.copyWith(commodityPrices: commodityPrices);
      }, failure: (exception) {
        _errorMessage.add(exception.errorMessage());
      });
    });
  }

  void deletePurchaseResult(String purchaseResultId) async {
    _deletePurchaseResultByIdUseCase(purchaseResultId).then((result) {
      result.when(success: (_) {
        getList();
      }, failure: (exception) {
        _errorMessage.add(exception.errorMessage());
      });
    });
  }

  @override
  void dispose() {
    _errorMessage.close();

    super.dispose();
  }
}
