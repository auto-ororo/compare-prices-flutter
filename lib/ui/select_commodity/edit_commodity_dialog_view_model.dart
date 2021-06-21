import 'dart:async';

import 'package:compare_prices/domain/entities/commodity.dart';
import 'package:compare_prices/domain/exception/exception_extensions.dart';
import 'package:compare_prices/domain/usecases/update_commodity_use_case.dart';
import 'package:compare_prices/ui/select_commodity/edit_commodity_dialog_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final editCommodityDialogViewModelProvider = StateNotifierProvider.family
    .autoDispose<EditCommodityDialogViewModel, EditCommodityDialogState,
            Commodity>(
        (ref, commodity) => EditCommodityDialogViewModel(ref.read, commodity));

class EditCommodityDialogViewModel
    extends StateNotifier<EditCommodityDialogState> {
  final Reader _reader;

  late final UpdateCommodityUseCase _updateCommodityUseCase =
      _reader(updateCommodityUseCaseProvider);

  final _errorMessage = StreamController<String>();

  StreamController<String> get errorMessage => _errorMessage;

  final _onCommodityUpdated = StreamController<Commodity>();

  StreamController<Commodity> get onCommodityUpdated => _onCommodityUpdated;

  EditCommodityDialogViewModel(this._reader, commodity)
      : super(EditCommodityDialogState(commodity: commodity));

  void updateCommodity(String name) {
    final commodity = state.commodity.copyWith(name: name);
    _updateCommodityUseCase(commodity).then((result) {
      result.when(success: (_) {
        _onCommodityUpdated.add(commodity);
      }, failure: (exception) {
        print("getList failed ${exception.toString()}");
        _errorMessage.add(exception.errorMessage());
      });
    });
  }

  @override
  void dispose() {
    _errorMessage.close();
    _onCommodityUpdated.close();

    super.dispose();
  }
}
