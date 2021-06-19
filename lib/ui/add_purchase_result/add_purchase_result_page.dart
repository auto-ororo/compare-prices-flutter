import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import 'add_purchase_result_page_view_model.dart';

class AddPurchaseResultPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final state = useProvider(addPurchaseResultPageViewModelProvider);
    final viewModel =
        useProvider(addPurchaseResultPageViewModelProvider.notifier);

    final dateInputController = useTextEditingController();
    dateInputController.text =
        DateFormat('yyyy-MM-dd').format(state.purchaseDate ?? DateTime.now());

    final priceInputController = useTextEditingController();
    priceInputController.text = state.price.toString();

    useEffect(() {
      // 初期処理
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        print("viewModel.errorMessage.stream.listen");
        viewModel.errorMessage.stream.listen((errorMessage) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage)),
          );
        });

        if (state.purchaseDate == null) {
          viewModel.updatePurchaseDate(DateTime.now());
        }
      });

      return () => {};
    }, const []);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('追加'),
        ),
        body: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
              child: TextFormField(
                textAlign: TextAlign.end,
                keyboardType: TextInputType.number,
                onChanged: (priceStr) {
                  viewModel.updatePrice(priceStr);
                },
                decoration: const InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 4.0, horizontal: 8),
                    labelText: "価格"),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
              child: TextFormField(
                textAlign: TextAlign.end,
                readOnly: true,
                enableInteractiveSelection: false,
                controller: dateInputController,
                decoration: const InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8),
                  labelText: "購入日",
                ),
                onTap: () async {
                  final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: new DateTime(2016),
                      lastDate:
                          new DateTime.now().add(new Duration(days: 360)));

                  if (picked != null) {
                    viewModel.updatePurchaseDate(picked);
                  }
                },
              ),
            ),
            Spacer(),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("登録", style: TextStyle(fontSize: 25)),
                  ),
                  onPressed: () => print("aa"),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
