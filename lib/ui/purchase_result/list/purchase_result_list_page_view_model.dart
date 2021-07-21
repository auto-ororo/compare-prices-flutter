import 'dart:async';

import 'package:compare_prices/domain/entities/purchase_result_sort_type.dart';
import 'package:compare_prices/domain/exception/exception_extensions.dart';
import 'package:compare_prices/domain/exception/exception_type.dart';
import 'package:compare_prices/domain/usecases/disable_purchase_result_use_case.dart';
import 'package:compare_prices/domain/usecases/get_enabled_purchase_results_use_case.dart';
import 'package:compare_prices/domain/usecases/sort_purchase_results_use_case.dart';
import 'package:compare_prices/domain/usecases/use_case.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:state_notifier/state_notifier.dart';

import 'purchase_result_list_page_state.dart';

final purchaseResultListPageViewModelProvider = StateNotifierProvider<
        PurchaseResultListPageViewModel, PurchaseResultListPageState>(
    (ref) => PurchaseResultListPageViewModel(ref.read));

class PurchaseResultListPageViewModel
    extends StateNotifier<PurchaseResultListPageState> {
  final Reader _reader;
  late final _getPurchaseResultsUseCase =
      _reader(getEnabledPurchaseResultsUseCaseProvider);

  late final _sortPurchaseResultsUseCase =
      _reader(sortPurchaseResultsUseCaseProvider);

  late final _disablePurchaseResultByIdUseCase =
      _reader(deletePurchaseResultByIdUseCaseProvider);

  var _onExceptionHappened = StreamController<ExceptionType>.broadcast();
  StreamController<ExceptionType> get onExceptionHappened =>
      _onExceptionHappened;

  PurchaseResultListPageViewModel(this._reader)
      : super(const PurchaseResultListPageState());

  void getList() async {
    _getPurchaseResultsUseCase(NoParam()).then((result) {
      result.when(success: (purchaseResults) {
        state = state.copyWith(purchaseResults: purchaseResults);
      }, failure: (exception) {
        _onExceptionHappened.add(exception.exceptionType());
      });
    });
  }

  void updateSortType(PurchaseResultSortType sortType) {
    state = state.copyWith(sortType: sortType);
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

  void sort() {
    final sortedList = _sortPurchaseResultsUseCase(
            SortPurchaseResultsUseCaseParams(
                purchaseResults: state.purchaseResults,
                sortType: state.sortType))
        .dataOrThrow;

    state = state.copyWith(showingPurchaseResults: sortedList);
  }

  @override
  void dispose() {
    _onExceptionHappened.close();

    super.dispose();
  }
}
