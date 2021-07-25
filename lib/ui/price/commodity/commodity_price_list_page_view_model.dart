import 'dart:async';

import 'package:compare_prices/domain/entities/commodity.dart';
import 'package:compare_prices/domain/exception/exception_extensions.dart';
import 'package:compare_prices/domain/exception/exception_type.dart';
import 'package:compare_prices/domain/usecases/disable_purchase_result_use_case.dart';
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
  late final _getCommodityPricesInAscendingOrderUseCase =
      _reader(getCommodityPricesInAscendingOrderUseCaseProvider);

  late final _disablePurchaseResultByIdUseCase =
      _reader(deletePurchaseResultByIdUseCaseProvider);

  var _onExceptionHappened = StreamController<ExceptionType>();
  StreamController<ExceptionType> get onExceptionHappened =>
      _onExceptionHappened;

  CommodityPriceListPageViewModel(this._reader, Commodity commodity)
      : super(CommodityPriceListPageState(commodity: commodity));

  void getList() async {
    _getCommodityPricesInAscendingOrderUseCase(state.commodity).then((result) {
      result.when(success: (commodityPrices) {
        state = state.copyWith(commodityPrices: commodityPrices);
      }, failure: (exception) {
        _onExceptionHappened.add(exception.exceptionType());
      });
    });
  }

  void disablePurchaseResult(String purchaseResultId) async {
    _disablePurchaseResultByIdUseCase(purchaseResultId).then((result) {
      result.when(success: (_) {
        getList();
      }, failure: (exception) {
        _onExceptionHappened.add(exception.exceptionType());
      });
    });
  }

  @override
  void dispose() {
    _onExceptionHappened.close();

    super.dispose();
  }
}
