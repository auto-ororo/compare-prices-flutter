import 'dart:async';

import 'package:compare_prices/domain/entities/commodity.dart';
import 'package:compare_prices/domain/entities/shop.dart';
import 'package:compare_prices/domain/exception/exception_extensions.dart';
import 'package:compare_prices/domain/exception/exception_type.dart';
import 'package:compare_prices/domain/usecases/create_purchase_result_use_case.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:state_notifier/state_notifier.dart';

import 'create_purchase_result_page_state.dart';

final createPurchaseResultPageViewModelProvider = StateNotifierProvider.family
    .autoDispose<CreatePurchaseResultPageViewModel,
            CreatePurchaseResultPageState, Commodity?>(
        (ref, initialCommodity) =>
            CreatePurchaseResultPageViewModel(ref.read, initialCommodity));

class CreatePurchaseResultPageViewModel
    extends StateNotifier<CreatePurchaseResultPageState> {
  final Reader _reader;

  late final _createPurchaseResultUseCase =
      _reader(createPurchaseResultUseCaseProvider);

  var _onExceptionHappened = StreamController<ExceptionType>();
  StreamController<ExceptionType> get onExceptionHappened =>
      _onExceptionHappened;

  final _onPurchaseResultCreated = StreamController<void>();
  StreamController<void> get onPurchaseResultCreated =>
      _onPurchaseResultCreated;

  final date = DateTime.now();

  CreatePurchaseResultPageViewModel(this._reader, Commodity? initialCommodity)
      : super(CreatePurchaseResultPageState(
            purchaseDate: DateTime.now(), selectedCommodity: initialCommodity));

  void updatePurchaseDate(DateTime? purchaseDate) {
    if (purchaseDate != null) {
      state = state.copyWith(purchaseDate: purchaseDate);
    }
  }

  void updatePrice(String priceStr) {
    var price = 0;
    if (priceStr.isNotEmpty) {
      price = int.parse(priceStr);
    }
    state = state.copyWith(price: price);
  }

  void updateCount(int? count) {
    if (count != null) {
      state = state.copyWith(count: count);
    }
  }

  void updateSelectedCommodity(Commodity? selectedCommodity) {
    if (selectedCommodity != null) {
      state = state.copyWith(selectedCommodity: selectedCommodity);
    }
  }

  void updateSelectedShop(Shop? selectedShop) {
    if (selectedShop != null) {
      state = state.copyWith(selectedShop: selectedShop);
    }
  }

  String? validateShop(BuildContext context) {
    if (state.selectedShop == null) {
      return AppLocalizations.of(context)!.createPurchaseResultInvalidShop;
    }
    return null;
  }

  String? validateCommodity(BuildContext context) {
    if (state.selectedCommodity == null) {
      return AppLocalizations.of(context)!.createPurchaseResultInvalidCommodity;
    }
    return null;
  }

  String? validatePrice(BuildContext context) {
    if (state.price == 0) {
      return AppLocalizations.of(context)!.createPurchaseResultInvalidPrice;
    }
    return null;
  }

  void submit() async {
    final params = CreatePurchaseResultUseCaseParams(
        commodityId: state.selectedCommodity!.id,
        shopId: state.selectedShop!.id,
        price: state.price,
        count: state.count,
        purchaseDate: state.purchaseDate);

    _createPurchaseResultUseCase(params).then((result) {
      result.when(success: (_) {
        _onPurchaseResultCreated.add(_);
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
