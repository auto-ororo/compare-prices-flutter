import 'package:compare_prices/main.dart';
import 'package:compare_prices/ui/commodity/commodity_row_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'commodity_list_page_view_model.dart';

class CommodityListPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final state = useProvider(commodityListPageViewModelProvider);
    final viewModel = useProvider(commodityListPageViewModelProvider.notifier);

    final textEditingController = useTextEditingController();

    useEffect(() {
      // 初期処理
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        viewModel.getList();

        print("viewModel.errorMessage.stream.listen");
        viewModel.errorMessage.stream.listen((errorMessage) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage)),
          );
        });
      });

      return () {};
    }, const []);

    useEffect(() {
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        print("execute filter list");
        viewModel.filter();
      });
      return () => {};
    }, [state.searchWord, state.commodityRows]);

    return Scaffold(
      appBar: AppBar(
        title: const Text('底値リスト'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              decoration: const InputDecoration(
                  border: const OutlineInputBorder(),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8),
                  labelText: "商品名",
                  hintText: "商品名、店舗を入力してください"),
              controller: textEditingController,
              onChanged: (word) {
                viewModel.updateSearchWord(word);
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: state.filteredCommodityRows.length,
                itemBuilder: (context, index) {
                  final row = state.filteredCommodityRows[index];
                  return CommodityRowWidget(row, () {
                    print("${row.commodity.name} Tapped!!");
                  });
                }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).pushNamed(Const.addPurchaseResult);
          }),
    );
  }
}
