import 'dart:async';

import 'package:compare_prices/domain/exception/exception_extensions.dart';
import 'package:compare_prices/domain/exception/exception_type.dart';
import 'package:compare_prices/domain/usecases/create_commodity_by_name_use_case.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'create_commodity_dialog_state.dart';

final createCommodityDialogViewModelProvider = StateNotifierProvider
    .autoDispose<CreateCommodityDialogViewModel, CreateCommodityDialogState>(
        (ref) => CreateCommodityDialogViewModel(ref.read));

class CreateCommodityDialogViewModel
    extends StateNotifier<CreateCommodityDialogState> {
  final Reader _reader;

  late final _createCommodityByNameUseCase =
      _reader(createCommodityByNameUseCaseProvider);

  final _onExceptionHappened = StreamController<ExceptionType>();
  StreamController<ExceptionType> get onExceptionHappened =>
      _onExceptionHappened;

  final _onCommodityCreated = StreamController<void>();
  StreamController<void> get onCommodityCreated => _onCommodityCreated;

  CreateCommodityDialogViewModel(this._reader)
      : super(const CreateCommodityDialogState());

  void createCommodity() {
    _createCommodityByNameUseCase(state.name).then((result) {
      result.when(success: (_) {
        _onCommodityCreated.add(_);
      }, failure: (exception) {
        _onExceptionHappened.add(exception.exceptionType());
      });
    });
  }

  void updateName(String name) {
    state = state.copyWith(name: name);
  }

  @override
  void dispose() {
    _onExceptionHappened.close();
    _onCommodityCreated.close();

    super.dispose();
  }
}
