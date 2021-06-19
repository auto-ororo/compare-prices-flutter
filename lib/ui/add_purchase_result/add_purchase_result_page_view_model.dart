import 'dart:async';

import 'package:compare_prices/ui/add_purchase_result/add_purchase_result_page_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:state_notifier/state_notifier.dart';

final addPurchaseResultPageViewModelProvider = StateNotifierProvider
    .autoDispose<AddPurchaseResultPageViewModel, AddPurchaseResultPageState>(
        (ref) => AddPurchaseResultPageViewModel(ref.read));

class AddPurchaseResultPageViewModel
    extends StateNotifier<AddPurchaseResultPageState> {
  final Reader _reader;

  var _errorMessage = StreamController<String>();
  StreamController<String> get errorMessage => _errorMessage;

  final date = DateTime.now();

  AddPurchaseResultPageViewModel(this._reader)
      : super(const AddPurchaseResultPageState());

  void updatePurchaseDate(DateTime purchaseDate) {
    state = state.copyWith(purchaseDate: purchaseDate);
  }

  void updatePrice(String priceStr) {
    state = state.copyWith(price: int.parse(priceStr));
  }

  @override
  void dispose() {
    _errorMessage.close();

    super.dispose();
  }
}
