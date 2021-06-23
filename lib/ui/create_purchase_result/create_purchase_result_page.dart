import 'package:compare_prices/domain/entities/commodity.dart';
import 'package:compare_prices/domain/entities/shop.dart';
import 'package:compare_prices/main.dart';
import 'package:compare_prices/ui/common/utils/debouncer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../common/picker_form_field.dart';
import 'create_purchase_result_page_view_model.dart';

class CreatePurchaseResultPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final _state = useProvider(createPurchaseResultPageViewModelProvider);
    final _viewModel =
        useProvider(createPurchaseResultPageViewModelProvider.notifier);

    final _formKey = useMemoized(() => GlobalKey<FormState>());

    final _debouncer = Debouncer();

    useEffect(() {
      // 初期処理
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        _viewModel.errorMessage.stream.listen((errorMessage) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage)),
          );
        });

        _viewModel.onPurchaseResultCreated.stream.listen((_) {
          Navigator.of(context).pop();
        });
      });

      return () {};
    }, const []);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('追加'),
        ),
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 8.0),
                        child: PickerFormField(
                          labelText: "商品",
                          text: _state.selectedCommodity?.name ?? "選択して下さい",
                          onTap: () async {
                            final selectedCommodity =
                                await Navigator.of(context)
                                    .pushNamed<Commodity>(
                                        RouteName.selectCommodityPage);

                            _viewModel
                                .updateSelectedCommodity(selectedCommodity);
                          },
                          validator: _viewModel.validateCommodity,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 8.0),
                        child: PickerFormField(
                          labelText: "店舗",
                          text: _state.selectedShop?.name ?? "選択して下さい",
                          onTap: () async {
                            final selectedShop = await Navigator.of(context)
                                .pushNamed<Shop>(RouteName.selectShopPage);

                            _viewModel.updateSelectedShop(selectedShop);
                          },
                          validator: _viewModel.validateShop,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 8.0),
                        child: TextFormField(
                          textAlign: TextAlign.end,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 4.0, horizontal: 8),
                              labelText: "価格"),
                          validator: (_) {
                            return _viewModel.validatePrice();
                          },
                          onChanged: (value) {
                            _debouncer.run(() {
                              _viewModel.updatePrice(value);
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 8.0),
                        child: PickerFormField(
                            labelText: "購入日",
                            text: DateFormat('yyyy-MM-dd')
                                .format(_state.purchaseDate),
                            onTap: () async {
                              final picked = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2021),
                                  lastDate:
                                      DateTime.now().add(Duration(days: 360)));

                              _viewModel.updatePurchaseDate(picked);
                            }),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("登録", style: TextStyle(fontSize: 25)),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState?.validate() ?? false) {
                        _viewModel.submit();
                      }
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
