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
    final selectedCommodity = useProvider(
        createPurchaseResultPageViewModelProvider
            .select((value) => value.selectedCommodity));
    final selectedShop = useProvider(createPurchaseResultPageViewModelProvider
        .select((value) => value.selectedShop));
    final purchaseDate = useProvider(createPurchaseResultPageViewModelProvider
        .select((value) => value.purchaseDate));
    final viewModel =
        useProvider(createPurchaseResultPageViewModelProvider.notifier);

    final formKey = useMemoized(() => GlobalKey<FormState>());

    final debouncer = Debouncer();

    useEffect(() {
      // 初期処理
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        viewModel.errorMessage.stream.listen((errorMessage) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage)),
          );
        });

        viewModel.onPurchaseResultCreated.stream.listen((_) {
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
          key: formKey,
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
                          text: selectedCommodity?.name ?? "選択して下さい",
                          onTap: () async {
                            final selectedCommodity =
                                await Navigator.of(context)
                                    .pushNamed<Commodity>(
                                        RouteName.selectCommodityPage);

                            viewModel
                                .updateSelectedCommodity(selectedCommodity);
                          },
                          validator: viewModel.validateCommodity,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 8.0),
                        child: PickerFormField(
                          labelText: "店舗",
                          text: selectedShop?.name ?? "選択して下さい",
                          onTap: () async {
                            final selectedShop = await Navigator.of(context)
                                .pushNamed<Shop>(RouteName.selectShopPage);

                            viewModel.updateSelectedShop(selectedShop);
                          },
                          validator: viewModel.validateShop,
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
                            return viewModel.validatePrice();
                          },
                          onChanged: (value) {
                            debouncer.run(() {
                              viewModel.updatePrice(value);
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 8.0),
                        child: PickerFormField(
                            labelText: "購入日",
                            text: DateFormat('yyyy-MM-dd').format(purchaseDate),
                            onTap: () async {
                              final picked = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2021),
                                  lastDate:
                                      DateTime.now().add(Duration(days: 360)));

                              viewModel.updatePurchaseDate(picked);
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
                      if (formKey.currentState?.validate() ?? false) {
                        viewModel.submit();
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
