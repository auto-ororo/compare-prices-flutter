import 'dart:async';

import 'package:compare_prices/domain/entities/commodity.dart';
import 'package:compare_prices/domain/exception/exception_extensions.dart';
import 'package:compare_prices/domain/usecases/update_commodity_use_case.dart';
import 'package:compare_prices/ui/commodity/update/update_commodity_dialog_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final updateCommodityDialogViewModelProvider = StateNotifierProvider.family
    .autoDispose<UpdateCommodityDialogViewModel, UpdateCommodityDialogState,
            Commodity>(
        (ref, commodity) =>
            UpdateCommodityDialogViewModel(ref.read, commodity));

class UpdateCommodityDialogViewModel
    extends StateNotifier<UpdateCommodityDialogState> {
  final Reader _reader;

  late final _updateCommodityUseCase = _reader(updateCommodityUseCaseProvider);

  final _onCommodityUpdated = StreamController<Commodity>();
  StreamController<Commodity> get onCommodityUpdated => _onCommodityUpdated;

  UpdateCommodityDialogViewModel(this._reader, commodity)
      : super(UpdateCommodityDialogState(commodity: commodity));

  void updateCommodity() {
    _updateCommodityUseCase(state.commodity).then((result) {
      result.when(success: (_) {
        _onCommodityUpdated.add(state.commodity);
      }, failure: (exception) {
        state =
            state.copyWith(happenedExceptionType: exception.exceptionType());
      });
    });
  }

  void updateName(String name) {
    state = state.copyWith(commodity: state.commodity.copyWith(name: name));
  }

  @override
  void dispose() {
    _onCommodityUpdated.close();

    super.dispose();
  }
}
